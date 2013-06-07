#!/usr/bin/env python

import os
import sys
import json
import subprocess

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)

        # add script modules
        home = os.path.expanduser("~")
        modules = os.path.join(home, ".config/i3status/modules")
        for module in reversed(os.listdir(modules)):
            path = os.path.join(modules, module)
            process = subprocess.Popen([path], stdout=subprocess.PIPE)
            out, err = process.communicate()
            j.insert(0, {"full_text" : "%s " % out.decode("ascii").strip(), "name" : "message"})

        print_line(prefix+json.dumps(j))
