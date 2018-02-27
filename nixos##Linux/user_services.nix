{ config, pkgs, ... }:

let 

  compton  = config.services.compton;
  dunst    = config.services.dunst;
  nmapplet = config.services.nmapplet;
  random-w = config.services.random-wallpaper;
 
in
 
with pkgs.lib;

{

  options = {
    services.compton = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start compton.
         '';
      };
    };

    services.dunst = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start dunst.
         '';
      };
    };

    services.nmapplet = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start nmapplet.
         '';
      };
    };

    services.random-wallpaper = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Change wallpaper radnomly.
         '';
      };

      period = mkOption {
         default = "30min";
         type = with types; uniq string;
         description = ''
           Period of changes
         '';
      };

      location = mkOption {
         default = "wallpapers";
         type = with types; uniq string;
         description = ''
           Directory with wallpapers (relative to home directory)
         '';
      };

    };
  };
  
  config = mkIf compton.enable { 
 
    systemd.user.services."compton" = {
      enable = true;
      description = "";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.compton ];
      serviceConfig.Type = "forking";
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.compton}/bin/compton --config %h/.config/compton.conf -b";
    };

    environment.systemPackages = [ pkgs.compton ];
  };

  config = mkIf dunst.enable {

    systemd.user.services."dunst" = {
      description = "Dunst notification daemon";
      after = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.dunst}/bin/dunst";
      };
    };

    environment.systemPackages = [ pkgs.dunst ];

  };

  config = mkIf kbdd.enable {

    systemd.user.services."kbdd" = {
      enable = true;
      description = "";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.kbdd ];
      serviceConfig.Type = "forking";
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.kbdd}/bin/kbdd";
    };

    environment.systemPackages = [ pkgs.kbdd ];

  };
 
  config = mkIf nmapplet.enable {

    systemd.user.services."nmapplet" = {
      enable = true;
      description = "Network Manager Agent";
      environment = {
        XDG_DATA_DIRS = "${config.system.path}/share";
      };
      path = [ pkgs.networkmanagerapplet ];
      serviceConfig.Restart = "on-abort";
      serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    environment.systemPackages = [ pkgs.networkmanagerapplet ];

  };

  config = mkIf random-w.enable {
 
    systemd.user.services."random-wallpaper" = {
      enable = true;
      description = "Set random wallpaper";
      wantedBy = [ "graphical-session.target" ];
      path = [pkgs.feh ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --no-fehbg --randomize --bg-fill %h/{cfg.location}";
        IOSchedulingClass = "idle";
      };
    };

    systemd.user.timers."random-wallpaper" = {
      enable = true;
      description = "Run feh periodically to set random wallpaper";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnUnitActiveSec = "${cfg.period}";
      };
    };

    environment.systemPackages = [ pkgs.feh ];

  };
  
}
