import argparse
from ast import Call
import time
import io
import os
import sys
import psutil
import json
import traceback
import threading
import signal
from typing import Any, final, Callable, override
import paho.mqtt.client as mqttc
import paho.mqtt.enums as mqtte
import paho.mqtt.reasoncodes as mqttr
import paho.mqtt.properties as mqttp
from watchdog.observers import Observer
import watchdog.events as fsevents


@final
class FileLock:
    def __init__(self, path: str):
        self.path = path
        self.lock_fd: io.IOBase | None = None

    def lock(self):
        if self.lock_fd is None:
            self.lock_fd = open(self.path, "x")

    def unlock(self):
        if self.lock_fd is not None:
            self.lock_fd.close()
            self.lock_fd = None
            os.remove(self.path)

    def __enter__(self):
        self.lock()

    def __exit__(self, exc_type: Any, exc_value: Any, traceback: Any):
        self.unlock()


def get_value(value: Any, type_: type, default: Any = None) -> Any:
    if value is None:
        return default

    return type_(value)


def get_bool_value(value: str) -> bool:
    lower = value.lower()
    if lower in ["on", "true"]:
        return True
    if lower in ["off", "false"]:
        return False
    return int(value) != 0


def throw_mqtt_error(error_code: mqtte.MQTTErrorCode) -> None:
    if error_code != mqtte.MQTTErrorCode.MQTT_ERR_SUCCESS:
        raise RuntimeError("MQTT Error {}".format(error_code))


def log_mqtt_error(error_code: mqtte.MQTTErrorCode) -> None:
    if error_code != mqtte.MQTTErrorCode.MQTT_ERR_SUCCESS:
        print("MQTT Error {}".format(error_code), file=sys.stderr)


@final
class FileModifyEventHandler(fsevents.FileSystemEventHandler):
    def __init__(self, path: str, callback: Callable[[], None]):
        self.path = path
        self.callback = callback

    @override
    def on_any_event(self, event: fsevents.FileSystemEvent) -> None:
        if event.src_path == self.path:
            self.callback()


