{ config, pkgs, ... }:

{
kitty
git
wget
python3
#ifupdown
bat
lsd
tldr
sublime
iproute2
moreutils
pipx
distrobox
opera
brave
gparted
xclip
jq
procps
#net-tools - not available
lsof
python312Packages.pip
dig
barrier

findutils
magic-wormhole
unzip
neovim
flameshot
powershell
#bspwm
feh
gh
nmap
#sxhkd
tree







# List services that you want to enable:
services.openssh = {
  enable = true;
  settings = {
    X11Forwarding = true;
    PermitRootLogin = "no"; 
    PasswordAuthentication = true;
    X11UseLocalhost = false;
    AllowTcpForwarding = true;
  };
};


  # Enable the OpenSSH daemon.
#   services.openssh.enable = true;
   virtualisation.docker.enable = true;
#   users.users.nala.extraGroups = [ "docker" ];
   virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
};
    programs.zsh.enable = true;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = true;

