{
  description = "language-js from Hackage";

  inputs.nixpkgs.url = "github:NixOS/Nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs
        [ "x86_64-linux" "aarch64-linux" ]
        (system: f system);
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
        }
      );
    in
    {

      devShell = forAllSystems
        (system:
          let
            pkgs = nixpkgsFor.${system};
          in
          pkgs.mkShell {
            buildInputs = with pkgs; [
              (
                pkgs.haskellPackages.ghcWithPackages (
                  p: with p; [
                    language-js
                    hspec
                    parsec
                  ]
                )
              )
              cabal-install
              stack
              ormolu # haskell code formatting
            ];

          });
    };
}
