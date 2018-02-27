{ config, pkgs, lib, ... }:

let 

  nmapplet = config.services.nmapplet;
 
in
 
with lib;

{
  options = {
    services.nmapplet = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start nmapplet.
         '';
      };
    };
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
}
