{ config, pkgs, lib, ... }:

let 

  cfg = config.services.random-wallpaper;
 
in

with lib;
 
{

  options = {
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
  
  config = mkIf cfg.enable {
 
    systemd.user.services."random-wallpaper" = {
      enable = true;
      description = "Set random wallpaper";
      wantedBy = [ "graphical-session.target" ];
      #path = [ pkgs.feh ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --no-fehbg --randomize --bg-fill %h/${cfg.location}";
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
