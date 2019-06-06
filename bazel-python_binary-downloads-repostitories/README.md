# Bazel 0.16 downloads external java repositories for builtin rules

When building this trivial `python_test` rule with

```
bazel test //...
```

in a testing setup (no network access), the following error is thrown:

```
INFO: Call stack for the definition of repository 'remote_java_tools_linux' which is a http_archive (rule definition at /build/tmp.dN5z9Qqsvo/.cache/bazel/_bazel_nixbld/2898b59ac5a61dc07e72b28a0e3fa2ab/external/bazel_tools/tools/build_defs/repo/http.bzl:229:16):
 - /DEFAULT.WORKSPACE.SUFFIX:229:1
ERROR: An error occurred during the fetch of repository 'remote_java_tools_linux':
   java.io.IOException: Error downloading [https://mirror.bazel.build/bazel_java_tools/releases/javac10/v3.1/java_tools_javac10_linux-v3.1.zip] to /build/tmp.dN5z9Qqsvo/.cache/bazel/_bazel_nixbld/2898b59ac5a61dc07e72b28a0e3fa2ab/external/remote_java_tools_linux/java_tools_javac10_linux-v3.1.zip: Unknown host: mirror.bazel.build
ERROR: /build/tmp.dN5z9Qqsvo/.cache/bazel/_bazel_nixbld/2898b59ac5a61dc07e72b28a0e3fa2ab/external/bazel_tools/tools/jdk/BUILD:225:1: no such package '@remote_java_tools_linux//': java.io.IOException: Error downloading [https://mirror.bazel.build/bazel_java_tools/releases/javac10/v3.1/java_tools_javac10_linux-v3.1.zip] to /build/tmp.dN5z9Qqsvo/.cache/bazel/_bazel_nixbld/2898b59ac5a61dc07e72b28a0e3fa2ab/external/remote_java_tools_linux/java_tools_javac10_linux-v3.1.zip: Unknown host: mirror.bazel.build and referenced by '@bazel_tools//tools/jdk:JacocoCoverageRunner'
ERROR: Analysis of target '//python:bin' failed; build aborted: no such package '@remote_java_tools_linux//': java.io.IOException: Error downloading [https://mirror.bazel.build/bazel_java_tools/releases/javac10/v3.1/java_tools_javac10_linux-v3.1.zip] to /build/tmp.dN5z9Qqsvo/.cache/bazel/_bazel_nixbld/2898b59ac5a61dc07e72b28a0e3fa2ab/external/remote_java_tools_linux/java_tools_javac10_linux-v3.1.zip: Unknown host: mirror.bazel.build
INFO: Elapsed time: 14.295s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (17 packages loaded, 141 targets configured)
ERROR: Couldn't start the build. Unable to run tests
FAILED: Build did NOT complete successfully (17 packages loaded, 141 targets configured)
builder for '/nix/store/dgjml4g09vm8raqm005mb8gzzvfqdki8-bazel-test-builtin-rules.drv' failed with exit code 1
error: build of '/nix/store/dgjml4g09vm8raqm005mb8gzzvfqdki8-bazel-test-builtin-rules.drv' failed
```

I’d expect rules for builtin languages to work without fetching
arbitrary binaries from external sources.
