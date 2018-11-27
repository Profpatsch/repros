def _return_files_impl(ctx):
    a = ctx.actions.declare_file("a")

    ctx.actions.write(a, content="a")

    return [DefaultInfo(
        files = depset(direct = [a]),
    )]

return_files = rule(
    _return_files_impl,
)

def return_files_macro(name, **kwargs):
    # simple rule which exposes a few files via DefaultInfo
    return_files(name = name, **kwargs)

    # then a test target is created for the rule, which checks
    # the consistency of the generated files
    # this test fails because the data is not put into runfiles
    native.sh_test(
        name = name + "@test_bad",
        srcs = [":script.sh"],
        args = ["$(rootpath {})".format(name)],
        data = [":" + name]
    )

    # wrap it …
    native.sh_library(
        name = name + "_wrapped",
        data = [":" + name],
    )

    # after we’ve wrapped it it suddenly passes the data
    native.sh_test(
        name = name + "@test_good",
        srcs = [":script.sh"],
        args = ["$(rootpath {})".format(name + "_wrapped")],
        data = [":" + name + "_wrapped"]
    )
