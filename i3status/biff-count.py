import subprocess

executable = "biff-count"

def run():
    process = subprocess.Popen([executable], stdout=subprocess.PIPE)
    out, err = process.communicate()
    status = process.returncode
    out_str = out.decode("ascii").strip()
    return status if status != 0 else out_str != "0", "%s<" % out_str
