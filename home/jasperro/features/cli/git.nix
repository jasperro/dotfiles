{ ... }:

{
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "~/.ssh/known_host_github ~/.ssh/known_hosts";
  };
  # Add github to known ssh hosts
  home.file.".ssh/known_host_github" = {
    text = ''
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    '';
    force = true;
  };

  programs.git = {
    enable = true;
    userName = "Jasper Albering";
    userEmail = "jasper@albering.nl";
    extraConfig = {
      pull.rebase = true;
      checkout.defaultremote = "origin";
      init.defaultbranch = "main";
      core.autocrlf = "input";
    };
  };
}
