{ lib
, diffusion-models
, poetry2nix
}:

let
  withSetuptools = pnames: final: prev:
    let
      f = pname: prev.${pname}.overrideAttrs (old: {
        buildInputs = old.buildInputs or [ ] ++ [ prev.setuptools ];
      });
    in
    lib.listToAttrs (map (name: { inherit name; value = f name; }) pnames);

in

poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  propagatedBuildInputs = [ diffusion-models ];
  dontUseWheelUnpack = true;

  overrides = poetry2nix.overrides.withDefaults (withSetuptools [
    "libclang"
    "pyparsing"
    "typing-extensions"
  ]);
}
