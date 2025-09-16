/*
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/home-assistant/home-assistant latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 acockburn/appdaemon latest
*/
{
  home-assistant = {
    imageName = "ghcr.io/home-assistant/home-assistant";
    imageDigest = "sha256:2da8dea31821db443a69d822bd0c47972572fc8379a920a8fac730d2072c8ed2";
    hash = "sha256-3UxtP1w7wZtuvs0lwA1RVlpkfODGBNHxlQA7JX8dh2A=";
    finalImageName = "ghcr.io/home-assistant/home-assistant";
    finalImageTag = "latest";
  };
  appdaemon = {
    imageName = "acockburn/appdaemon";
    imageDigest = "sha256:512c86e8cc24a3654e4cd2ddaf8a64ecd4e3707976a66b85bc2d9be51553be67";
    hash = "sha256-DCpCTjx9OFJlSQ4gEODXrE3awjmNNwM7IGBlI7ua7nU=";
    finalImageName = "acockburn/appdaemon";
    finalImageTag = "latest";
  };
}
