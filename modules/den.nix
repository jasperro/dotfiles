{ inputs, den, ... }:
{
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "jdf" true)
  ];

  config._module.args.__findFile = den.lib.__findFile;
}
