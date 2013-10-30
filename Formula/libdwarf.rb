require 'formula'

class Libdwarf < Formula
  homepage 'http://sourceforge.net/apps/trac/elftoolchain/'
  url 'http://sourceforge.net/projects/elftoolchain/files/Sources/elftoolchain-0.6.1/elftoolchain-0.6.1.tgz'
  sha1 '023d40f5ef618c9910389880a5df65970d88fc0b'

  depends_on :bsdmake => :build
  depends_on 'libarchive'

  def patches
    { :p0 => [
        "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-common-elftc.diff?rev=98117&format=raw",
        "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-byteorder-macros.diff?rev=98117&format=raw",
        "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-libelf-config.diff?rev=98117&format=raw",
        "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-mk.diff?rev=98117&format=raw"
    ] } 
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