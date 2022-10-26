{ lib
, diffusion-models
, poetry2nix
}:

poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  propagatedBuildInputs = [ diffusion-models ];
}
