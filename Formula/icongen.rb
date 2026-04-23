class Icongen < Formula
  include Language::Python::Virtualenv

  desc "Generate icons at multiple sizes from a logo image (SVG/PNG/JPG)"
  homepage "https://github.com/avichadda/icongen"
  # Fill in the url + sha256 after tagging your first release:
  #   git tag v1.0.0 && git push origin v1.0.0
  #   curl -L https://github.com/avichadda/icongen/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
  url "https://github.com/avichadda/icongen/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "FILL_IN_SHA256_AFTER_TAGGING_RELEASE"
  license "MIT"

  head "https://github.com/avichadda/icongen.git", branch: "main"

  depends_on "python@3.13"
  depends_on "librsvg"  # provides rsvg-convert for SVG input

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/8c/21/c2bcdd5906101a30244eaffc1b6e6ce71a31bd0742a01eb89e660ebfac2d/pillow-12.2.0.tar.gz"
    sha256 "a830b1a40919539d07806aa58e1b114df53ddd43213d9c8b75847eee6c01825"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"icongen", "--version"
    system bin/"icongen", "--help"
  end
end
