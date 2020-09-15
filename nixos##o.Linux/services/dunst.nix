{ config, pkgs, lib, ... }:

let 

  dunst    = config.services.dunst;
 
in
 
with lib;

{

  options = {
    services.dunst = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start dunst.
         '';
      };
    };
  };

  config = mkIf dunst.enable {

    systemd.user.services."dunst" = {
      description = "Dunst notification daemon";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.dunst}/bin/dunst --config %h/.config/dunst/dunstrc";
      };
    };

    environment.systemPackages = [ pkgs.dunst ];

  };
}
