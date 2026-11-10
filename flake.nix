{
  description = "Mari's NixOS configuration";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nix-flatpak,
    nixpkgs-unstable,
    codex-cli-nix,
    ...
  }: let
    username = "mari";
    specialArgs = {inherit inputs username;};
    mkHost = {
      hostModule,
      system ? "x86_64-linux",
    }:
      nixpkgs.lib.nixosSystem {
        inherit specialArgs system;

        modules = [
          ({pkgs, ...}: {
            environment.systemPackages = [
              codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.codex
            ];
          })
          hostModule
          ./users/${username}/nixos.nix
          nix-flatpak.nixosModules.nix-flatpak

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = specialArgs;
              sharedModules = [nix-flatpak.homeManagerModules.nix-flatpak];
              users.${username} = import ./users/${username}/home.nix;
            };
          }
        ];
      };
  in {
    nixosConfigurations.marilaptop = mkHost {
      hostModule = ./hosts/nixos;
    };
  };
}
