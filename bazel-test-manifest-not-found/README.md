# `bazel test` cannot find the `MANIFEST` file

With `bazel 0.17rc1` on `GNU/systemd/Linux 4.14`:

Running it works as expected:

```
$ bazel run //:test-manifest-file
INFO: Analysed target //:test-manifest-file (0 packages loaded).
INFO: Found 1 target...
Target //:test-manifest-file up-to-date:
  bazel-bin/test-manifest-file
INFO: Elapsed time: 0.214s, Critical Path: 0.00s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
exec ${PAGER:-/usr/bin/less} "$0" || exit 1
Executing tests from //:test-manifest-file
-----------------------------------------------------------------------------
Manifest:
__main__/test-manifest-file /home/philip/.cache/bazel/_bazel_philip/fed589667d20cb7d0606716b1ab88ded/execroot/__main__/bazel-out/k8-fastbuild/bin/test-manifest-file
__main__/test.sh /home/philip/code/repros/bazel-test-manifest-not-found/test.sh
YAY
```

But when actually running the target as a test:

```
$ bazel test //:test-manifest-file
INFO: Analysed target //:test-manifest-file (0 packages loaded).
INFO: Found 1 test target...
FAIL: //:test-manifest-file (see /home/philip/.cache/bazel/_bazel_philip/fed589667d20cb7d0606716b1ab88ded/execroot/__main__/bazel-out/k8-fastbuild/testlogs/test-manifest-file/test.log)
Target //:test-manifest-file up-to-date:
  bazel-bin/test-manifest-file
INFO: Elapsed time: 0.248s, Critical Path: 0.09s
INFO: 1 process: 1 processwrapper-sandbox.
INFO: Build completed, 1 test FAILED, 2 total actions
//:test-manifest-file                                                    FAILED in 0.1s
  /home/philip/.cache/bazel/_bazel_philip/fed589667d20cb7d0606716b1ab88ded/execroot/__main__/bazel-out/k8-fastbuild/testlogs/test-manifest-file/test.log

INFO: Build completed, 1 test FAILED, 2 total actions

$ cat /home/philip/.cache/bazel/_bazel_philip/fed589667d20cb7d0606716b1ab88ded/execroot/__main__/bazel-out/k8-fastbuild/testlogs/test-manifest-file/test.log
exec ${PAGER:-/usr/bin/less} "$0" || exit 1
Executing tests from //:test-manifest-file
-----------------------------------------------------------------------------
Manifest:
cat: /home/philip/.cache/bazel/_bazel_philip/fed589667d20cb7d0606716b1ab88ded/sandbox/processwrapper-sandbox/1/execroot/__main__/bazel-out/k8-fastbuild/bin/test-manifest-file.runfiles/MANIFEST: No such file or directory
```

Which means the environment variable is not set correctly inside of `bazel test`.