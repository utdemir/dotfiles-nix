{ config, lib, pkgs, ... }:

{
  fileSystems."/" = { device = "/dev/null"; };
}
