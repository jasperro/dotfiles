/*
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/home-assistant/home-assistant latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 acockburn/appdaemon latest
*/
{
  home-assistant = {
    imageName = "ghcr.io/home-assistant/home-assistant";
    imageDigest = "sha256:857745bd01589750174e60f2c477a65da1169c4f1c098a58db792baae7f7ada6";
    hash = "sha256-KN54cIvKyGbwwcmAgODYlULoyJYuoopBFDjGzz5t1S0=";
    finalImageName = "ghcr.io/home-assistant/home-assistant";
    finalImageTag = "latest";
  };
  appdaemon = {
    imageName = "acockburn/appdaemon";
    imageDigest = "sha256:55bfe7c9d43a18ae3ac2bcf374cf1d64921dab351f0cc8979a65153dbbcd399f";
    hash = "sha256-Dq035k3zke+akdmuCAQ/UMKAt3AOrS6YuCPhL+i3Kxs=";
    finalImageName = "acockburn/appdaemon";
    finalImageTag = "latest";
  };
}
