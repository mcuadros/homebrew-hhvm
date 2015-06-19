class Hhvm < Formula
  desc "HHVM virtual machine, runtime, and JIT for the PHP language"
  homepage "http://hhvm.com/"
  stable do
    url "https://github.com/facebook/hhvm/archive/HHVM-3.7.2.tar.gz"
    sha256 "4f1ee67a7e848002361ec628833adb89b78d450f1087f75dc69807ed0593dd7a"
    resource "third-party" do
      url "https://github.com/hhvm/hhvm-third-party.git", :revision => "85da228178e69792b0798292b09cd7f4c6522522"
    end
  end

  devel do
    url "https://github.com/facebook/hhvm.git", :branch => "HHVM-3.7"
    version "3.7-dev"
    resource "third-party" do
      url "https://github.com/hhvm/hhvm-third-party.git", :revision => "85da228178e69792b0798292b09cd7f4c6522522"
    end
  end

  head do
    url "https://github.com/facebook/hhvm.git"
    resource "third-party" do
      url "https://github.com/hhvm/hhvm-third-party.git"
    end
  end

  option "with-cotire", "Speed up the build by precompiling headers"
  option "with-mariadb", "Build with MariaDB instead of MySQL or Percona Server"
  option "with-percona-server", "Build with Percona Server instead of MySQL or MariaDB"
  option "with-system-mysql", "Build with system installed MySQL package"
  option "with-libressl", "Build with LibreSSL instead of Secure Transport or OpenSSL"
  option "with-ninja", "Compile with Ninja instead of GNU Make"

  needs :cxx11

  # FB broken selectable path http://git.io/EqkkMA
  patch :DATA

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "llvm"  => [:build, "with-clang", "with-rtti", "with-lld"]
  depends_on "pkg-config" => :build
  depends_on "libressl" => :optional
  depends_on "ninja" => :optional
  depends_on "openssl" if build.without?("libressl")

  # Standard packages
  depends_on "boost"
  depends_on "binutils-fb"
  depends_on "curl"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gettext"
  depends_on "glog"
  depends_on "icu4c"
  depends_on "imagemagick"
  depends_on "imap-uw"
  depends_on "jemalloc-fb"
  depends_on "jpeg"
  depends_on "libdwarf-fb"
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
  # MySQL packages
  if build.with? "mariadb"
    depends_on "mariadb"
  elsif build.with? "percona-server"
    depends_on "percona-server"
  elsif build.without? "system-mysql"
    depends_on "mysql"
    depends_on "mysql-connector-c++"
  end

  def install
    ENV.cxx11
    args = [
      "-DBOOST_INCLUDEDIR=#{Formula["boost"].opt_include}",
      "-DBOOST_LIBRARYDIR=#{Formula["boost"].opt_lib}",
      "-DCCLIENT_INCLUDE_PATH=#{Formula["imap-uw"].opt_include}/imap",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DCURL_INCLUDE_DIR=#{Formula["curl"].opt_include}",
      "-DCURL_LIBRARY=#{Formula["curl"].opt_lib}/libcurl.dylib",
      "-DENABLE_MCROUTER=OFF",
      "-DENABLE_PROXYGEN_SERVER=OFF",
      "-DFREETYPE_INCLUDE_DIRS=#{Formula["freetype"].opt_include}/freetype2",
      "-DFREETYPE_LIBRARIES=#{Formula["freetype"].opt_lib}/libfreetype.dylib",
      "-DICU_DATA_LIBRARY=#{Formula["icu4c"].opt_lib}/libicudata.dylib",
      "-DICU_I18N_LIBRARY=#{Formula["icu4c"].opt_lib}/libicui18n.dylib",
      "-DICU_INCLUDE_DIR=#{Formula["icu4c"].opt_include}",
      "-DICU_LIBRARY=#{Formula["icu4c"].opt_lib}/libicuuc.dylib",
      "-DJEMALLOC_INCLUDE_DIR=#{Formula["jemalloc-fb"].opt_include}",
      "-DJEMALLOC_LIB=#{Formula["jemalloc-fb"].opt_lib}/libjemalloc.dylib",
      "-DLBER_LIBRARIES=/usr/lib/liblber.dylib",
      "-DLDAP_INCLUDE_DIR=/usr/include",
      "-DLDAP_LIBRARIES=/usr/lib/libldap.dylib",
      "-DLIBDWARF_INCLUDE_DIRS=#{Formula["libdwarf-fb"].opt_include}",
      "-DLIBDWARF_LIBRARIES=#{Formula["libdwarf-fb"].opt_lib}/libdwarf.3.dylib",
      "-DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula["libevent"].opt_include}",
      "-DLIBEVENT_LIB=#{Formula["libevent"].opt_lib}/libevent.dylib",
      "-DLIBGLOG_INCLUDE_DIR=#{Formula["glog"].opt_include}",
      "-DLIBINTL_INCLUDE_DIR=#{Formula["gettext"].opt_include}",
      "-DLIBINTL_LIBRARIES=#{Formula["gettext"].opt_lib}/libintl.dylib",
      "-DLIBJPEG_INCLUDE_DIRS=#{Formula["jpeg"].opt_include}",
      "-DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula["imagemagick"].opt_include}/ImageMagick-6",
      "-DLIBMAGICKWAND_LIBRARIES=#{Formula["imagemagick"].opt_lib}/libMagickWand-6.Q16.dylib",
      "-DLIBMEMCACHED_INCLUDE_DIR=#{Formula["libmemcached"].opt_include}",
      "-DLIBODBC_INCLUDE_DIRS=#{Formula["unixodbc"].opt_include}",
      "-DLIBPNG_INCLUDE_DIRS=#{Formula["libpng"].opt_include}",
      "-DLIBSQLITE3_INCLUDE_DIR=#{Formula["sqlite"].opt_include}",
      "-DLIBSQLITE3_LIBRARY=#{Formula["sqlite"].opt_lib}/libsqlite3.0.dylib",
      "-DLIBVPX_INCLUDE_DIRS=#{Formula["libvpx"].opt_include}",
      "-DLIBVPX_LIBRARIES=#{Formula["libvpx"].opt_lib}/libvpx.a",
      "-DLIBZIP_INCLUDE_DIR_ZIP=#{Formula["libzip"].opt_include}",
      "-DLIBZIP_INCLUDE_DIR_ZIPCONF=#{Formula["libzip"].opt_lib}/libzip/include",
      "-DLIBZIP_LIBRARY=#{Formula["libzip"].opt_lib}/libzip.dylib",
      "-DLZ4_INCLUDE_DIR=#{Formula["lz4"].opt_include}",
      "-DLZ4_LIBRARY=#{Formula["lz4"].opt_lib}/liblz4.dylib",
      "-DMcrypt_INCLUDE_DIR=#{Formula["mcrypt"].opt_include}",
      "-DMYSQL_UNIX_SOCK_ADDR=/dev/null",
      "-DOCAMLC_EXECUTABLE=#{Formula["objective-caml"].opt_prefix}/bin/ocamlc",
      "-DOCAMLC_OPT_EXECUTABLE=#{Formula["objective-caml"].opt_prefix}/bin/ocamlc.opt",
      "-DONIGURUMA_INCLUDE_DIR=#{Formula["oniguruma"].opt_include}",
      "-DPCRE_INCLUDE_DIR=#{Formula["pcre"].opt_include}",
      "-DPCRE_LIBRARY=#{Formula["pcre"].opt_lib}/libpcre.dylib",
      "-DREADLINE_INCLUDE_DIR=#{Formula["readline"].opt_include}",
      "-DREADLINE_LIBRARY=#{Formula["readline"].opt_lib}/libreadline.dylib",
      "-DSYSTEM_PCRE_INCLUDE_DIR=#{Formula["pcre"].opt_include}",
      "-DSYSTEM_PCRE_LIBRARY=#{Formula["pcre"].opt_lib}/libpcre.dylib",
      "-DTBB_INCLUDE_DIRS=#{Formula["tbb"].opt_include}",
      "-DTEST_TBB_INCLUDE_DIR=#{Formula["tbb"].opt_include}",
    ] + std_cmake_args

    # To use ninja for building
    args << "-GNinja" if build.with?("ninja")

    # Force compilation with homebrew-clang
    ENV["CC"] = "#{Formula["llvm"].opt_bin}/clang"
    ENV["LD"] = "#{Formula["llvm"].opt_prefix}/bin/lld"
    ENV["CXX"] = "#{Formula["llvm"].opt_bin}/clang++"
    args << "-DCMAKE_C_COMPILER=#{Formula["llvm"].opt_bin}/clang"
    args << "-DCMAKE_CXX_COMPILER=#{Formula["llvm"].opt_bin}/clang++"
    args << "-DCMAKE_ASM_COMPILER=#{Formula["llvm"].opt_bin}/clang"
    #args << "-DCMAKE_LINKER=#{Formula["llvm"].opt_bin}/lld"
    #args << "-DCMAKE_AR=#{Formula["llvm"].opt_bin}/llvm-ar"
    #args << "-DCMAKE_RANLIB=#{Formula["llvm"].opt_bin}/llvm-ranlib"
    # Compiler complains about link compatibility with otherwise
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")

    args << "-DBFD_LIB=#{Formula["binutils-fb"].opt_lib}/libbfd.a"
    args << "-DCMAKE_INCLUDE_PATH=#{Formula["binutils-fb"].opt_include}"
    args << "-DLIBIBERTY_LIB=#{Formula["binutils-fb"].opt_lib}/libiberty.a"

    if build.with?("cotire")
      args << "-DENABLE_COTIRE=ON"
    end

    if build.with?("mariadb")
      args << "-DMYSQL_INCLUDE_DIR=#{Formula["mariadb"].opt_include}/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula["mariadb"].opt_lib}"
    elsif build.with?("percona-server")
      args << "-DMYSQL_INCLUDE_DIR=#{Formula["percona-server"].opt_include}/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula["percona-server"].opt_lib}"
    elsif build.without?("system-mysql")
      args << "-DMYSQL_INCLUDE_DIR=#{Formula["mysql"].opt_include}/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula["mysql"].opt_lib}"
    end

    if build.with?("libressl")
      args << "-DOPENSSL_SSL_LIBRARY=#{Formula["libressl"].opt_lib}/libssl.dylib"
      args << "-DOPENSSL_INCLUDE_DIR=#{Formula["libressl"].opt_include}"
      args << "-DOPENSSL_CRYPTO_LIBRARY=#{Formula["libressl"].opt_lib}/libcrypto.dylib"
    else
      args << "-DOPENSSL_SSL_LIBRARY=#{Formula["openssl"].opt_lib}/libssl.dylib"
      args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}"
      args << "-DOPENSSL_CRYPTO_LIBRARY=#{Formula["openssl"].opt_lib}/libcrypto.dylib"
    end

    # 3rd packages
    rm_rf "third-party"
    third_party_buildpath = buildpath/"third-party"
    third_party_buildpath.install resource("third-party")

    # Fix Traits.h std::* declarations conflict with libc++
    # https://github.com/facebook/folly/pull/81
    inreplace third_party_buildpath/"folly/src/folly/Traits.h",
      "FOLLY_NAMESPACE_STD_BEGIN", "#if 0\nFOLLY_NAMESPACE_STD_BEGIN"
    inreplace third_party_buildpath/"folly/src/folly/Traits.h",
      "FOLLY_NAMESPACE_STD_END",
      "FOLLY_NAMESPACE_STD_END\n#else\n#include <utility>\n#include <string>\n#include <vector>\n#include <deque>\n#include <list>\n#include <set>\n#include <map>\n#include <memory>\n#endif\n"

    src = prefix + "src"
    src.install Dir["*"]

    ENV["HPHP_HOME"] = src

    cd src do
      system "cmake", ".", *args
      if build.with?("ninja")
        system "ninja", "install"
      else
        system "make", "install"
      end
    end

    install_config
  end

  def install_config
    ini_php = etc + "hhvm/php.ini"
    ini_php.write default_php_ini unless File.exist? ini_php
    ini_server = etc + "hhvm/server.ini"
    ini_server.write default_server_ini unless File.exist? ini_server
  end

  # https://gist.github.com/denji/1a2ff183a671efcabedf
  def default_php_ini; <<-EOS.undent
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

  def default_server_ini; <<-EOS.undent
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

  def caveats; <<-EOS.undent
      If you have XQuartz (X11) installed,
      to temporarily remove a symbolic link at "/usr/X11R6"
      in order to successfully install HHVM.
        $ sudo rm /usr/X11R6
        $ sudo ln -s /opt/X11 /usr/X11R6

      The php.ini file can be found in:
        #{etc}/hhvm/php.ini
    EOS
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

