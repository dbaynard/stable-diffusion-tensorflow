from pathlib import Path
from typing import NamedTuple


class Text2Img(NamedTuple):
    """A single run of stable diffusion text2img"""

    prompt: str
    output: Path
    seed: int = 42

    @classmethod
    def from_json(cls, run: str):
        return cls(**{**run, "output": Path(run['output'])})


class Img2Img(NamedTuple):
    """A single run of stable diffusion img2img"""

    input: Path
    prompt: str
    output: Path
    seed: int = 42

    @classmethod
    def from_json(cls, run: str):
        return cls(
            **{**run, "input": Path(run['input']), "output": Path(run['output'])}
        )


Run = Text2Img | Img2Img


def from_json(run: str):
    try:
        return Text2Img.from_json(run)
    except (TypeError, KeyError):
        return Img2Img.from_json(run)


class Args(NamedTuple):
    H: int = 512
    W: int = 512
    scale: float = 7.5
    steps: int = 50


def create(runs: list[Run], args=Args()):
    from tensorflow import keras
    from .stable_diffusion import StableDiffusion
    from PIL import Image

    generator = StableDiffusion(img_height=args.H, img_width=args.W, jit_compile=False)

    for run in runs:
        input_image = f"{run.input.expanduser()}" if type(run) == Img2Img else None
        img = generator.generate(
            run.prompt,
            num_steps=args.steps,
            unconditional_guidance_scale=args.scale,
            temperature=1,
            batch_size=1,
            seed=run.seed,
            input_image=input_image,
            input_image_strength=0.8,
        )
        Image.fromarray(img[0]).save(run.output)
        print(f"saved at {run.output}")
