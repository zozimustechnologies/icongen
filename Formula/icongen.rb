class Icongen < Formula
  desc "Generate icons at multiple sizes from a logo image (SVG/PNG/JPG)"
  homepage "https://github.com/zozimustechnologies/icongen"
  url "https://github.com/zozimustechnologies/icongen/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "775b87caf7c89a2753da3d7f8ea4c61e1dd335f17c39ce9ea0823e7607aba766"
  license "MIT"

  head "https://github.com/zozimustechnologies/icongen.git", branch: "main"

  depends_on "librsvg" # provides rsvg-convert for SVG input
  depends_on "python@3.12"

  on_macos do
    on_arm do
      resource "pillow" do
        url "https://files.pythonhosted.org/packages/d8/95/0a351b9289c2b5cbde0bacd4a83ebc44023e835490a727b2a3bd60ddc0f4/pillow-12.2.0-cp312-cp312-macosx_11_0_arm64.whl"
        sha256 "f3f40b3c5a968281fd507d519e444c35f0ff171237f4fdde090dd60699458421"
      end
    end

    on_intel do
      resource "pillow" do
        url "https://files.pythonhosted.org/packages/58/be/7482c8a5ebebbc6470b3eb791812fff7d5e0216c2be3827b30b8bb6603ed/pillow-12.2.0-cp312-cp312-macosx_10_13_x86_64.whl"
        sha256 "2d192a155bbcec180f8564f693e6fd9bccff5a7af9b32e2e4bf8c9c69dbad6b5"
      end
    end
  end

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"

    # Create virtualenv WITHOUT pip to avoid the pyexpat/libexpat symbol
    # incompatibility between Homebrew's python@3.12 bottle and macOS CLT < 26.3.
    system python, "-m", "venv", "--without-pip", "--system-site-packages", libexec

    site_packages = libexec/"lib/python3.12/site-packages"
    site_packages.mkpath

    # Pillow: the .whl resource is a raw zip file (Homebrew doesn't auto-extract it).
    # Unzip the wheel directly into site-packages — this is exactly what pip does.
    resource("pillow").stage do
      whl = Dir["*.whl"].first
      if whl
        system "/usr/bin/unzip", "-q", "-o", whl, "-d", site_packages
      else
        cp_r Pathname.pwd.children, site_packages
      end
    end

    # Copy the icongen package (pure Python, no compilation needed)
    cp_r "icongen", site_packages

    # Write a thin entry-point wrapper script
    (bin/"icongen").write <<~SH
      #!/bin/sh
      exec "#{libexec}/bin/python3.12" -c \
        "import sys; from icongen.cli import main; sys.exit(main() or 0)" "$@"
    SH
    chmod 0755, bin/"icongen"
  end

  test do
    system bin/"icongen", "--version"
    system bin/"icongen", "--help"
  end
end
