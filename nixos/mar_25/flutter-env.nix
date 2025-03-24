{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; } }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.wrapGAppsHook
    pkgs.pkg-config
  ];
  buildInputs = with pkgs; [
    flutter
    android-tools
    android-studio
    jdk17
    cmake
    ninja
    unzip
    clang
    pcre2
    legacyPackages.x86_64-linux.libepoxy
    fontconfig
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    libxkbcommon
    gtk3
  ];
  shellHook = ''
    export CXX=clang++
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [ legacyPackages.x86_64-linux.libepoxy fontconfig ]}:$LD_LIBRARY_PATH
  '';
}
