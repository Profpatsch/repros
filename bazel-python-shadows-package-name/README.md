# Python packages are shadowed by bazel-tools

## Description

Python’s import system has the … interesting property that a package
on `PYTHONPATH` that has the same name as an other package on
`PYTHONPATH` silently shadows the second package. For example:

```
$ find
.
./pkg_a
./pkg_a/__init__.py
./pkg_a/tools
./pkg_a/tools/__init__.py
./pkg_a/tools/__init__.pyc
./pkg_b
./pkg_b/__init__.py
./pkg_b/tools
./pkg_b/tools/__init__.py
./pkg_b/tools/foo.py
./pkg_b/tools/__init__.pyc
./pkg_b/tools/foo.pyc

$ cat pkg_b/tools/foo.py
def foo():
  return 43

$ env PYTHONPATH="$(pwd)/pkg_a:$(pwd)/pkg_b" python -c 'from tools.foo import foo; print(foo())'
Traceback (most recent call last):
  File "<string>", line 1, in <module>
ImportError: No module named foo

$ env PYTHONPATH="$(pwd)/pkg_b" python -c 'from tools.foo import foo; print(foo())'
43
```

In this repro we show a similar problem with `@bazel_tools` that has
hit us in [`rules_haskell`](https://github.com/tweag/rules_haskell).
We have a `/tools` folder in that project that should contain a
`py_library` to help with debugging. Strangely, it was kind of
impossible to import that library. Turns out `@bazel_tools` also has a
`tools` package which implicitely shadows our package in the
`PYTHONPATH` constructed by bazel.

The way one is expected to import `py_library`s is practically not
documented in
[`python_rules`](https://docs.bazel.build/versions/0.21.0/be/python.html),
this made it even harder to find out what went awry and why.

Please take a look at the files in this repro, especially at
`./BUILD`.

## Repro output

This repro uses `bazel 0.20/0.21` and `python2`.

If you have `nix` installed you can use `nix-shell` to exactly
reproduce the environment at the time of the creation of this repro.

```
$ bazel run :bin-good
INFO: Invocation ID: a44bf7cd-3ae4-41e1-86de-f66cd1588bed
INFO: Analysed target //:bin-good (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:bin-good up-to-date:
  bazel-bin/bin-good
INFO: Elapsed time: 0.156s, Critical Path: 0.01s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
PYTHONPATH entries:
/home/philip/kot/repros/bazel-python-shadows-package-name
bazel-bazel-python-shadows-package-name  bazel-bin  bazel-genfiles  bazel-out  bazel-testlogs  bin.py  BUILD  lib  README.md  shell.nix  tools	WORKSPACE
/home/philip/.cache/bazel/_bazel_philip/14521cf5ac30b211ae8f4700172464f5/execroot/zzz/bazel-out/k8-fastbuild/bin/bin-good.runfiles
MANIFEST  zzz
/home/philip/.cache/bazel/_bazel_philip/14521cf5ac30b211ae8f4700172464f5/execroot/zzz/bazel-out/k8-fastbuild/bin/bin-good.runfiles/zzz
bin-good  bin.py  tools
42

$ bazel run :bin-bad
INFO: Invocation ID: 97606efd-fa35-487c-9ace-861f62fb132e
INFO: Analysed target //:bin-bad (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:bin-bad up-to-date:
  bazel-bin/bin-bad
INFO: Elapsed time: 0.127s, Critical Path: 0.01s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
PYTHONPATH entries:
/home/philip/kot/repros/bazel-python-shadows-package-name
bazel-bazel-python-shadows-package-name  bazel-bin  bazel-genfiles  bazel-out  bazel-testlogs  bin.py  BUILD  lib  README.md  shell.nix  tools	WORKSPACE
/home/philip/.cache/bazel/_bazel_philip/14521cf5ac30b211ae8f4700172464f5/execroot/zzz/bazel-out/k8-fastbuild/bin/bin-bad.runfiles
bazel_tools  __init__.py  MANIFEST  zzz
/home/philip/.cache/bazel/_bazel_philip/14521cf5ac30b211ae8f4700172464f5/execroot/zzz/bazel-out/k8-fastbuild/bin/bin-bad.runfiles/bazel_tools
__init__.py  tools
/home/philip/.cache/bazel/_bazel_philip/14521cf5ac30b211ae8f4700172464f5/execroot/zzz/bazel-out/k8-fastbuild/bin/bin-bad.runfiles/zzz
bin-bad  bin.py  external
Traceback (most recent call last):
  File "/home/philip/.cache/bazel/_bazel_philip/14521cf5ac30b211ae8f4700172464f5/execroot/zzz/bazel-out/k8-fastbuild/bin/bin-bad.runfiles/zzz/bin.py", line 13, in <module>
    from tools.lib import foo
ImportError: No module named lib
```

## Discussion

It’s a bit hard to pin down what the exact change should be.
However it’s solved, the remaining traps should be clearly documented
in the python rules docstrings.

The [documentation of
`bazel_tools`](https://github.com/bazelbuild/bazel/blob/master/tools/python/runfiles/runfiles.py)
already states that the module should be imported like this:

```
from bazel_tools.tools.python.runfiles import runfiles
```

So it was doubly suprising it’s also imported non-namespaced.
I propose removing the non-namespaced import for all such magic
modules.

I haven’t checked the behaviour of python modules from external
repositories, but I suspect there might me more such problems hiding
in that logic.

A last possible change is to keep the dependency ordering of the
`deps` field stable instead of lexically sorting by name. That is a
bit too implicit for my taste though.
