require 'formula'

class Hhvm < Formula
  url 'https://github.com/facebook/hhvm/archive/HHVM-2.4.1.tar.gz'
  homepage 'https://github.com/facebook/hhvm/tree/HHVM-2.4.1'
  sha1 '03991f64245b87f6d7783c446559379a7349ed3a'

  head 'https://github.com/facebook/hhvm.git'

  depends_on 'cmake' => :build
  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build

  #Standard packages
  depends_on 'freetype'
  depends_on 'gettext'
  depends_on 'mcrypt'
  depends_on 'glog'
  depends_on 'oniguruma'
  depends_on 're2c'
  depends_on 'libelf'
  depends_on 'readline'
  depends_on 'pcre'
  depends_on 'gd'
  depends_on 'imagemagick'
  depends_on 'icu4c'
  depends_on 'libmemcached'
  depends_on 'tbb'
  depends_on 'boost'
  depends_on 'imagemagick'
  depends_on 'binutils'
  depends_on 'ncurses'
  depends_on 'libssh2'
  depends_on 'curl'
  depends_on 'imap-uw'
  depends_on 'gcc48'

  #Custome packages
  if build.stable?
    depends_on 'folly'
  end

  depends_on 'jemallocfb'
  depends_on 'libdwarf'
  depends_on 'libeventfb'
  depends_on 'boostfb'

  #MySQL packages
  if build.include? 'with-mariadb'
    depends_on 'mariadb'
  elsif build.include? 'with-percona-server'
    depends_on 'percona-server'
  else
    depends_on 'mysql'
    depends_on 'mysql-connector-c++'
    if MacOS.version < :mavericks
      depends_on 'mysql-connector-c'
    end
  end

  def install
    args = [
      ".",
      "-DCMAKE_CXX_COMPILER=#{Formula.factory('gcc48').opt_prefix}/bin/g++-4.8",
      "-DCMAKE_C_COMPILER=#{Formula.factory('gcc48').opt_prefix}/bin/gcc-4.8",
      "-DCMAKE_ASM_COMPILER=#{Formula.factory('gcc48').opt_prefix}/bin/gcc-4.8",
      "-DBINUTIL_LIB=#{Formula.factory('gcc48').opt_prefix}/lib/x86_64/libiberty-4.8.a",
      "-DLIBIBERTY_LIB=#{Formula.factory('gcc48').opt_prefix}/lib/x86_64/libiberty-4.8.a",
      "-DCMAKE_INCLUDE_PATH=\"#{HOMEBREW_PREFIX}/include:/usr/include\"",
      "-DCMAKE_LIBRARY_PATH=\"#{HOMEBREW_PREFIX}/lib:/usr/lib\"",
      "-DLIBEVENT_LIB=#{Formula.factory('libeventfb').opt_prefix}/lib/libevent.dylib",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula.factory('libeventfb').opt_prefix}/include",
      "-DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula.factory('imagemagick').opt_prefix}/include/ImageMagick-6",
      "-DLIBMAGICKWAND_LIBRARIES=#{Formula.factory('imagemagick').opt_prefix}/lib/libMagickWand-6.Q16.dylib",
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
      "-DLIBDWARF_INCLUDE_DIRS=#{Formula.factory('libdwarf').opt_prefix}/include",
      "-DLIBELF_INCLUDE_DIRS=#{Formula.factory('libelf').opt_prefix}/include/libelf",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    ]

    ENV['HPHP_HOME'] = Dir.pwd

    if build.stable?
      system "rm -rf hphp/submodules/folly"
      system "ln -s #{Formula.factory('folly').opt_prefix} hphp/submodules/folly"
    end

    system "cmake", *args
    system "make", "-j#{ENV.make_jobs}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      If you have XQuartz (X11) installed:
        To temporarily remove a symbolic link at '/usr/X11R6' in order
        to successfully install HHVM.

        $ sudo rm /usr/X11R6
        $ sudo ln -s /opt/X11 /usr/X11R6

      MySQL to compile, by default will use Oracle MySQL
        Select MariaDB: --with-mariadb
         or
        Select Percona-Server: --with-percona-server
    EOS
  end
end
