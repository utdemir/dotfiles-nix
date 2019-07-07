{
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager";
    rev = "c3520bfa52b30f984e73e9616abe4d11ab56de36";
  };
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "dc0dbaf0bd8ad9a04011ee734709b4f3e2ce15f0";
  };
}
