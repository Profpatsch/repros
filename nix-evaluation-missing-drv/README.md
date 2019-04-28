# Nix evaluator is not creating necessary derivation

Strange bug in the nix evaluator:

[$ default.nix](./default.nix)
```
let
  pkgs = import <nixpkgs> {};

  ex = nix-file-path:
    let drv = pkgs.stdenv.mkDerivation {
          name = "not-evaluated";
          buildCommand = ''
            echo ${nix-file-path} > $out
          '';
        };
    in import "${drv}";

in ex (builtins.toFile "foo" "{}")

```
`$ nix-instantiate --eval ./default.nix 2>&1`
```
error: cannot import '/nix/store/ncj07425nhhbsy03vnrhqkyvyd3r4wnb-not-evaluated', since path '/nix/store/a9qkmlxsjq4wvk7bvmrw9y6m1p7rmlik-not-evaluated.drv' is not valid, at /home/philip/kot/repros/nix-evaluation-missing-drv/default.nix:11:8
```
