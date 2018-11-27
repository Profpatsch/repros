def _return_files_impl(ctx):
    a = ctx.actions.declare_file("a")
    empty = ctx.actions.declare_file("empty")

    ctx.actions.write(a, content="a")
    ctx.actions.write(empty, content="", is_executable=True)

    return [DefaultInfo(
        files = depset(direct = [a]),
    )]

return_files = rule(
    _return_files_impl,
)

def _return_files_test_impl(ctx):
    a = ctx.actions.declare_file("a")
    empty = ctx.actions.declare_file("empty")

    ctx.actions.write(a, content="a")
    ctx.actions.write(empty, content="", is_executable=True)

    return [DefaultInfo(
        # these files should be accessible, but are shadowed by `executable`
        files = depset(direct = [a]),
        # needed by `test = True`.
        executable = empty,
    )]

# a simple test rule which produces some files to be checked by the macro
return_files_test = rule(
    _return_files_test_impl,
    test = True,
)


def return_files_macro(name, **kwargs):
    # simple rule which exposes a few files via DefaultInfo
    return_files(name = name, **kwargs)
    # then a test target is created for the rule, which checks
    # the consistency of the generated files
    native.sh_test(
        name = name + "@test",
        srcs = [":script.sh"],
        args = ["$(rootpath {})".format(name)],
        data = [":" + name]
    )

    # now we do the same with a test rule
    return_files_test(name = name + "_test", **kwargs)
    # It won’t work, because of the requirement of having to provide an `executable` for tests
    native.sh_test(
        name = name + "_test@test",
        srcs = [":script.sh"],
        args = ["$(rootpath {})".format(name + "_test")],
        data = [":" + name + "_test"]
    )
