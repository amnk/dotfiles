{ config, pkgs, lib, ... }:

let 

  xscreensaver    = config.services.xscreensaver;
 
in
 
with lib;

{

  options = {
    services.xscreensaver = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start dunst.
         '';
      };
    };
  };

  config = mkIf xscreensaver.enable {

    systemd.user.services."xscreensaver" = {
      description = "Xscreensaver";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.xscreensaver}/bin/xscreensaver -nosplash";
      };
    };

    environment.systemPackages = [ pkgs.xscreensaver ];

  };
}
