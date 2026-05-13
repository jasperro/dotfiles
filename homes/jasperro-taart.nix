{ __findFile, ... }:
{
  den.aspects.jasperro-taart = {
    includes = [
      <JDF/users/jasperro/git>
      <JDF/users/jasperro/cli>
    ];
  };
}
