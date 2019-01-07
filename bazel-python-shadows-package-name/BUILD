# this will print the python path and 42
py_binary(
    name = "bin-good",
    main = "bin.py",
    srcs = ["bin.py"],
    deps = [
        "//tools:lib",
    ],
)

# this should print 43, but can’t find tools.lib.
# The reason for that is that @bazel_tools/tools
# comes first in the PYTHONPATH and shadows the
# tools in this package.
py_binary(
    name = "bin-bad",
    srcs = ["bin.py"],
    main = "bin.py",
    deps = [
        # Note how the ordering doesn’t make a difference,
        # the PYTHONPATH is sorted by WORKSPACE name, and
        # this one is zzz, which comes after bazel_tools!
        # Try changing to aaa in WORKSPACE, then it works.
        "@bazel_tools//tools/python/runfiles",
    ],
)
