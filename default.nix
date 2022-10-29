{ lib
, diffusion-models
, poetry2nix
}:

let
  withSetuptools = pnames: final: prev:
    let
      f = pname: prev.${pname}.overrideAttrs (old: {
        propagatedBuildInputs =
          old.propagatedBuildInputs or [ ] ++ [ prev.setuptools ];
        buildInputs = old.buildInputs or [ ] ++ [ prev.setuptools ];
      });
    in
    lib.listToAttrs (map (name: { inherit name; value = f name; }) pnames);

  withDefaults =
    let
      inherit (poetry2nix.defaultPoetryOverrides) overrideOverlay;
      defaults = {
        pre = final: prev: {
          keras = null;
          Keras = null;
          keras_ = prev.keras;
        };

        post = final: prev: {
          keras = prev.keras_;
        };
      };

    in
    ((overrideOverlay defaults.pre).extend defaults.post).extend;
in

poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  propagatedBuildInputs = [ diffusion-models ];
  dontUseWheelUnpack = true;
  overrides = withDefaults (withSetuptools [
    "libclang"
    "pyparsing"
    "typing-extensions"
  ]);
}
