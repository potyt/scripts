import subprocess

executable = "test-online"

def run():
    process = subprocess.Popen([executable], stdout=subprocess.PIPE)
    out, err = process.communicate()
    status = process.returncode
    return status, "WWW"
