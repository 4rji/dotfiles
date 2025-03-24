{
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
  };

  services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
