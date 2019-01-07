import sys
import subprocess

print("PYTHONPATH entries:")
# print entries of PYTHONPATH and their contents
for f in sys.path:
    # but only the bazel ones
    if "bazel" in f:
        print(f)
        subprocess.call(["ls", f])


from tools.lib import foo

# now try to call the lib function
foo()
