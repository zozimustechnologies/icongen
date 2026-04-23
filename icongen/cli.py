import argparse
import os
import subprocess
import sys

from PIL import Image

from icongen import __version__

DEFAULT_SIZES = [16, 32, 48, 64, 128, 256, 512]

EXTREME_SIZES = [
    16, 20, 24, 29, 32, 40, 48, 50, 57, 58, 60, 64, 72, 76, 80, 87,
    96, 100, 114, 120, 128, 144, 150, 152, 167, 180, 192, 256, 300,
    384, 512, 1024,
]


def convert_svg(input_file, size, output_file):
    subprocess.run(
        ["rsvg-convert", "-w", str(size), "-h", str(size), input_file, "-o", output_file],
        check=True,
    )


def convert_raster(img, size, output_file):
    resized = img.resize((size, size), Image.LANCZOS)
    resized.save(output_file, "PNG")


def generate_icons(input_file, output_dir, sizes):
    os.makedirs(output_dir, exist_ok=True)

    _, ext = os.path.splitext(input_file)
    ext = ext.lower()

    if ext == ".svg":
        for size in sizes:
            out = os.path.join(output_dir, f"icon-{size}.png")
            convert_svg(input_file, size, out)

    elif ext in [".png", ".jpg", ".jpeg"]:
        img = Image.open(input_file).convert("RGBA")
        for size in sizes:
            out = os.path.join(output_dir, f"icon-{size}.png")
            convert_raster(img, size, out)

    else:
        print(f"Unsupported file type: {ext}", file=sys.stderr)
        sys.exit(1)

    print(f"Done! Generated {len(sizes)} icons in: {output_dir}")


def main():
    parser = argparse.ArgumentParser(
        prog="icongen",
        description="Generate icons at multiple sizes from a logo image (SVG, PNG, JPG).",
    )
    parser.add_argument("input", help="Path to the source image (.svg, .png, .jpg, .jpeg)")
    parser.add_argument(
        "output",
        nargs="?",
        default="output",
        help="Output folder (default: ./output)",
    )
    parser.add_argument(
        "--extreme",
        action="store_true",
        help="Generate an extended set of sizes for all major platforms",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )

    args = parser.parse_args()

    if not os.path.isfile(args.input):
        parser.error(f"Input file not found: {args.input}")

    sizes = EXTREME_SIZES if args.extreme else DEFAULT_SIZES
    generate_icons(args.input, args.output, sizes)


if __name__ == "__main__":
    main()
