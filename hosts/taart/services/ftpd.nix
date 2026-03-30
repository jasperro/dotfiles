{
  JDF.hosts._.taart._.services._.ftpd.nixos = {
    key = "ftpd";
    services.vsftpd = {
      enable = true;
      forceLocalLoginsSSL = true;
      forceLocalDataSSL = true;
      userlistDeny = false;
      localUsers = true;
      userlist = [
        "ftpd"
      ];
      rsaCertFile = "/var/vsftpd/vsftpd.pem";
    };
  };
}
