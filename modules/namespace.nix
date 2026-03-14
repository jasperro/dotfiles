{ inputs, den, ... }:
{
  # true = flake expose, false = private
  imports = [
    (inputs.den.namespace "JDF" true)
  ];

  # you can also merge many namespaces from remote flakes.
  # keep in mind a namespace is defined only once, so give it an array:
  # imports = [ (inputs.den.namespace "ours" [inputs.ours inputs.theirs]) ];

  # this line enables den angle brackets syntax in modules.
  _module.args.__findFile = den.lib.__findFile;
}
