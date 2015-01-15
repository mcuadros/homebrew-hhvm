class Gflagsfb < Formula
  homepage "http://code.google.com/p/google-gflags/"
  url 'https://gflags.googlecode.com/files/gflags-2.0.tar.gz'
  sha1 'dfb0add1b59433308749875ac42796c41e824908'
  head "https://github.com/schuhschuh/gflags.git"

  keg_only "We dont want to interfere with normal boost."

  depends_on "gcc"

  def install
    gcc = Formula["gcc"]
    # Force compilation with gcc-4.9
    ENV['CC'] = "#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
    ENV['LD'] = "#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
    ENV['CXX'] = "#{gcc.opt_prefix}/bin/g++-#{gcc.version_suffix}"
    # Compiler complains about link compatibility with otherwise
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
