require 'formula'

class Libdwarf < Formula
  homepage 'http://sourceforge.net/apps/trac/elftoolchain/'
  url 'https://downloads.sourceforge.net/project/elftoolchain/Sources/elftoolchain-0.6.1/elftoolchain-0.6.1.tgz'
  sha1 '023d40f5ef618c9910389880a5df65970d88fc0b'

  depends_on :bsdmake => :build
  depends_on 'libarchive'
  depends_on 'libelf'

  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-common-elftc.diff?rev=98117&format=raw"
    sha1 "e68c12e55b7de0954f51859547f02be50a4d6409"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-byteorder-macros.diff?rev=98117&format=raw"
    sha1 "d58ea6f6c978386750128b40f9f593093e410d10"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-libelf-config.diff?rev=98117&format=raw"
    sha1 "4e941c0f863123257bd3eec89b61c9a0c507d5cc"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-mk.diff?rev=98117&format=raw"
    sha1 "1053f353b9d5b6289256f5cef24da13fd96b5b88"
  end

  def install
    inreplace 'mk/elftoolchain.prog.mk', '@PREFIX@', prefix
    system 'bsdmake libdwarf'

    # bsdmake rules are not reliable enough for this.
    lib.install Dir['libdwarf/*.a']
    lib.install Dir['libdwarf/*.dylib']
    include.install Dir['libdwarf/*.h']
  end

end