@final
class StartStop:
    def __init__(self):
        self.prog: list[str] = []
        self.pidfile = ""
        self.mqtt_host = ""
        self.mqtt_port = 1883
        self.mqtt_username: str | None = None
        self.mqtt_password: str | None = None
        self.mqtt_client_id: str | None = None
        self.mqtt_command_topic = ""
        self.mqtt_status_topic = ""
        self.mqtt_status_retain = False
        self.mqtt_availability_topic: str | None = None

        self.current_status: bool | None = None
        self.sent_status: bool | None = None
        self.set_status: bool | None = None
        self.last_process: psutil.Process | None = None
        self.process_to_stop: psutil.Process | None = None
        self.process_stop_time: float | None = None
        self.delay = 0
        self.need_to_exit = False
        self.condition = threading.Condition()

        self.mqtt_client: mqttc.Client | None = None
        self.mqtt_connected = False
        self.availability_mid: int | None = None

    def add_config_file(self, path: str) -> None:
        with open(path) as f:
            obj: dict[str, Any] = json.load(f)
        assert type(obj) == dict, "Invalid config file"
        self._parse_prog(obj.get("program"))
        self._parse_pidfile(obj.get("pidfile"))
        mqtt = obj.get("mqtt")
        if mqtt is not None:
            self._parse_mqtt_server(mqtt.get("server"))
            self._parse_mqtt_client(mqtt.get("client"))

    def _parse_pidfile(self, pidfile: Any) -> None:
        if pidfile is None:
            return
        ret: str = get_value(pidfile, str)
        assert ret != "", "Pidfile cannot be empty"
        self.pidfile = ret

    def _parse_prog(self, prog: Any) -> None:
        if prog is None:
            return

        if type(prog) is list:
            self.prog = [get_value(arg, str) for arg in prog]
        else:
            assert type(prog) is str, "Invalid config file"
            self.prog = ["sh", "-c", prog]

    def _parse_mqtt_server(self, server: Any) -> None:
        if server is None:
            return

        self.mqtt_host = get_value(server["host"], str)
        port = get_value(server.get("port"), int, True)
        self.mqtt_port = port if port is not None else 1883
        self.mqtt_username = get_value(server.get("username"), str)
        self.mqtt_password = get_value(server.get("password"), str)

    def _parse_mqtt_client(self, client: Any) -> None:
        if client is None:
            return

        self.mqtt_client_id = get_value(client.get("client_id"), str)
        self.mqtt_command_topic = get_value(client["command_topic"], str)
        self.mqtt_status_topic = get_value(client["status_topic"], str)
        self.mqtt_status_retain = get_value(
            client["status_retain"], bool, False
        )
        self.mqtt_availability_topic = get_value(
            client.get("availability_topic"), str
        )

    def pidfile_lock(self):
        return FileLock(self.pidfile + ".lock")

    def check_process(self) -> psutil.Process | None:
        if not os.path.exists(self.pidfile):
            return None

        try:
            with open(self.pidfile) as f:
                pid_data = json.load(f)
                pid = pid_data["pid"]
                time = pid_data["time"]
        except (OSError, json.JSONDecodeError, KeyError):
            traceback.print_exc(file=sys.stderr)
            os.remove(self.pidfile)
            return None

        try:
            proc = psutil.Process(pid)
        except psutil.NoSuchProcess:
            return None

        return proc if proc.create_time() == time else None

    def start(self) -> None:
        pid = os.posix_spawnp(self.prog[0], self.prog, os.environ)
        proc = psutil.Process(pid)
        time = proc.create_time()
        with open(self.pidfile, "w") as f:
            json.dump({"pid": pid, "time": time}, f)

    def start_or_stop(self, start: bool, stop: bool) -> int:
        with self.pidfile_lock():
            process = self.check_process()
            if process is None:
                if stop:
                    print("Not running.", file=sys.stderr)
                    return 1
                self.start()
            else:
                if start:
                    print("Already running.", file=sys.stderr)
                    return 1
                process.terminate()
                try:
                    _ = process.wait(5)
                except psutil.TimeoutExpired:
                    process.kill()
                    _ = process.wait(1)
                os.remove(self.pidfile)

        return 0

    def stop_mqtt(self) -> None:
        with self.condition:
            self.need_to_exit = True
            self.condition.notify_all()

    def wake_up(self) -> None:
        with self.condition:
            self.condition.notify()

    def run_mqtt(self) -> None:
        assert (
            self.mqtt_host
            and self.mqtt_command_topic
            and self.mqtt_status_topic
        )

        self.mqtt_connected = False
        self.mqtt_client = mqttc.Client(mqtte.CallbackAPIVersion.VERSION2)
        self.mqtt_client.username_pw_set(self.mqtt_username, self.mqtt_password)
        if self.mqtt_availability_topic is not None:
            self.mqtt_client.will_set(
                self.mqtt_availability_topic, "0", retain=True
            )
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_disconnect = self.on_disconnect
        self.mqtt_client.on_publish = self.on_publish
        self.mqtt_client.on_message = self.on_message

        throw_mqtt_error(self.mqtt_client.loop_start())
        self.mqtt_client.connect_async(self.mqtt_host, self.mqtt_port)

        observer = Observer()
        _ = observer.schedule(
            FileModifyEventHandler(self.pidfile, self.on_pidfile_changed),
            os.path.dirname(self.pidfile),
            recursive=False,
            event_filter=[
                fsevents.FileMovedEvent,
                fsevents.FileDeletedEvent,
                fsevents.FileCreatedEvent,
                fsevents.FileModifiedEvent,
            ],
        )
        observer.start()

        try:
            while True:
                with self.condition:
                    if self.need_to_exit:
                        return
                    try:
                        if self.mqtt_connected:
                            self._loop()
                        else:
                            self.delay = 60
                    except KeyboardInterrupt:
                        raise
                    except Exception:
                        traceback.print_exc(file=sys.stderr)
                        self.delay = 1

                    _ = self.condition.wait(self.delay)
        except KeyboardInterrupt:
            print("Interrupted.", file=sys.stderr)
        finally:
            observer.stop()
            log_mqtt_error(self.mqtt_client.loop_stop())
            observer.join()

    def _loop(self):
        assert self.mqtt_client is not None

        if self.last_process is not None:
            try:
                _ = self.last_process.wait(0)
                self.last_process = None
                self.sent_status = None
            except psutil.TimeoutExpired:
                pass

        status_to_send: bool | None = None
        if self.sent_status is None or self.set_status is not None:
            try:
                with self.pidfile_lock():
                    if (
                        self.last_process is not None
                        and self.last_process.is_running()
                    ):
                        process = self.last_process
                        is_running = True
                    else:
                        process = self.check_process()
                        self.last_process = process
                        is_running = process is not None

                    print("is_running={}".format(is_running), file=sys.stderr)
                    if self.sent_status != is_running:
                        status_to_send = is_running

                    if is_running and self.set_status is False:
                        print("Stop", file=sys.stderr)
                        assert process is not None
                        process.terminate()
                        self.process_to_stop = process
                        self.process_stop_time = time.time()
                    elif not is_running and self.set_status is True:
                        print("Start", file=sys.stderr)
                        self.start()
                    self.set_status = None
            except FileExistsError:
                print("Pidfile is locked.", file=sys.stderr)
                self.delay = 0.1

        if self.process_to_stop is not None:
            assert self.process_stop_time is not None

            if self.process_to_stop != self.last_process:
                self.process_to_stop = None
                self.process_stop_time = None
            elif time.time() - self.process_stop_time > 5:
                self.process_to_stop.kill()

        if (
            self.process_to_stop is not None
            and self.process_to_stop.ppid() != os.getpid()
        ):
            self.delay = 0.1
        elif (
            self.last_process is not None
            and self.last_process.ppid() != os.getpid()
        ):
            self.delay = 1
        else:
            self.delay = 60

        if status_to_send is not None:
            self.sent_status = None
            _ = self.mqtt_client.publish(
                self.mqtt_status_topic,
                "1" if status_to_send else "0",
                retain=self.mqtt_status_retain,
            )
            self.sent_status = status_to_send

    def on_connect(
        self,
        client: mqttc.Client,
        _userdata: Any,
        _connect_flags: dict[str, Any],
        reason_code: mqttr.ReasonCode,
        _properties: mqttp.Properties | None,
    ):
        if self.mqtt_client is not client:
            return

        if reason_code.is_failure:
            print("MQTT connection failure: {}".format(reason_code.getName()))
            return

        if self.mqtt_availability_topic is not None:
            ret = client.publish(self.mqtt_availability_topic, "1", retain=True)
            self.availability_mid = ret.mid

        _ = client.subscribe(self.mqtt_command_topic)

        with self.condition:
            self.mqtt_connected = True
            self.sent_status = None
            self.condition.notify()

    def on_disconnect(
        self,
        client: mqttc.Client,
        _userdata: Any,
        _disconnect_flags: mqttc.DisconnectFlags,
        reason_code: mqttr.ReasonCode,
        _properties: mqttp.Properties | None,
    ):
        if self.mqtt_client is not client:
            return

        print("MQTT disconnected: {}".format(reason_code.getName()))
        with self.condition:
            self.mqtt_connected = False

    def on_publish(
        self,
        client: mqttc.Client,
        _userdata: Any,
        mid: int,
        reason_code: mqttr.ReasonCode,
        _properties: mqttp.Properties | None,
    ):
        if self.mqtt_client is not client:
            return

        if reason_code.is_failure:
            print("MQTT publish failure: {}".format(reason_code.getName()))
            if mid != self.availability_mid:
                with self.condition:
                    self.sent_status = None
                    self.condition.notify()

    def on_message(
        self, client: mqttc.Client, _userdata: Any, message: mqttc.MQTTMessage
    ):
        if self.mqtt_client is not client:
            return

        if message.topic == self.mqtt_command_topic:
            payload = message.payload.decode()
            try:
                print("Got command: {}".format(payload), file=sys.stderr)
                value = get_bool_value(payload)
            except ValueError:
                print("Invalid value: {}".format(payload), file=sys.stderr)
                return
            with self.condition:
                self.set_status = value
                self.condition.notify()

    def on_pidfile_changed(self):
        with self.condition:
            self.sent_status = None
            self.condition.notify()


