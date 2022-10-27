from json import loads
from pathlib import Path
from sys import stdin
from typing import NamedTuple

from tensorflow import keras
from stable_diffusion_tf.stable_diffusion import StableDiffusion
import argparse
from PIL import Image


class Run(NamedTuple):
    """A single run of stable diffusion"""

    prompt: str
    output: Path
    seed: int = 42


parser = argparse.ArgumentParser(
    description='''Pipe json {prompt,output,seed} from stdin'''
)

parser.add_argument(
    "--H",
    type=int,
    default=512,
    help="image height, in pixels",
)

parser.add_argument(
    "--W",
    type=int,
    default=512,
    help="image width, in pixels",
)

parser.add_argument(
    "--scale",
    type=float,
    default=7.5,
    help="unconditional guidance scale: eps = eps(x, empty) + scale * (eps(x, cond) - eps(x, empty))",
)

parser.add_argument(
    "--steps", type=int, default=50, help="number of ddim sampling steps"
)

parser.add_argument(
    "--mp",
    default=False,
    action="store_true",
    help="Enable mixed precision (fp16 computation)",
)

args = parser.parse_args()

if args.mp:
    print("Using mixed precision.")
    keras.mixed_precision.set_global_policy("mixed_float16")

generator = StableDiffusion(img_height=args.H, img_width=args.W, jit_compile=False)

runs = (Run(**{**run, "output": Path(run.output)}) for run in loads(stdin.read()))

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
    print(f"saved at {args.output}")
