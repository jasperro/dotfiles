{ pkgs, lib, ... }:
{
  imports = [
    ../../common/services/openssh-inbound.nix
    ./home-assistant
    ./acme.nix
    ./nginx.nix
  ];
  _module.args.oci-images = lib.mapAttrs (_: value: {
    inherit value;
    image = "${value.finalImageName}:${value.finalImageTag}";
    imageFile = pkgs.dockerTools.pullImage value;
  }) (import ./oci-images.nix);
}
