{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix2flatpak.url = "github:neobrain/nix2flatpak";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      imports = [
        ./nix/devshell.nix
        ./nix/rust.nix
      ];

      perSystem =
        {
          lib,
          pkgs,
          system,
          ...
        }:
        {
          packages = {
            default = pkgs.callPackage ./nix/package.nix { inherit inputs; };
          };
        };
    };
}
