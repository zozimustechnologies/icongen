# icongen

Generate icons at multiple sizes from a logo image (SVG, PNG, JPG).

## Installation

### Homebrew (recommended)

```sh
# Install via tap (uses this repo as the formula source)
brew tap avichadda/icongen https://github.com/avichadda/icongen
brew install icongen
```

> **First-time release setup:** After tagging `v1.0.0` on GitHub, fill in the `sha256` in
> [Formula/icongen.rb](Formula/icongen.rb):
> ```sh
> curl -L https://github.com/avichadda/icongen/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
> ```
> Then update `Formula/icongen.rb` with the printed hash.

### Development (HEAD install)

```sh
brew tap avichadda/icongen https://github.com/avichadda/icongen
brew install --HEAD icongen
```

### pip

```sh
pip install git+https://github.com/avichadda/icongen.git
```

## Dependencies

- **librsvg** (for SVG input) — installed automatically by Homebrew, or: `brew install librsvg`
- **Pillow** — installed automatically

## Usage

```
icongen <input> [output_folder] [--extreme] [--version]
```

| Argument | Description |
|---|---|
| `input` | Source image: `.svg`, `.png`, `.jpg`, `.jpeg` |
| `output` | Output folder (default: `./output`) |
| `--extreme` | Generate an extended set of sizes for all major platforms |

### Examples

```sh
# Default sizes: 16 32 48 64 128 256 512
icongen logo.svg

# Custom output folder
icongen logo.png icons/

# Extreme mode (32 sizes covering iOS, Android, macOS, Windows, web)
icongen logo.svg icons/ --extreme
```

## Default sizes

`16 32 48 64 128 256 512`

## Extreme sizes

`16 20 24 29 32 40 48 50 57 58 60 64 72 76 80 87 96 100 114 120 128 144 150 152 167 180 192 256 300 384 512 1024`
