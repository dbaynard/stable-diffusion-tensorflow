import argparse
from json import loads
from sys import stdin, exit


from stable_diffusion_tf.create import Run, create


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


def main():
    args = parser.parse_args()

    runs = [Run.from_json(run) for run in loads(stdin.read())]

    if runs:
        create(runs, args)
    else:
        print("No runs")


if __name__ == "__main__":
    main()
