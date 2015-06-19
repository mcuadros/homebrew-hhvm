class BinutilsFb < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.25.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz"
  sha256 "cccf377168b41a52a76f46df18feb8f7285654b3c1bd69fc8265cb0fc6902f2d"

  keg_only "We're just a patched version."

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-install-libiberty",
                          "--enable-targets=all"
    system "make"
    system "make install"
  end

  test do
    assert `#{bin}/gnm #{bin}/gnm`.include? 'main'
    assert_equal 0, $?.exitstatus
  end
end
