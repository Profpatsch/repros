# `sh_test` doesn’t pass non-`shell_*` `data` targets as runfiles

This repro shows how the `data` attribute of `shell_test` silently ignores targets that are not shell rules.

This is not documented.

It is possible to work around this by wrapping the needed data into a `sh_library` rule, but this leads to problems when trying to wrap a target that instanciates a `test` rule (because of the arbitrary “normal rules can’t call tests” restriction). 

```
$ bazel version
Build label: 0.18.0- (@non-git)
Build target: bazel-out/k8-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
Build time: Tue Jan 1 00:00:00 1980 (315532800)
Build timestamp: 315532800
Build timestamp as int: 315532800


$ bazel test --test_output=errors :example@test_bad
Starting local Bazel server and connecting to it...
INFO: Analysed target //:example@test_bad (18 packages loaded).
INFO: Found 1 test target...
FAIL: //:example@test_bad (see /home/philip/.cache/bazel/_bazel_philip/1b1756fc582d7cbe2ee83fd65715a88a/execroot/__main__/bazel-out/k8-fastbuild/testlogs/example@test_bad/test.log)
INFO: From Testing //:example@test_bad:
==================== Test output for //:example@test_bad:
+ echo files: ./a
files: ./a
+ grep -e a ./a
grep: ./a: No such file or directory
================================================================================
Target //:example@test_bad up-to-date:
  bazel-bin/example@test_bad
INFO: Elapsed time: 5.918s, Critical Path: 0.15s
INFO: 1 process: 1 processwrapper-sandbox.
INFO: Build completed, 1 test FAILED, 3 total actions
//:example@test_bad                                                      FAILED in 0.1s
  /home/philip/.cache/bazel/_bazel_philip/1b1756fc582d7cbe2ee83fd65715a88a/execroot/__main__/bazel-out/k8-fastbuild/testlogs/example@test_bad/test.log

INFO: Build completed, 1 test FAILED, 3 total actions


$ bazel test --test_output=errors :example@test_good
INFO: Analysed target //:example@test_good (0 packages loaded).
INFO: Found 1 test target...
Target //:example@test_good up-to-date:
  bazel-bin/example@test_good
INFO: Elapsed time: 0.346s, Critical Path: 0.07s
INFO: 1 process: 1 processwrapper-sandbox.
INFO: Build completed successfully, 3 total actions
//:example@test_good                                                     PASSED in 0.1s

Executed 1 out of 1 test: 1 test passes.
INFO: Build completed successfully, 3 total actions

```