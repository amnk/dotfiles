{ pkgs, ... }:

let

  unstable = import (
    fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz
  ) {};

  vmPkgs = with pkgs; [
    polybar
    lightlocker
    ranger
    unstable.rofi
    termite
    xscreensaver
  ];

  myPkgs = with pkgs; [
    chromium
    gitAndTools.gitFull
    keepassx-reboot
    tdesktop
    todo-txt-cli
    vim
    yadm
  ];
 
  systemPackages = with pkgs; [
    acpitool
    binutils
    coreutils
    #Haskell packages
    #haskellPackages.ghc
    #haskellPackages.xmobar
    #haskellPackages.taffybar
    #haskellPackages.xmonad
    #haskellPackages.xmonad-contrib
    #haskellPackages.xmonad-extras
    ##
    linuxPackages.x86_energy_perf_policy
    pciutils
    nix
    sudo
    tpm-tools
    tpm-luks
    tmux
    wget
    xorg.xbacklight
    xorg.xev
    xorg.xprop
    xorg.xrdb
  ];

in {
  environment.systemPackages = vmPkgs ++ myPkgs ++ systemPackages;
}