def main() -> int:
    parser = argparse.ArgumentParser()
    _ = parser.add_argument("-p", "--pidfile")
    _ = parser.add_argument("--start", action="store_true")
    _ = parser.add_argument("--stop", action="store_true")
    _ = parser.add_argument("--config", nargs="*")
    _ = parser.add_argument("prog", nargs="*")

    args = parser.parse_args()
    if args.start and args.stop:
        print("Only one of --start and --stop is allowed", file=sys.stderr)
        return 1

    start_stop = StartStop()
    for path in args.config:
        start_stop.add_config_file(path)
    if args.prog:
        start_stop.prog = args.prog
    if args.pidfile:
        start_stop.pidfile = args.pidfile

    if not args.stop and not start_stop.prog:
        print("Prog is necessary when starting", file=sys.stderr)
        return 1

    if start_stop.mqtt_host:
        _ = signal.signal(signal.SIGCHLD, lambda *_: start_stop.wake_up())
        thread = threading.Thread(target=start_stop.run_mqtt)
        thread.start()
        try:
            thread.join()
        except KeyboardInterrupt:
            print("Interrupted.", file=sys.stderr)
            start_stop.stop_mqtt()
            thread.join()
        return 0

    return start_stop.start_or_stop(args.start, args.stop)


if __name__ == "__main__":
    sys.exit(main())
