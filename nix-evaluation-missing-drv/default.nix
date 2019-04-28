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
