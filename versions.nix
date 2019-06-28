{
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager";
    rev = "8f7cd532040d14e3db907c6ffaa4a149e443d5e4";
  };
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "a2075a2c314ccb3df6522dd957bb4e237446dc49";
  };
}
