require 'formula'

class Hhvm < Formula
  url 'https://github.com/facebook/hhvm/archive/HHVM-3.2.0.tar.gz'
  homepage 'https://github.com/facebook/hhvm/tree/HHVM-3.2.0'
  sha1 '039f97ae85244bdc5a06f0822f1f993f53badca5'
  head 'https://github.com/facebook/hhvm.git'

  option 'with-debug', 'Enable debug build.'
  option 'with-mariadb', 'Use mariadb as mysql package.'
  option 'with-percona-server', 'Use percona-server as mysql package.'
  option 'with-system-mysql', 'Try to use the mysql package installed on your system.'

  depends_on 'cmake' => :build
  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'glog' => :build
  depends_on 'boost' => :build

  #Standard packages
  depends_on 'gcc48'
  depends_on 'binutils'
  depends_on 'boost'
  depends_on 'curl'
  depends_on 'freetype'
  depends_on 'gd'
  depends_on 'gettext'
  depends_on 'glog'
  depends_on 'icu4c'
  depends_on 'imagemagick'
  depends_on 'imap-uw'
  depends_on 'jpeg'
  depends_on 'libelf'
  depends_on 'libmemcached'
  depends_on 'libpng'
  depends_on 'libssh2'
  depends_on 'mcrypt'
  depends_on 'ncurses'
  depends_on 'oniguruma'
  depends_on 'pcre'
  depends_on 're2c'
  depends_on 'readline'
  depends_on 'tbb'
  depends_on 'unixodbc'
  depends_on 'git'
  depends_on 'libxslt'
  depends_on 'libevent'
  depends_on 'sqlite'

  #Custome packages
  depends_on 'folly'
  depends_on 'hhvm-third-party'
  depends_on 'jemallocfb'
  depends_on 'libdwarf'

  #MySQL packages
  if build.with? 'mariadb'
    depends_on 'mariadb'
  elsif build.with? 'percona-server'
    depends_on 'percona-server'
  elsif build.without? 'system-mysql'
    depends_on 'mysql'
    depends_on 'mysql-connector-c++'
  end

  def install
    args = [
      ".",
      "-DCMAKE_CXX_COMPILER=#{Formula['gcc48'].opt_prefix}/bin/g++-4.8",
      "-DCMAKE_C_COMPILER=#{Formula['gcc48'].opt_prefix}/bin/gcc-4.8",
      "-DCMAKE_ASM_COMPILER=#{Formula['gcc48'].opt_prefix}/bin/gcc-4.8",
      "-DLIBIBERTY_LIB=#{Formula['gcc48'].opt_prefix}/lib/x86_64/libiberty-4.8.a",
      "-DCMAKE_INCLUDE_PATH=\"#{HOMEBREW_PREFIX}/include:/usr/include\"",
      "-DCMAKE_LIBRARY_PATH=\"#{HOMEBREW_PREFIX}/lib:/usr/lib\"",
      "-DLIBEVENT_LIB=#{Formula['libevent'].opt_prefix}/lib/libevent.dylib",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula['libevent'].opt_prefix}/include",
      "-DICU_INCLUDE_DIR=#{Formula['icu4c'].opt_prefix}/include",
      "-DICU_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicuuc.dylib",
      "-DICU_I18N_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicui18n.dylib",
      "-DICU_DATA_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicudata.dylib",
      "-DREADLINE_INCLUDE_DIR=#{Formula['readline'].opt_prefix}/include",
      "-DREADLINE_LIBRARY=#{Formula['readline'].opt_prefix}/lib/libreadline.dylib",
      "-DNCURSES_LIBRARY=#{Formula['ncurses'].opt_prefix}/lib/libncurses.dylib",
      "-DCURL_INCLUDE_DIR=#{Formula['curl'].opt_prefix}/include",
      "-DCURL_LIBRARY=#{Formula['curl'].opt_prefix}/lib/libcurl.dylib",
      "-DBOOST_INCLUDEDIR=#{Formula['boost'].opt_prefix}/include",
      "-DBOOST_LIBRARYDIR=#{Formula['boost'].opt_prefix}/lib",
      "-DBoost_USE_STATIC_LIBS=ON",
      "-DJEMALLOC_INCLUDE_DIR=#{Formula['jemallocfb'].opt_prefix}/include",
      "-DJEMALLOC_LIB=#{Formula['jemallocfb'].opt_prefix}/lib/libjemalloc.dylib",
      "-DLIBINTL_LIBRARIES=#{Formula['gettext'].opt_prefix}/lib/libintl.dylib",
      "-DLIBINTL_INCLUDE_DIR=#{Formula['gettext'].opt_prefix}/include",
      "-DLIBDWARF_LIBRARIES=#{Formula['libdwarf'].opt_prefix}/lib/libdwarf.3.dylib",
      "-DLIBDWARF_INCLUDE_DIRS=#{Formula['libdwarf'].opt_prefix}/include",
      "-DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula['imagemagick'].opt_prefix}/include/ImageMagick-6",
      "-DLIBMAGICKWAND_LIBRARIES=#{Formula['imagemagick'].opt_prefix}/lib/libMagickWand-6.Q16.dylib",
      "-DFREETYPE_INCLUDE_DIRS=#{Formula['freetype'].opt_prefix}/include/freetype2/",
      "-DFREETYPE_LIBRARIES=#{Formula['freetype'].opt_prefix}/lib/libfreetype.dylib",
      "-DLIBSQLITE3_INCLUDE_DIR=#{Formula['sqlite'].opt_prefix}/include",
      "-DLIBSQLITE3_LIBRARY=#{Formula['sqlite'].opt_prefix}/lib/libsqlite3.0.dylib",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",

      "-DLIBELF_INCLUDE_DIRS=#{Formula['libelf'].opt_prefix}/include/libelf",

      "-DCCLIENT_INCLUDE_PATH=#{Formula['imap-uw'].opt_prefix}/include/imap",
      "-DLIBGLOG_INCLUDE_DIR=#{Formula['glog'].opt_prefix}/include",
      "-DLIBJPEG_INCLUDE_DIRS=#{Formula['jpeg'].opt_prefix}/include",
      "-DLIBMEMCACHED_INCLUDE_DIR=#{Formula['libmemcached'].opt_prefix}/include",
      "-DLIBODBC_INCLUDE_DIRS=#{Formula['unixodbc'].opt_prefix}/include",
      "-DLIBPNG_INCLUDE_DIRS=#{Formula['libpng'].opt_prefix}/include",
      "-DMcrypt_INCLUDE_DIR=#{Formula['mcrypt'].opt_prefix}/include",
      "-DONIGURUMA_INCLUDE_DIR=#{Formula['oniguruma'].opt_prefix}/include",
      "-DPCRE_INCLUDE_DIR=#{Formula['pcre'].opt_prefix}/include",
      "-DTBB_INCLUDE_DIRS=#{Formula['tbb'].opt_prefix}/include",
      "-DTEST_TBB_INCLUDE_DIR=#{Formula['tbb'].opt_prefix}/include"
    ]

    if build.with? 'mariadb'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mariadb'].opt_prefix}/include/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['mariadb'].opt_prefix}/lib"
    elsif build.with? 'percona-server'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['percona-server'].opt_prefix}/include/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['percona-server'].opt_prefix}/lib"
    elsif build.without? 'system-mysql'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mysql'].opt_prefix}/include/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['mysql'].opt_prefix}/lib"
    end

    src = prefix + "src"
    src.install Dir['*']

    ENV['HPHP_HOME'] = src

    cd src do
      system "rm -rf third-party"
      system "ln -s #{Formula['hhvm-third-party'].opt_prefix} third-party"

      system "cmake", *args
      system "make", "-j#{ENV.make_jobs}"
      system "make install"
    end

    install_config
  end

  def install_config
    ini = etc + "hhvm/php.ini"
    ini.write default_php_ini unless File.exists? ini
  end

  def default_php_ini
    <<-EOS.undent
      ; php options
      date.timezone = Europe/Paris

      ; hhvm specific
      hhvm.log.level = Warning
      hhvm.log.always_log_unhandled_exceptions = true
      hhvm.log.runtime_error_reporting_level = 8191
      hhvm.mysql.typed_results = false
      hhvm.eval.jit = false
    EOS
  end

  def caveats
    <<-EOS.undent
      If you have XQuartz (X11) installed:
        To temporarily remove a symbolic link at '/usr/X11R6' in order
        to successfully install HHVM.
          $ sudo rm /usr/X11R6
          $ sudo ln -s /opt/X11 /usr/X11R6


      If you are getting errors like 'Undefined symbols for architecture x86_64:',
      related to google or boost, execute:
        $ brew reinstall --build-from-source --cc=gcc-4.8 boost gflags glog

      The php.ini file can be found in:
          #{etc}/hhvm/php.ini
    EOS
  end

  bottle do
    root_url 'https://github.com/mcuadros/homebrew-hhvm/releases/download/v3.2.0/'
    sha1 "99e61efe50ae22a84701123748425131d85a4d4d" => :mavericks
  end
end
