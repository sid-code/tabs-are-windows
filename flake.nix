{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            inherit (self) overlays;
          };
        });
  in {
    overlays = [
      (final: prev: {
        web-ext = prev.web-ext.overrideAttrs (o: {
          preBuild = ''
            export NODE_ENV=production
          '';
        });
      })
    ];
    packages = forAllSystems (
      {
        system,
        pkgs,
      }: rec {
        default = pkgs.stdenv.mkDerivation {
          name = "tabs-are-windows-ext.zip";
          version = "0.1";
          src = ./.;
          buildPhase = ''
            ${pkgs.web-ext}/bin/web-ext build
          '';
          installPhase = ''
            mv web-ext-artifacts/*.zip $out
          '';
        };
      }
    );

    devShells = forAllSystems (
      {
        system,
        pkgs,
      }: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            web-ext
          ];
        };
      }
    );
  };
}
