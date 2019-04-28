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
