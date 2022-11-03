from tensorflow import keras


def get_weights():
    text_encoder_weights_fpath = keras.utils.get_file(
        origin="file://@diffusion_models@/text_encoder_weights_fpath",
        fname="@diffusion_models@/text_encoder_weights_fpath",
        file_hash="d7805118aeb156fc1d39e38a9a082b05501e2af8c8fbdc1753c9cb85212d6619",
    )

    diffusion_model_weights_fpath = keras.utils.get_file(
        origin="file://@diffusion_models@/diffusion_model_weights_fpath",
        fname="@diffusion_models@/diffusion_model_weights_fpath",
        file_hash="a5b2eea58365b18b40caee689a2e5d00f4c31dbcb4e1d58a9cf1071f55bbbd3a",
    )

    decoder_weights_fpath = keras.utils.get_file(
        origin="file://@diffusion_models@/decoder_weights_fpath",
        fname="@diffusion_models@/decoder_weights_fpath",
        file_hash="6d3c5ba91d5cc2b134da881aaa157b2d2adc648e5625560e3ed199561d0e39d5",
    )

    encoder_weights_fpath = keras.utils.get_file(
        origin="file://@diffusion_models@/encoder_weights_fpath",
        fname="@diffusion_models@/encoder_weights_fpath",
        file_hash="56a2578423c640746c5e90c0a789b9b11481f47497f817e65b44a1a5538af754",
    )

    return {
        text_encoder_weights_fpath,
        diffusion_model_weights_fpath,
        decoder_weights_fpath,
        encoder_weights_fpath,
    }
