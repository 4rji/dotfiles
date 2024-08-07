{ config, pkgs, ... }:

{


##start here


figlet
lolcat

joplin
kitty
tmux
fzf
github-desktop
git
wget

python3
wireguard-tools
fail2ban
protonvpn-gui
#ifupdown
bat
lsd
tldr
kde-gtk-config
sublime
iproute2
moreutils
google-chrome
pipx
distrobox
opera
brave
lazygit
gparted
xclip
jq

procps
#net-tools - not available
yazi
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
zsh






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

