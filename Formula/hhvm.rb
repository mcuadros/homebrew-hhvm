require 'formula'

class Hhvm < Formula
  url 'https://github.com/facebook/hhvm/archive/HHVM-2.2.zip'
  homepage 'https://github.com/facebook/hhvm/tree/HHVM-2.2'
  sha1 'e6b3fc5363f1b9a688748ef3a1cb6e0623e0c51b'

  head 'https://github.com/facebook/hhvm.git'

  depends_on 'cmake' => :build
  depends_on 'libtool' => :build 
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build

  depends_on 'gettext'
  depends_on 'mcrypt'
  depends_on 'glog'
  depends_on 'oniguruma'
  depends_on 're2c'
  depends_on 'libelf'
  depends_on 'readline'
  depends_on 'mysql'
  depends_on 'pcre'
  depends_on 'gd'
  depends_on 'icu4c'
  depends_on 'libmemcached'
  depends_on 'tbb'
  depends_on 'boost'
  depends_on 'imagemagick'
  depends_on 'mysql-connector-c++'
  depends_on 'binutils'
  depends_on 'ncurses'
  depends_on 'curl'

  if MacOS.version < :mavericks
    depends_on 'mysql-connector-c'
  end

  depends_on 'gcc48'
  depends_on 'cclient'
  depends_on 'jemallocfb'
  depends_on 'libdwarf'
  depends_on 'libeventfb'
  depends_on 'boostfb'

  def install
    args = [
      ".",
      "-DCMAKE_CXX_COMPILER=#{Formula.factory('gcc48').opt_prefix}/bin/g++-4.8",
      "-DCMAKE_C_COMPILER=#{Formula.factory('gcc48').opt_prefix}/bin/gcc-4.8",
      "-DCMAKE_ASM_COMPILER=#{Formula.factory('gcc48').opt_prefix}/bin/gcc-4.8",
      "-DCMAKE_INCLUDE_PATH=\"/usr/local/include:/usr/include\"",
      "-DCMAKE_LIBRARY_PATH=\"/usr/local/lib:/usr/lib\"",
      "-DLIBEVENT_LIB=#{Formula.factory('libeventfb').opt_prefix}/lib/libevent.dylib",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula.factory('libeventfb').opt_prefix}/include",
      "-DICU_INCLUDE_DIR=#{Formula.factory('icu4c').opt_prefix}/include",
      "-DICU_LIBRARY=#{Formula.factory('icu4c').opt_prefix}/lib/libicuuc.dylib",
      "-DICU_I18N_LIBRARY=#{Formula.factory('icu4c').opt_prefix}/lib/libicui18n.dylib",
      "-DICU_DATA_LIBRARY=#{Formula.factory('icu4c').opt_prefix}/lib/libicudata.dylib",
      "-DREADLINE_INCLUDE_DIR=#{Formula.factory('readline').opt_prefix}/include",
      "-DREADLINE_LIBRARY=#{Formula.factory('readline').opt_prefix}/lib/libreadline.dylib",
      "-DNCURSES_LIBRARY=#{Formula.factory('ncurses').opt_prefix}/lib/libncurses.dylib",
      "-DCURL_INCLUDE_DIR=#{Formula.factory('curl').opt_prefix}/include",
      "-DCURL_LIBRARY=#{Formula.factory('curl').opt_prefix}/lib/libcurl.dylib",
      "-DBOOST_INCLUDEDIR=#{Formula.factory('boostfb').opt_prefix}/include",
      "-DBOOST_LIBRARYDIR=#{Formula.factory('boostfb').opt_prefix}/lib",
      "-DBoost_USE_STATIC_LIBS=ON",
      "-DJEMALLOC_INCLUDE_DIR=#{Formula.factory('jemallocfb').opt_prefix}/include",
      "-DJEMALLOC_LIB=#{Formula.factory('jemallocfb').opt_prefix}/lib/libjemalloc.dylib",
      "-DLIBINTL_LIBRARIES=#{Formula.factory('gettext').opt_prefix}/lib/libintl.dylib",
      "-DLIBINTL_INCLUDE_DIR=#{Formula.factory('gettext').opt_prefix}/include",
      "-DLIBDWARF_LIBRARIES=#{Formula.factory('libdwarf').opt_prefix}/lib/libdwarf.3.dylib",
      "-DLIBDWARF_INCLUDE_DIRS=#{Formula.factory('libdwarf').opt_prefix}/include"
    ]

    if MacOS.version < :mavericks
      args << "-DBINUTIL_LIB=#{Formula.factory('gcc48').opt_prefix}/lib/x86_64/libiberty.a"
    else 
      args << "-DBINUTIL_LIB=#{Formula.factory('gcc48').opt_prefix}/lib/x86_64/libiberty-4.8.a"
    end

    ENV['HPHP_HOME'] = Dir.pwd

    system "cmake", *args
    system "make", "-j#{ENV.make_jobs}"
    system "make install"
  end
end
