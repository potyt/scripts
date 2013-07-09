import sys, subprocess

executable = "gpg-cache-key"

def run():
    if not sys.stdout.isatty():
        process = subprocess.Popen([executable], stdout=subprocess.PIPE)
        out, err = process.communicate()
        status = process.returncode
        if status != 0:
            status = 1
    else:
        status = 2
    return (status, "GPG")
