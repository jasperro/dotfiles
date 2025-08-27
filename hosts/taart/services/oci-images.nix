/*
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 ghcr.io/home-assistant/home-assistant latest
  nix run nixpkgs\#nix-prefetch-docker -- --arch arm64 acockburn/appdaemon latest
*/
{
  home-assistant = {
    imageName = "ghcr.io/home-assistant/home-assistant";
    imageDigest = "sha256:2eb83307a08de3287822b648fce4cbf1364423b55f2af623c149c6b21c2cef00";
    hash = "sha256-H+g4W0sMoTat6VKQL4rUWhyLIW2f4lU0GO7nadFVgUE=";
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
