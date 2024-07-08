#!/usr/bin/env python3

import argparse
import filecmp
import os
import subprocess
import sys
import tempfile
import threading
import traceback
import queue

def process_file(path, command):
    tmp_file_name = None
    try:
        try:
            tmp_fd, tmp_file_name = tempfile.mkstemp(dir=os.path.dirname(path))
            has_filename = False
            for i in range(len(command)):
                if command[i] == '{}':
                    command[i] = path
                    has_filename = True

            if has_filename:
                stdin = subprocess.DEVNULL
            else:
                stdin = open(path, mode='rb')

            try:
                result = subprocess.run(command, stdin=stdin, stdout=tmp_fd)
            finally:
                if not has_filename:
                    stdin.close()
        finally:
            os.close(tmp_fd)

        if result.returncode == 0 and not filecmp.cmp(tmp_file_name, path, shallow=False):
            os.replace(tmp_file_name, path)
            tmp_file_name = None
    finally:
        if tmp_file_name is not None:
            os.remove(tmp_file_name)


def do_process(path, command):
    if not path:
        return
    try:
        process_file(path, command[:])
    except Exception:
        traceback.print_exc(file=sys.stderr)


def run_thread(q, command, state):
    while not state['finished'] or not q.empty():
        try:
            path = q.get(timeout=0.1)
        except queue.Empty:
            continue
        do_process(path, command)


def run(files, jobs, command):
    assert jobs >= 1
    if jobs == 1:
        for f in files:
            do_process(f, command)
        return

    q = queue.Queue()

    state = {'finished': False}
    threads = [threading.Thread(target=run_thread, args=[q, command, state])
               for i in range(jobs)]
    for t in threads:
        t.start()

    for f in files:
        q.put(f)
    state['finished'] = True

    for t in threads:
        t.join()


parser = argparse.ArgumentParser(
    description='Run a filter (e.g. sed) to a list of files. The program '
    'should print the output to the standard output. Only modify files when '
    'they are actually changed.')

parser.add_argument('-j', '--jobs', type=int, default=1)
parser.add_argument('-f', '--files', nargs='*')
parser.add_argument('command', nargs='+')

args = parser.parse_args()

if args.files:
    files = args.files
else:
    files = (line.rstrip('\r\n') for line in sys.stdin)

run(files, args.jobs, args.command)
