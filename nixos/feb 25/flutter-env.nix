{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    flutter
    android-tools
    android-studio
    jdk17
    cmake
    ninja
    unzip

    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    libxkbcommon
    gtk3
  ];
}
