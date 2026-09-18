{ lib, jdfPath, ... }:
{
  jdf = lib.setAttrByPath jdfPath {
    nixos = {
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
  };
}
