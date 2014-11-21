with import <nixpkgs> {}; [
  boehmgc
  cacert
  nixUnstable
  nix-exec
  pkgconfig
  todo-txt-cli
  vim
  gitFull
  (pass.override { gnupg = gnupg21; })
  gnupg21
]
