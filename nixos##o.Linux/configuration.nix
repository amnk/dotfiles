# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  unstable = import (
    fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz
  ) {};
 
in {
  
  imports =
    [ # Include the results of the hardware scan.
      ./thinkpad_x230.nix
     
      ./packages.nix

      ./services
#      ./services/dunst.nix
#      ./services/kbdd.nix
#      ./services/nmapplet.nix
#      ./services/random_wallpaper.nix
#      ./services/xscreensaver.nix
    ];
  
  boot = {
    earlyVconsoleSetup = true;
  }; 
  # networking.hostName = "nixos"; # Define your hostname.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleUseXkbConfig = true;
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    extraInit = "xrdb -I$HOME -merge ~/.config/Xresources/Xresources";
    variables = {
      EDITOR = pkgs.lib.mkOverride 0 "vim";
    };

    profileRelativeEnvVars = {
      #NIX_GHC= [ "$HOME/.nix-profile/bin/ghc" ];
      #NIX_GHCPKG = [ "$HOME/.nix-profile/bin/ghc-pkg" ];
      #NIX_GHC_DOCDIR = [ "$HOME/.nix-profile/share/doc/ghc/html" ];
      #NIX_GHC_LIBDIR = [ "$HOME/.nix-profile/lib/ghc-$($NIX_GHC --numeric-version)" ];
    };

  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
      ultimate.enable = true;
    };
    fonts = with pkgs; [
      anonymousPro
      envypn-font
      font-awesome-ttf
      hack-font
      inconsolata
      terminus_font
      terminus_font_ttf
      source-code-pro
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    bash.enableCompletion = true;
    chromium.extensions = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" #vimium
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" #ublock-origin
      "ompiailgknfdndiefoaoiligalphfdae" #chromelPass
    ];
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    #ssh.startAgent = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # Enable network
  networking = {
    networkmanager = {
      enable = true;
      packages = [ pkgs.networkmanager_openvpn pkgs.networkmanagerapplet pkgs.networkmanager_dmenu ];
    };
  };
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services = {
    acpid.enable = true;
    
    compton = {
      enable = true;
      fade = true;
      fadeDelta = 8;
      fadeExclude = [ "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'" ];
      fadeSteps = [ "0.07" "0.07" ];
      inactiveOpacity = "0.99";
      menuOpacity = "1";
      shadow = true;
      #shadowOffsets = [ -6 -4 ];
      vSync = "opengl";
    };
   
    dunst.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
 
    hdapsd.enable = true;
    
    kbdd.enable = true;

    nmapplet.enable = true;

    openssh = {
      enable = true;
      permitRootLogin = "no";
    };

    random-wallpaper.enable = true;

    redshift = {
      enable = true;
      latitude = "50.0647";
      longitude = "19.9450";
    };
    
    tlp = {
      enable = true;
      extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        CPU_MIN_PERF_ON_BAT=0
        CPU_MAX_PERF_ON_BAT=70
        CPU_BOOST_ON_BAT=0
        DEVICES_TO_DISABLE_ON_BAT="bluetooth"
        #START_CHARGE_THRESH_BAT0=75
        #STOP_CHARGE_THRESH_BAT0=80
      '';
    };
    tcsd.enable = true;

    xserver = {
      enable = true;
      layout = "us,ru";
      xkbOptions = "grp:caps_toggle";
      videoDrivers = [ "intel" ];
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmobar
          haskellPackages.xmonad
          haskellPackages.taffybar
        ];
      };
      windowManager.default = "xmonad";
      desktopManager.xterm.enable = false;
      desktopManager.default = "none";
      displayManager = {
        logToJournal = true;
        sddm = {
          enable = true;
        };
        sessionCommands = ''
          light-locker-command -l
        '';
      };
    };

    xscreensaver.enable = true;

    upower.enable = true;
  };
  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  security = {
    rtkit.enable = true;
    sudo.enable = true;
    
    # Allow normal users to mount devices
    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        var permission = {
          "org.freedesktop.udisks2.filesystem-mount": YES,
          "org.freedesktop.udisks2.filesystem-mount-system": YES,
          "org.freedesktop.udisks2.eject-media": YES
        };
        return permission[action.id];
      });
    '';
  };
  
  system.stateVersion = "17.09"; # Did you read the comment?
  
  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  virtualisation = {
    docker.enable = true;
#    virtualbox = {
#      host.enable = true;
#      host.enableHardening = true;
#      host.headless = true;
#    };
  };

  users.extraUsers.amnk = {
    createHome = true;
    home = "/home/amnk";
    extraGroups = ["wheel" "disk" "vboxusers" "cdrom" "docker" "networkmanager"];
    isNormalUser = true;
    useDefaultShell = true;
    uid = 1000;
  };
  
}
