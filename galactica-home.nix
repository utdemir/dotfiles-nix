{ ... }:

let pkgs = import ./pkgs.nix;
in

{
  imports = [ ./common-home.nix ];
  home.packages = with pkgs; [
    protobuf3_1
    travis
    slack
    kt
    hadoop
    spark
    mysql
    mysql-workbench
    (kubectl.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "kubernetes"; repo = "kubernetes";
        rev = "release-1.5";
        sha256 = "0kdycfxvmanah9cpvkxs9blhhqgpxwf49bcf1hcy2fhkibgr33v4";
      };
    }))
  ];

}
