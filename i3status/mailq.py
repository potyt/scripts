import subprocess

executable = "msmtp-countqueue"

def run():
    process = subprocess.Popen([executable], stdout=subprocess.PIPE)
    out, err = process.communicate()
    status = process.returncode
    out_str = out.decode("ascii").strip()
    count = int(out_str)
    return status if status != 0 else count > 0, "%i>" % count
