{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in {
    metadata = {
      description = "Flutter development environment";
    };

    nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./configuration.nix ];
    };

    devShells.${system}.flutter = pkgs.mkShell {
      packages = with pkgs; [
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
