{
  description = "Flutter development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    devShells.default = with import nixpkgs { system = "x86_64-linux"; }; {
      packages = [
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
    };
  };
}
