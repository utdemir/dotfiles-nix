{
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager";
    rev = "28f2dd612ec7c3bd07ec951aa6862d0702ab6624";
  };
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "ed952d43b9caaf7563a615166d4b83d451f91c86";
  };
}
