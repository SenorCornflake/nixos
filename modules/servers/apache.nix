{ config, pkgs, lib, ... }:

with lib;
with lib.my;
with builtins;

let 
  cfg = config.modules.servers.apache;

  # TODO: Figure out how to install phpmyadmin declaratively
  phpmyadmin = "/srv/http/phpmyadmin";

  mkVhost = name: {
    documentRoot = "/srv/http/${name}/public_html";
    hostName = name;
    serverAliases = [name];
    extraConfig = ''
      AllowOverride All
    '';
  };

  virtualHostDirs = (filterAttrs (n: v: n != ".git" && n != "phpmyadmin") (readDir /srv/http));

  virtualHosts = concatStringsSep
    "\n"
    (if pathExists /srv/http then
      attrValues
        (mapAttrs
          (n: v:
            ''
              <VirtualHost *:80>
                ServerName ${n}
                ServerAlias ${n}
                ServerAdmin admin@email.com
                ErrorLog /var/log/httpd/error-${n}.log
                CustomLog /var/log/httpd/access-${n}.log common
                DocumentRoot "/srv/http/${n}"

                <Directory "/srv/http/${n}">
                    Options Indexes FollowSymLinks
                    AllowOverride All
                    Require all granted
                </Directory>
              </VirtualHost>
            '')
          virtualHostDirs)
    else []);
in
{
  options.modules.servers.apache = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.httpd = {
      enable = true;
      enablePHP = true;
      adminAddr = "admin@email.com";
      mpm = "prefork";
      phpOptions = ''
       engine = On
       error_reporting = E_ALL
       display_errors = On
       display_startup_errors = On
       max_execution_time = 600
       memory_limit = -1
       max_input_time = 60
       upload_max_filesize = 2000000000000000000000000000000000000000000000000
      '';

      extraConfig = ''
        DirectoryIndex index.html index.php

        Alias /phpmyadmin "${phpmyadmin}"
         <Directory "${phpmyadmin}">
          AllowOverride All
          Options FollowSymlinks
          Require all granted
         </Directory>

         ${virtualHosts}
      '';
    };

    networking.hosts."127.0.0.1" = attrNames virtualHostDirs;

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      dataDir = "/var/lib/mysql";
    };
  };
}
