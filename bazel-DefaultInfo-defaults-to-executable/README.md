# `executable` shadows `files` in DefaultInfo

This repro documents the fact that it’s impossible to create a test target for another test with a macro, because the required (and afaik outdated) `executable` field in `DefaultInfo` shadows `files`.


```
$ bazel version
Build label: 0.18.0- (@non-git)
Build target: bazel-out/k8-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
Build time: Tue Jan 1 00:00:00 1980 (315532800)
Build timestamp: 315532800
Build timestamp as int: 315532800


$ bazel test --test_output=errors :example@test
INFO: Analysed target //:example@test (17 packages loaded).
INFO: Found 1 test target...
Target //:example@test up-to-date:
  bazel-bin/example@test
INFO: Elapsed time: 3.903s, Critical Path: 0.12s
INFO: 1 process: 1 processwrapper-sandbox.
INFO: Build completed successfully, 3 total actions
//:example@test                                                          PASSED in 0.1s

Executed 1 out of 1 test: 1 test passes.
INFO: Build completed successfully, 3 total actions


$ bazel test --test_output=errors :example_test@test
INFO: Analysed target //:example_test@test (0 packages loaded).
INFO: Found 1 test target...
FAIL: //:example_test@test (see /home/philip/.cache/bazel/_bazel_philip/39225840e6b019295c1b0a6dcf31787a/execroot/__main__/bazel-out/k8-fastbuild/testlogs/example_test@test/test.log)
INFO: From Testing //:example_test@test:
==================== Test output for //:example_test@test:
+ echo files: ./empty
files: ./empty
+ '[' ./empty = ./a ']'
================================================================================
Target //:example_test@test up-to-date:
  bazel-bin/example_test@test
INFO: Elapsed time: 0.334s, Critical Path: 0.07s
INFO: 1 process: 1 processwrapper-sandbox.
INFO: Build completed, 1 test FAILED, 3 total actions
//:example_test@test                                                     FAILED in 0.0s
  /home/philip/.cache/bazel/_bazel_philip/39225840e6b019295c1b0a6dcf31787a/execroot/__main__/bazel-out/k8-fastbuild/testlogs/example_test@test/test.log

INFO: Build completed, 1 test FAILED, 3 total actions
```