class Hhvm < Formula
  homepage "http://hhvm.com/"
  stable do
    url "https://github.com/facebook/hhvm/archive/HHVM-3.4.2.tar.gz"
    sha1 "fa0f60b5e517c55f3698738f18a4529f3f60b18f"
    resource 'third-party' do
      url "https://github.com/hhvm/hhvm-third-party.git", :revision => "38af35db27a4d962adaefde343dc6dcfc495c8b5"
    end
    resource "folly" do
      url "https://github.com/facebook/folly.git", :revision => "acc54589227951293f8d3943911f4311468605c9"
    end
    resource "thrift" do
      url "https://github.com/facebook/fbthrift.git", :revision => "378e954ac82a00ba056e6fccd5e1fa3e76803cc8"
    end
  end

  devel do
    url "https://github.com/facebook/hhvm.git", :branch => "HHVM-3.4"
    version "3.4-dev"
    resource "third-party" do
      url "https://github.com/hhvm/hhvm-third-party.git", :revision => "38af35db27a4d962adaefde343dc6dcfc495c8b5"
    end
    resource "folly" do
      url "https://github.com/facebook/folly.git", :revision => "acc54589227951293f8d3943911f4311468605c9"
    end
    resource "thrift" do
      url "https://github.com/facebook/fbthrift.git", :revision => "378e954ac82a00ba056e6fccd5e1fa3e76803cc8"
    end
  end

  head do
    url "https://github.com/facebook/hhvm.git"
    resource "third-party" do
      url "https://github.com/hhvm/hhvm-third-party.git"
    end
  end

  option "with-cotire", "Speed up the build by precompiling headers"
  option "with-debug", "Enable debug build (default Release)"
  option "with-gcc", "Build with gcc-4.9 compiler"
  option "with-mariadb", "Use mariadb as mysql package"
  option "with-minsizerel", "Enable minimal size release build"
  option "with-percona-server", "Use percona-server as mysql package"
  option "with-release-debug", "Enable release with debug build"
  option "with-system-mysql", "Try to use the mysql package installed on your system"
  option "with-libressl", "To use an alternate version of SSL (LibreSSL)"
  option "with-ninja", "To use ninja for building"

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" => :optional
  depends_on "libressl" => :optional
  depends_on "ninja" => :optional
  depends_on "openssl" if build.without? "libressl"

  # Standard packages
  depends_on "boost"
  depends_on "binutilsfb"
  depends_on "curl"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gettext"
  depends_on "glog"
  depends_on "icu4c"
  depends_on "imagemagick"
  depends_on "imap-uw"
  depends_on "jemallocfb"
  depends_on "jpeg"
  depends_on "libdwarf"
  depends_on "libelf"
  depends_on "libevent"
  depends_on "libmemcached"
  depends_on "libpng"
  depends_on "libssh2"
  depends_on "libvpx"
  depends_on "libxslt"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "mcrypt"
  depends_on "objective-caml"
  depends_on "oniguruma"
  depends_on "pcre"
  depends_on "re2c"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on "unixodbc"

  #MySQL packages
  if build.with? "mariadb"
    depends_on "mariadb"
  elsif build.with? "percona-server"
    depends_on "percona-server"
  elsif build.without? "system-mysql"
    depends_on "mysql"
    depends_on "mysql-connector-c++"
  end

  # Hotfix patches
  if build.stable? or build.devel? or build.head?
    if build.stable? or build.devel?
      # Support openssl replacements which don't export RAND_egd()
      patch do
        url "https://github.com/facebook/hhvm/commit/df1ac0a7371c818d3d4b5c85859905e373145446.diff"
        sha1 "d2f5235da22e5c80c9570dfb7fe2db94bb5d11d5"
      end
      # Improve segaddr fixing for 32-bit destructors
      patch do
        url "https://github.com/facebook/hhvm/commit/d65448c.diff"
        sha1 "d735bb7012c748fed65fdebfe9d2e9ee9bf19649"
      end
    end

    # FB broken selectable path http://git.io/EqkkMA
    patch do
      url "https://github.com/facebook/hhvm/pull/3517.diff"
      sha1 "ba8c3dbf1e75957b6733aaf52207d4e55f1d286a"
    end
  end

  def install
    args = [
      "-DBOOST_INCLUDEDIR=#{Formula['boost'].opt_include}",
      "-DBOOST_LIBRARYDIR=#{Formula['boost'].opt_lib}",
      "-DCCLIENT_INCLUDE_PATH=#{Formula['imap-uw'].opt_include}/imap",
      "-DCMAKE_FIND_FRAMEWORK=LAST",
      "-DCMAKE_INCLUDE_PATH=\"#{HOMEBREW_PREFIX}/include:/usr/include\"",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DCMAKE_LIBRARY_PATH=\"#{HOMEBREW_PREFIX}/lib:/usr/lib\"",
      "-DCMAKE_VERBOSE_MAKEFILE=ON",
      "-DCURL_INCLUDE_DIR=#{Formula['curl'].opt_include}",
      "-DCURL_LIBRARY=#{Formula['curl'].opt_lib}/libcurl.dylib",
      "-DFREETYPE_INCLUDE_DIRS=#{Formula['freetype'].opt_include}/freetype2",
      "-DFREETYPE_LIBRARIES=#{Formula['freetype'].opt_lib}/libfreetype.dylib",
      "-DICU_DATA_LIBRARY=#{Formula['icu4c'].opt_lib}/libicudata.dylib",
      "-DICU_I18N_LIBRARY=#{Formula['icu4c'].opt_lib}/libicui18n.dylib",
      "-DICU_INCLUDE_DIR=#{Formula['icu4c'].opt_include}",
      "-DICU_LIBRARY=#{Formula['icu4c'].opt_lib}/libicuuc.dylib",
      "-DJEMALLOC_INCLUDE_DIR=#{Formula['jemallocfb'].opt_include}",
      "-DJEMALLOC_LIB=#{Formula['jemallocfb'].opt_lib}/libjemalloc.dylib",
      "-DLBER_LIBRARIES=/usr/lib/liblber.dylib",
      "-DLDAP_INCLUDE_DIR=/usr/include",
      "-DLDAP_LIBRARIES=/usr/lib/libldap.dylib",
      "-DLIBDWARF_INCLUDE_DIRS=#{Formula['libdwarf'].opt_include}",
      "-DLIBDWARF_LIBRARIES=#{Formula['libdwarf'].opt_lib}/libdwarf.3.dylib",
      "-DLIBELF_INCLUDE_DIRS=#{Formula['libelf'].opt_include}/libelf",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula['libevent'].opt_include}",
      "-DLIBEVENT_LIB=#{Formula['libevent'].opt_lib}/libevent.dylib",
      "-DLIBGLOG_INCLUDE_DIR=#{Formula['glog'].opt_include}",
      "-DLIBINTL_INCLUDE_DIR=#{Formula['gettext'].opt_include}",
      "-DLIBINTL_LIBRARIES=#{Formula['gettext'].opt_lib}/libintl.dylib",
      "-DLIBJPEG_INCLUDE_DIRS=#{Formula['jpeg'].opt_include}",
      "-DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula['imagemagick'].opt_include}/ImageMagick-6",
      "-DLIBMAGICKWAND_LIBRARIES=#{Formula['imagemagick'].opt_lib}/libMagickWand-6.Q16.dylib",
      "-DLIBMEMCACHED_INCLUDE_DIR=#{Formula['libmemcached'].opt_include}",
      "-DLIBODBC_INCLUDE_DIRS=#{Formula['unixodbc'].opt_include}",
      "-DLIBPNG_INCLUDE_DIRS=#{Formula['libpng'].opt_include}",
      "-DLIBSQLITE3_INCLUDE_DIR=#{Formula['sqlite'].opt_include}",
      "-DLIBSQLITE3_LIBRARY=#{Formula['sqlite'].opt_lib}/libsqlite3.0.dylib",
      "-DLIBVPX_INCLUDE_DIRS=#{Formula['libvpx'].opt_include}",
      "-DLIBVPX_LIBRARIES=#{Formula['libvpx'].opt_lib}/libvpx.a",
      "-DLIBZIP_INCLUDE_DIR_ZIP=#{Formula['libzip'].opt_include}",
      "-DLIBZIP_INCLUDE_DIR_ZIPCONF=#{Formula['libzip'].opt_lib}/libzip/include",
      "-DLIBZIP_LIBRARY=#{Formula['libzip'].opt_lib}/libzip.dylib",
      "-DLZ4_INCLUDE_DIR=#{Formula['lz4'].opt_include}",
      "-DLZ4_LIBRARY=#{Formula['lz4'].opt_lib}/liblz4.dylib",
      "-DMcrypt_INCLUDE_DIR=#{Formula['mcrypt'].opt_include}",
      "-DOCAMLC_EXECUTABLE=#{Formula['objective-caml'].opt_prefix}/bin/ocamlc",
      "-DOCAMLC_OPT_EXECUTABLE=#{Formula['objective-caml'].opt_prefix}/bin/ocamlc.opt",
      "-DONIGURUMA_INCLUDE_DIR=#{Formula['oniguruma'].opt_include}",
      "-DPCRE_INCLUDE_DIR=#{Formula['pcre'].opt_include}",
      "-DPCRE_LIBRARY=#{Formula['pcre'].opt_lib}/libpcre.dylib",
      "-DREADLINE_INCLUDE_DIR=#{Formula['readline'].opt_include}",
      "-DREADLINE_LIBRARY=#{Formula['readline'].opt_lib}/libreadline.dylib",
      "-DSYSTEM_PCRE_INCLUDE_DIR=#{Formula['pcre'].opt_include}",
      "-DSYSTEM_PCRE_LIBRARY=#{Formula['pcre'].opt_lib}/libpcre.dylib",
      "-DTBB_INCLUDE_DIRS=#{Formula['tbb'].opt_include}",
      "-DTEST_TBB_INCLUDE_DIR=#{Formula['tbb'].opt_include}",
      "-Wno-dev",
    ]

    if build.with? 'gcc'
      opoo caveats_gcc

      gcc = Formula["gcc"]
      # Force compilation with gcc-4.9
      ENV['CC'] = "#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
      ENV['LD'] = "#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
      ENV['CXX'] = "#{gcc.opt_prefix}/bin/g++-#{gcc.version_suffix}"
      # Compiler complains about link compatibility with otherwise
      ENV.delete('CFLAGS')
      ENV.delete('CXXFLAGS')

      # Support GCC/LLVM stack-smashing protection: http://git.io/5Kzu3A
      # Preprocessor gcc performance regressions: http://git.io/4r7VCQ
      args << "-DCMAKE_C_FLAGS=-ftrack-macro-expansion=0 -fno-builtin-memcmp -pie -fPIC -fstack-protector-strong --param=ssp-buffer-size=4"
      args << "-DCMAKE_CXX_FLAGS=-ftrack-macro-expansion=0 -fno-builtin-memcmp -pie -fPIC -fstack-protector-strong --param=ssp-buffer-size=4"

      args << "-DCMAKE_CXX_COMPILER=#{gcc.opt_prefix}/bin/g++-#{gcc.version_suffix}"
      args << "-DCMAKE_C_COMPILER=#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
      args << "-DCMAKE_ASM_COMPILER=#{gcc.opt_prefix}/bin/gcc-#{gcc.version_suffix}"
      args << "-DBoost_USE_STATIC_LIBS=ON"
      args << "-DBFD_LIB=#{Formula['binutilsfb'].opt_lib}/libbfd.a"
      args << "-DCMAKE_INCLUDE_PATH=#{Formula['binutilsfb'].opt_include}"
      args << "-DLIBIBERTY_LIB=#{Formula['binutilsfb'].opt_lib}/x86_64/libiberty.a"
    else
      args << "-DBFD_LIB=#{Formula['binutilsfb'].opt_lib}/libbfd.a"
      args << "-DCMAKE_INCLUDE_PATH=#{Formula['binutilsfb'].opt_include}"
      args << "-DLIBIBERTY_LIB=#{Formula['binutilsfb'].opt_lib}/x86_64/libiberty.a"
    end

    if build.with? 'cotire'
      args << "-DENABLE_COTIRE=ON"
    end

    if build.with? 'debug'
      args << '-DCMAKE_BUILD_TYPE=Debug'
    elsif build.with? 'release-debug'
      args << '-DCMAKE_BUILD_TYPE=RelWithDebInfo'
    elsif build.with? 'minsizerel'
      args << '-DCMAKE_BUILD_TYPE=MinSizeRel'
    end

    if build.with? 'mariadb'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mariadb'].opt_include}/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['mariadb'].opt_lib}"
    elsif build.with? 'percona-server'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['percona-server'].opt_include}/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['percona-server'].opt_lib}"
    elsif build.without? 'system-mysql'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mysql'].opt_include}/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['mysql'].opt_lib}"
    end

    if build.with? 'libressl'
      args << "-DOPENSSL_SSL_LIBRARY=#{Formula['libressl'].opt_lib}/libssl.dylib"
      args << "-DOPENSSL_INCLUDE_DIR=#{Formula['libressl'].opt_include}"
      args << "-DOPENSSL_CRYPTO_LIBRARY=#{Formula['libressl'].opt_lib}/libcrypto.dylib"
    else
      args << "-DOPENSSL_SSL_LIBRARY=#{Formula['openssl'].opt_lib}/libssl.dylib"
      args << "-DOPENSSL_INCLUDE_DIR=#{Formula['openssl'].opt_include}"
      args << "-DOPENSSL_CRYPTO_LIBRARY=#{Formula['openssl'].opt_lib}/libcrypto.dylib"
    end

    #Custome packages
    rm_rf 'third-party'
    third_party_buildpath = buildpath/'third-party'
    third_party_buildpath.install resource('third-party')
    if build.stable? or build.devel?
      rm_rf 'third-party/folly/src'
      folly_buildpath = buildpath/'third-party/folly/src'
      folly_buildpath.install resource('folly')
      rm_rf 'third-party/thrift/src'
      thrift_buildpath = buildpath/'third-party/thrift/src'
      thrift_buildpath.install resource('thrift')
    end

    # Fix Traits.h std::* declarations conflict with libc++
    # https://github.com/facebook/folly/pull/81
    if build.without? 'gcc'
      inreplace third_party_buildpath/'folly/src/folly/Traits.h',
        "FOLLY_NAMESPACE_STD_BEGIN",
        "#if 0\nFOLLY_NAMESPACE_STD_BEGIN"
      inreplace third_party_buildpath/'folly/src/folly/Traits.h',
        "FOLLY_NAMESPACE_STD_END",
        "FOLLY_NAMESPACE_STD_END\n#else\n#include <utility>\n#include <string>\n#include <vector>\n#include <deque>\n#include <list>\n#include <set>\n#include <map>\n#include <memory>\n#endif\n"
    end

    src = prefix + "src"
    src.install Dir['*']

    ENV['HPHP_HOME'] = src

    cd src do
      args << "-GNinja" if build.with? 'ninja'
      system "cmake", ".", *args
      if build.with? 'ninja'
        system "ninja", "-j#{ENV.make_jobs}"
        system "ninja install"
      else
        system "make", "-j#{ENV.make_jobs}"
        system "make install"
      end
    end

    install_config
  end

  def install_config
    ini_php = etc + "hhvm/php.ini"
    ini_php.write default_php_ini unless File.exists? ini_php
    ini_server = etc + "hhvm/server.ini"
    ini_server.write default_server_ini unless File.exists? ini_server
  end

  # https://gist.github.com/denji/1a2ff183a671efcabedf
  def default_php_ini
    <<-EOS.undent
      ; php options
      session.save_handler = files
      session.save_path = /tmp
      session.gc_maxlifetime = 1440

      ; hhvm specific
      hhvm.log.level = Warning
      hhvm.log.always_log_unhandled_exceptions = true
      hhvm.log.runtime_error_reporting_level = 8191
      hhvm.mysql.typed_results = false
    EOS
  end

  def default_server_ini
    <<-EOS.undent
      ; php options
      pid = #{var}/run/hhvm/pid

      ; hhvm specific
      hhvm.server.port = 9000
      hhvm.server.type = fastcgi
      hhvm.server.default_document = index.php
      hhvm.log.use_log_file = true
      hhvm.log.file = #{var}/log/hhvm/error.log
      hhvm.repo.central.path = #{var}/run/hhvm/hhvm.hhbc
    EOS
  end

  def caveats_gcc;
    <<-EOS.undent

      If you are getting errors like 'Undefined symbols for architecture x86_64:' execute:
        $ brew reinstall --build-from-source --cc=gcc-#{Formula['gcc'].version_suffix} boost gflags glog

    EOS
  end

  def caveats
    s = <<-EOS.undent
      If you have XQuartz (X11) installed,
      to temporarily remove a symbolic link at '/usr/X11R6'
      in order to successfully install HHVM.
        $ sudo rm /usr/X11R6
        $ sudo ln -s /opt/X11 /usr/X11R6

      The php.ini file can be found in:
        #{etc}/hhvm/php.ini
    EOS
    s << caveats_gcc if build.with? 'gcc'
    s
  end

  plist_options :manual => "hhvm"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/hhvm</string>
            <string>-m daemon</string>
            <string>--config=#{etc}/hhvm/server.ini</string>
            <string>-c #{etc}/hhvm/php.ini</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
