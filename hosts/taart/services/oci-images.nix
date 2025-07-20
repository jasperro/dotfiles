/*
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/home-assistant/home-assistant latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 acockburn/appdaemon latest
*/
{
  home-assistant = {
    imageName = "ghcr.io/home-assistant/home-assistant";
    imageDigest = "sha256:90e105ff097717556df4e87da3b825af85b181c763ca2b8d840aeae5d34a083c";
    hash = "sha256-Q5krvVAHMVVmc4MAPcJ224GUCXZLFYPXStKBAiWorSc=";
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
