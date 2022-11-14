{
  description = "dayz-ctl";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        lib,
        ...
      }: let
      in rec {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          # steamcmd is unfree
          config.allowUnfree = true;
        };

        devShells = {
          default = pkgs.mkShell rec {
            buildInputs = [
              pkgs.gum
              pkgs.jq
              pkgs.fzf
              pkgs.iputils
              pkgs.geoip
              pkgs.curl
              pkgs.steamcmd
              pkgs.whois
            ];
          };
        };
      };
      systems = [ "x86_64-linux" ];
    };
}
