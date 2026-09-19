{ ... }: {
  den.aspects.overlays = {
    os =
      {
        ...
      }:
      {
        nixpkgs.overlays = [
        ];
      };
  };
}
