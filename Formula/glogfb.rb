class Glogfb < Formula
  homepage "http://code.google.com/p/google-glog/"
  url "https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz"
  sha1 "ed40c26ecffc5ad47c618684415799ebaaa30d65"

  keg_only "We dont want to interfere with normal boost."

  depends_on "gflagsfb"
  depends_on "gcc"

  if MacOS.version >= :mavericks
    # Since 0.3.4 has not yet been released, manually apply
    # r134 that refactors the way headers are included.
    patch do
      url "https://gist.githubusercontent.com/danslo/7128754/raw/9b19991da4753f5efb87ae9a6939e6c3e9bc1fdf/glog_logging_r134.diff"
      sha1 "a4a1a3d1467115f927935c441715b0f8c362abba"
    end

    # Don't use tr1 prefix when we're using libc++:
    # https://code.google.com/p/google-glog/issues/detail?id=121 (patch mirrored on gist.github.com)
    patch do
      url "https://gist.githubusercontent.com/noahm/7364571/raw/436283200fe5a3ac5d00d769bb2203260bebfcf9/libc%2B%2B.diff"
      sha1 "14fe8c422a92ebd6908861ee22cfe1a689191c18"
    end
  end

  def install
    gcc = Formula["gcc"]
    # Force compilation with gcc-4.9
    ENV['CC'] = "#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
    ENV['LD'] = "#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
    ENV['CXX'] = "#{gcc.opt_prefix}/bin/g++-#{gcc.version_suffix}"
    # Compiler complains about link compatibility with otherwise
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gflags=#{Formula['gflagsfb'].opt_prefix}"
    system "make install"
  end
end
