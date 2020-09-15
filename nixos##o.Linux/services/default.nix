{ config, pkgs, ... }:

{
  imports =
    [
      ./dunst.nix
      ./kbdd.nix
      ./nmapplet.nix
      ./random_wallpaper.nix
      ./xscreensaver.nix
    ];
}
