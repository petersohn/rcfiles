#!/usr/bin/env python3

import os
import argparse
import json
import fnmatch

parser = argparse.ArgumentParser(prog='sync-dir')
parser.add_argument('--source', required=True)
parser.add_argument('--target', required=True)
parser.add_argument('--config', required=True)
parser.add_argument('--filter', nargs='*')

args = parser.parse_args()

if os.path.exists(args.config):
    with open(args.config) as f:
        config = json.load(f)
else:
    config = {'files': []}

source_dir = os.path.realpath(args.source, strict=True)
target_dir = os.path.realpath(args.target, strict=True)

saved_files = {f['source']: f['target'] for f in config['files']}

for source, target in saved_files.items():
    try:
        target_link = os.path.realpath(target)
    except OSError:
        continue
    if target_link == source and not os.path.exists(source):
        print('DEL', target)
        os.remove(target)

current_files = {}

def get_target_name(name):
    return os.path.join(target_dir, name)

def already_exists(name):
    path = get_target_name(name)
    return path in current_files or os.path.exists(path)

for path, dirs, files in os.walk(source_dir):
    for name in files:
        if args.filter:
            for f in args.filter:
                if fnmatch.fnmatch(name, f):
                    break
            else:
                continue
        source_path = os.path.join(path, name)
        target_path = saved_files.get(source_path)
        if target_path is None:
            if already_exists(name):
                i = 1
                ext_pos = name.rfind('.')
                if ext_pos >= 0:
                    base = name[0:ext_pos]
                    ext = name[ext_pos:]
                else:
                    base = name
                    ext = ''
                new_name = None
                i = 1
                while new_name is None or already_exists(new_name):
                    i += 1
                    new_name = '{}_{}{}'.format(base, i, ext)
            else:
                new_name = name
            target_path = get_target_name(new_name)
        current_files[target_path] = source_path

config['files'] = [{'source': s, 'target': t} for t, s in current_files.items()]
with open(args.config, 'w') as f:
    json.dump(config, f)

for target, source in current_files.items():
    if not os.path.exists(target):
        print('{} -> {}'.format(source, target))
        os.symlink(source, target)


