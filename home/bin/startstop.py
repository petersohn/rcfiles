#!/usr/bin/env python3

import argparse
import os
import psutil
import json
import traceback

parser = argparse.ArgumentParser()
parser.add_argument('-p', '--pidfile', required=True)
parser.add_argument('prog', nargs='+')

args = parser.parse_args()

print(args)

def start():
    pid = os.posix_spawnp(args.prog[0], args.prog, os.environ)
    proc = psutil.Process(pid)
    time = proc.create_time()
    with open(args.pidfile, 'w') as f:
        json.dump({'pid': pid, 'time': time}, f)


def main():
    if not os.path.exists(args.pidfile):
        start()
        return

    try:
        with open(args.pidfile) as f:
            pid_data = json.load(f)
            pid = pid_data['pid']
            time = pid_data['time']
    except (OSError, json.JSONDecodeError, KeyError):
        traceback.print_exc()
        os.remove(args.pidfile)
        start()
        return

    try:
        proc = psutil.Process(pid)
    except psutil.NoSuchProcess:
        start()
        return

    if proc.create_time() == time:
        proc.terminate()
    else:
        start()

if __name__ == '__main__':
    main()
