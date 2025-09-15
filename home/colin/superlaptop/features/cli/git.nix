{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_host_github";
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
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
    userName = "Colin Albering";
    userEmail = "colin@albering.nl";
    extraConfig = {
      pull.rebase = true;
      checkout.defaultremote = "origin";
      init.defaultbranch = "main";
      core.autocrlf = "input";
    };
  };
}
