{ lib
, fetchurl
, linkFarm
}:

let
  text_encoder_weights_fpath = fetchurl {
    url = "https://huggingface.co/fchollet/stable-diffusion/resolve/main/text_encoder.h5";
    hash = "sha256-14BRGK6xVvwdOeOKmggrBVAeKvjI+9wXU8nLhSEtZhk=";
  };
  diffusion_model_weights_fpath = fetchurl {
    url = "https://huggingface.co/fchollet/stable-diffusion/resolve/main/diffusion_model.h5";
    hash = "sha256-pbLupYNlsYtAyu5omi5dAPTDHby04dWKnPEHH1W7vTo=";
  };
  decoder_weights_fpath = fetchurl {
    url = "https://huggingface.co/fchollet/stable-diffusion/resolve/main/decoder.h5";
    hash = "sha256-bTxbqR1cwrE02ogaqhV7LSrcZI5WJVYOPtGZVh0OOdU=";
  };
  encoder_weights_fpath = fetchurl {
    url = "https://huggingface.co/divamgupta/stable-diffusion-tensorflow/resolve/main/encoder_newW.h5";
    hash = "sha256-VqJXhCPGQHRsXpDAp4m5sRSB9HSX+BfmW0ShpVOK91Q=";
  };

  combined = linkFarm "stable-diffusion-weights"
    (lib.mapAttrsToList (name: path: { inherit name path; }) {
      inherit
        text_encoder_weights_fpath
        diffusion_model_weights_fpath
        decoder_weights_fpath
        encoder_weights_fpath
        ;
    });

in
combined