__END__
diff --git a/hphp/runtime/base/emulate-zend.cpp b/hphp/runtime/base/emulate-zend.cpp
index 2d89168..21690c2 100644
--- a/hphp/runtime/base/emulate-zend.cpp
+++ b/hphp/runtime/base/emulate-zend.cpp
@@ -234,8 +234,8 @@ int emulate_zend(int argc, char** argv) {
       newargv.push_back("-c");
       newargv.push_back(filename);
     };
-    add_default_config_files_globbed("/etc/hhvm/php*.ini", cb);
-    add_default_config_files_globbed("/etc/hhvm/config*.hdf", cb);
+    add_default_config_files_globbed("/usr/local/etc/hhvm/php*.ini", cb);
+    add_default_config_files_globbed("/usr/local/etc/hhvm/config*.hdf", cb);
   }
 
   if (cnt < argc && strcmp(argv[cnt], "--") == 0) cnt++;
diff --git a/hphp/runtime/base/program-functions.cpp b/hphp/runtime/base/program-functions.cpp
index a8cf975..7576785 100644
--- a/hphp/runtime/base/program-functions.cpp
+++ b/hphp/runtime/base/program-functions.cpp
@@ -1345,9 +1345,9 @@ static int execute_program_impl(int argc, char** argv) {
           Logger::Verbose("Using default config file: %s", filename);
           po.config.push_back(filename);
         };
-        add_default_config_files_globbed("/etc/hhvm/php*.ini",
+        add_default_config_files_globbed("/usr/local/etc/hhvm/php*.ini",
                                          file_callback);
-        add_default_config_files_globbed("/etc/hhvm/config*.hdf",
+        add_default_config_files_globbed("/usr/local/etc/hhvm/config*.hdf",
                                          file_callback);
       }
 // When we upgrade boost, we can remove this and also get rid of the parent
