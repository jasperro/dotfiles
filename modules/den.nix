{ inputs, ... }:
{
  imports = [ inputs.den.flakeModule ];
  den.hosts.aarch64-linux.taart.users.jasperro = { };
  den.hosts.x86_64-linux.koekie.users = {
    jasperro = { };
    wiktorine = { };
  };
  den.hosts.x86_64-linux.superlaptop.users.colin = { };
  den.hosts.x86_64-linux.waffie.users.wiktorine = { };
}
