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

in import (ex (builtins.toFile "bar" "{}"))
```
`$ nix-instantiate --eval ./default.nix 2>&1`
```
error: cannot import '/nix/store/zbvbavw6has7vyd9agl39c45b2f76927-not-evaluated', since path '/nix/store/0rpg8ch1bh8iq37m6m8q0qq36a9gpwvj-not-evaluated.drv' is not valid, at /home/philip/kot/repros/nix-evaluation-missing-drv/default.nix:11:8
```
But I can instantiate it:

`$ nix-instantiate ./default.nix`
```

```
and afterwards, evaluating works:

`$ nix-instantiate --eval ./default.nix 2>&1`
```
{ }
```