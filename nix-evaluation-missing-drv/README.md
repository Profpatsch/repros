# Nix evaluator is not creating necessary derivation

Strange bug in the nix evaluator:

[$ default.nix](./default.nix)
```
let
  ex = nix-file-path:
    let drv = derivation {
          name = "not-evaluated";
          system = builtins.currentSystem;
          builder = "/bin/sh";
          args = [ "-c" ''
            echo ${nix-file-path} > $out
          '' ];
        };
    in import "${drv}";

in ex (builtins.toFile "foo" "{}")
```
`$ nix-instantiate --eval ./default.nix 2>&1`
```
error: cannot import '/nix/store/7vcbfpp144hs719844l59109bbkyn0wd-not-evaluated', since path '/nix/store/0czlwgaqvqa7d54v9258m41r3l4ldjfw-not-evaluated.drv' is not valid, at /home/philip/kot/repros/nix-evaluation-missing-drv/default.nix:11:8
```