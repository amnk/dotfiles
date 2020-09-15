{ config, pkgs, lib, ... }:

let 

  kbdd  = config.services.kbdd;
 
in
 
with lib;

{

  options = {
    services.kbdd = {
      enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start kbdd.
         '';
      };
    };
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
}
