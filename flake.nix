{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.helm = pkgs.wrapHelm pkgs.kubernetes-helm { };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ansible_2_17
            caddy
            nftables
            yamlfmt
          ];

          shellHook = ''
            export KUBECONFIG="$(realpath ./kubeconfig)"
            export LC_ALL=C.UTF-8
          '';
        };
      }
    );
}
