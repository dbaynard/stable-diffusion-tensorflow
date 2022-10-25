{
  description = "Stable diffusion keras";

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.diffusion-models = pkgs.callPackage ./models.nix { };
    };
}
