class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.12.tar.gz"
  sha256 "aeed3f6ca0f4e352137b0196e9dddbdce542a9e99dda9effd915e018923cd428"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "142084b08e652f1b4bac49bc2b4633a8da661e998d53cfe57a483d6f64af743b"
    sha256 arm64_big_sur:  "d67f70b4f81e4d8e4824100ec04534a1148f09a1db240ebc412c4ece5506a3d6"
    sha256 monterey:       "51bb16e0cce068f13d652da480b80d33cda96118cb0c94afa458c5cbc19c4411"
    sha256 big_sur:        "34c616e203f1f35770c5a5d10c2c52a3351259e2b4ef7e99c59fcbeb28252e46"
    sha256 catalina:       "05f07a50558b4e2731ba0989322d3354238d81d926eb54aabb1ecf5c91f085a8"
    sha256 x86_64_linux:   "3f43f81206bac39b28fe2bbb162090eae354cadc2d3ef0919bc28f58f3a5fc06"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

  # build patch for sdl_image.h include, remove in next release
  patch do
    url "https://github.com/tmewett/BrogueCE/commit/baff9b5081c60ec3c0117913e419fa05126025db.patch?full_index=1"
    sha256 "7b51b43ca542958cd2051d6edbe8de3cbe73a5f1ac3e0d8e3c9bff99554f877e"
  end

  def install
    system "make", "bin/brogue", "RELEASE=YES", "TERMINAL=YES", "DATADIR=#{libexec}"
    libexec.install "bin/brogue", "bin/keymap.txt", "bin/assets"

    # Use var directory to save highscores and replay files across upgrades
    (bin/"brogue").write <<~EOS
      #!/bin/bash
      cd "#{var}/brogue" && exec "#{libexec}/brogue" "$@"
    EOS
  end

  def post_install
    (var/"brogue").mkpath
  end

  def caveats
    <<~EOS
      If you are upgrading from 1.7.2, you need to copy your highscores file:
          cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
    EOS
  end

  test do
    system "#{bin}/brogue", "--version"
  end
end
