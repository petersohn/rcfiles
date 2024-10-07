#!/usr/bin/python3
import os
import sys
import json

proxy_command = sys.argv[0]
command = os.path.basename(proxy_command)
proxy_command_dir = os.path.dirname(proxy_command)
args = sys.argv[1:]

try:
    with open(os.path.join(proxy_command_dir, command + ".env.json")) as f:
        env_list = json.load(f)
        envs = [(env, os.getenv(env)) for env in env_list]
except FileNotFoundError:
    envs = None

with open(os.path.join(os.getenv("HOME") or "", command + ".log"), "a") as f:
    print("{}: {} {}".format(os.getcwd(), envs or "", args), file=f)

for path in os.get_exec_path():
    cmd = os.path.join(path, command)
    if os.path.exists(cmd) and not os.path.samefile(cmd, proxy_command):
        argv = [cmd]
        argv.extend(args)
        os.execv(cmd, argv)

print("Command not found in PATH:", command, file=sys.stderr)
sys.exit(1)
