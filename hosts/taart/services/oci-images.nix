/*
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/home-assistant/home-assistant latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 acockburn/appdaemon latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/tomquist/hm2mqtt latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/tomquist/hame-relay latest
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
  hm2mqtt = {
    imageName = "ghcr.io/tomquist/hm2mqtt";
    imageDigest = "sha256:d56be087647ad0500f5376274cbef4c220a81a38a52646d5ea0954a8387eb022";
    hash = "sha256-x8oq9uGA9xS60DQ/Z8j2HZ3+JqH9xsa/D7uw3rOC6gQ=";
    finalImageName = "ghcr.io/tomquist/hm2mqtt";
    finalImageTag = "latest";
  };
  hame-relay = {
    imageName = "ghcr.io/tomquist/hame-relay";
    imageDigest = "sha256:47742c599b57b11cd90cc29d50b8f1537c39c246cd418dc2d05eee32211ea163";
    hash = "sha256-oZHk5YIbimtxdEr77Lp49T2unDg7EXB/eaJcZ/kLSbM=";
    finalImageName = "ghcr.io/tomquist/hame-relay";
    finalImageTag = "latest";
  };
}
