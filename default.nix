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
    exts: ((overrideOverlay defaults.pre).extend defaults.post).extend
      (lib.composeManyExtensions exts);
in

poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  propagatedBuildInputs = [ diffusion-models ];
  dontUseWheelUnpack = true;

  diffusion_models = diffusion-models;
  prePatch = ''
    substituteAllInPlace stable_diffusion_tf/stable_diffusion.py
  '';

  overrides = withDefaults [
    (withSetuptools [
      "libclang"
      "pyparsing"
      "typing-extensions"
    ])
    (final: prev: {
      tensorflow-macos = prev.tensorflow-macos.overridePythonAttrs (old: {
        postInstall = old.postInstall or "" + ''
          rm $out/bin/tensorboard
        '';
      });
    })
  ];
}
