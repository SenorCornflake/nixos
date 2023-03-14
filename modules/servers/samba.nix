{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.servers.samba;
in

{
  options.modules.servers.samba = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
    networking.firewall.allowedTCPPorts = [
      5357 # wsdd
    ];
    networking.firewall.allowedUDPPorts = [
      3702 # wsdd
    ];
    services.samba = {
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
        local master = yes
        preferred master = yes
      '';
      shares = {
        public = {
          path = "/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "a";
          "force group" = "users";
          writable = "yes";
        };
      };
    };
  };
}

