{ nixpkgs ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d2e74263ac4dd7c222c59620eecdeb0e2a390cb1.tar.gz";
    sha256 = "0400w3vw9dy039wdk04ff06hzxb7wjnhl5wjdbhfpffp5ajrcpia";
  }
}:

with import nixpkgs {};
mkShell {
  buildInputs = [
    python2
    bazel
  ];
}
