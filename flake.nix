{
  description = "Stable diffusion keras";

  outputs = { self, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        diffusion-models = pkgs.callPackage ./models.nix { };

        default = pkgs.callPackage ./default.nix {
          inherit (self.packages.${system}) diffusion-models;
        };
      };

      devShells.${system}.default = self.packages.${system}.default.dependencyEnv;

      apps.${system} = let pkgs = self.packages.${system}; in {
        img2img = { type = "app"; program = pkgs.default + "/bin/img2img"; };
        n_text2image = { type = "app"; program = pkgs.default + "/bin/n_text2image"; };
        text2image = { type = "app"; program = pkgs.default + "/bin/text2image"; };
      };
    };
}
