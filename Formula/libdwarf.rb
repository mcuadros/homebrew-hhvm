class Libdwarf < Formula
  desc "compilation tools (nm, ar, as, ld, etc.) for the ELF object format"
  homepage "http://sourceforge.net/apps/trac/elftoolchain/"
  url "https://downloads.sourceforge.net/project/elftoolchain/Sources/elftoolchain-0.6.1/elftoolchain-0.6.1.tgz"
  sha256 "f4dc6e2a820f146658d6b5f9a062a2e676d0715aca654f55866c60e0025561eb"

  depends_on :bsdmake => :build
  depends_on "libarchive"
  depends_on "libelf"

  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-common-elftc.diff?rev=98117&format=raw"
    sha256 "e00505d7ffc62df5e20cb285ae4b27d3ab3c8948fe79d0f5637bed2326400214"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-byteorder-macros.diff?rev=98117&format=raw"
    sha256 "a46bd66f14723aebba84932a295626374d314d1afe3ba684be7d0661c366c9de"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-libelf-config.diff?rev=98117&format=raw"
    sha256 "a5e76d9383c70e870ff32bfd7fc52c8c4cdeca04410ee2f823d11bd9aba26c58"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-mk.diff?rev=98117&format=raw"
    sha256 "aa7668354ae13930fde1c3c7acae98d9098a9356b998801eb65e2e4323b58cb2"
  end

  def install
    inreplace "mk/elftoolchain.prog.mk", "@PREFIX@", prefix
    system "bsdmake libdwarf"

    # bsdmake rules are not reliable enough for this.
    lib.install Dir["libdwarf/*.a"]
    lib.install Dir["libdwarf/*.dylib"]
    include.install Dir["libdwarf/*.h"]
  end
end
