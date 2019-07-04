{
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager";
    rev = "95382060ebaa19ec49a861921216b1db8460b314";
  };
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "cc631b7277d340cd2100ce5de6727d6bb4591395";
  };
}
