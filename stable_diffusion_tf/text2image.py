from pathlib import Path
from typing import NamedTuple


class Run(NamedTuple):
    """A single run of stable diffusion"""

    prompt: str
    output: Path
    seed: int = 42

    @classmethod
    def from_json(cls, run: str):
        return cls(**{**run, "output": Path(run['output'])})


def text2image(runs: list[Run], args):
    from tensorflow import keras
    from .stable_diffusion import StableDiffusion
    from PIL import Image

    generator = StableDiffusion(img_height=args.H, img_width=args.W, jit_compile=False)

    for run in runs:
        img = generator.generate(
            run.prompt,
            num_steps=args.steps,
            unconditional_guidance_scale=args.scale,
            temperature=1,
            batch_size=1,
            seed=run.seed,
        )
        Image.fromarray(img[0]).save(run.output)
        print(f"saved at {run.output}")
