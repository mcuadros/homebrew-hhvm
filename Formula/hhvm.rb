require 'formula'

class Hhvm < Formula
  url 'https://github.com/facebook/hhvm/archive/HHVM-3.0.1.tar.gz'
  homepage 'https://github.com/facebook/hhvm/tree/HHVM-3.0.1'
  sha1 'e1bc784ce475d115d601899d1e890959daa745de'
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
  depends_on 'boostfb'
  depends_on 'imagemagick'
  depends_on 'binutilsfb'
  depends_on 'ncurses'
  depends_on 'libssh2'
  depends_on 'curl'
  depends_on 'imap-uw'
  depends_on 'gcc48'
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'unixodbc'

  #Custome packages
  if build.stable?
    depends_on 'folly'
  end

  depends_on 'jemallocfb'
  depends_on 'libdwarf'
  depends_on 'libeventfb'

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
      "-DLIBIBERTY_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/x86_64/libiberty.a",
      "-DCMAKE_INCLUDE_PATH=\"#{HOMEBREW_PREFIX}/include:/usr/include\"",
      "-DCMAKE_LIBRARY_PATH=\"#{HOMEBREW_PREFIX}/lib:/usr/lib\"",
      "-DLIBEVENT_LIB=#{Formula['libeventfb'].opt_prefix}/lib/libevent.dylib",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula['libeventfb'].opt_prefix}/include",
      "-DICU_INCLUDE_DIR=#{Formula['icu4c'].opt_prefix}/include",
      "-DICU_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicuuc.dylib",
      "-DICU_I18N_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicui18n.dylib",
      "-DICU_DATA_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicudata.dylib",
      "-DREADLINE_INCLUDE_DIR=#{Formula['readline'].opt_prefix}/include",
      "-DREADLINE_LIBRARY=#{Formula['readline'].opt_prefix}/lib/libreadline.dylib",
      "-DNCURSES_LIBRARY=#{Formula['ncurses'].opt_prefix}/lib/libncurses.dylib",
      "-DCURL_INCLUDE_DIR=#{Formula['curl'].opt_prefix}/include",
      "-DCURL_LIBRARY=#{Formula['curl'].opt_prefix}/lib/libcurl.dylib",
      "-DBOOST_INCLUDEDIR=#{Formula['boostfb'].opt_prefix}/include",
      "-DBOOST_LIBRARYDIR=#{Formula['boostfb'].opt_prefix}/lib",
      "-DBoost_USE_STATIC_LIBS=ON",
      "-DJEMALLOC_INCLUDE_DIR=#{Formula['jemallocfb'].opt_prefix}/include",
      "-DJEMALLOC_LIB=#{Formula['jemallocfb'].opt_prefix}/lib/libjemalloc.dylib",
      "-DLIBINTL_LIBRARIES=#{Formula['gettext'].opt_prefix}/lib/libintl.dylib",
      "-DLIBINTL_INCLUDE_DIR=#{Formula['gettext'].opt_prefix}/include",
      "-DLIBDWARF_LIBRARIES=#{Formula['libdwarf'].opt_prefix}/lib/libdwarf.3.dylib",
      "-DDWARF_INCLUDE_DIR=#{Formula['libdwarf'].opt_prefix}/include",
      "-DLIBELF_INCLUDE_DIRS=#{Formula['libelf'].opt_prefix}/include/libelf",
      "-DCMAKE_INCLUDE_PATH=#{Formula['binutilsfb'].opt_prefix}/include",
      "-DFBD_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/libbfd.a",
      "-DBINUTIL_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/libbfd.a",
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
      "-DTEST_TBB_INCLUDE_DIR=#{Formula['tbb'].opt_prefix}/include",
      "-DFREETYPE_INCLUDE_DIRS=#{Formula['freetype'].opt_prefix}/include/freetype2",
      "-DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula['imagemagick'].opt_prefix}/include/ImageMagick-6",
      "-DLIBMAGICKWAND_LIBRARIES=#{Formula['imagemagick'].opt_prefix}/lib/libMagickWand-6.Q16.dylib",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    ]

    if build.with? 'mariadb'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mariadb'].opt_prefix}/include/mysql"
    elsif build.with? 'percona-server'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['percona-server'].opt_prefix}/include/mysql"
    elsif build.without? 'system-mysql'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mysql'].opt_prefix}/include/mysql"
    end

    src = prefix + "src"
    src.install Dir['*']

    ENV['HPHP_HOME'] = src

    cd src do
      if build.stable?
        system "rm -rf hphp/submodules/folly"
        system "ln -s #{Formula['folly'].opt_prefix} hphp/submodules/folly"
      end

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

      The php.ini file can be found in:
          #{etc}/hhvm/php.ini
    EOS
  end

  stable do
    patch do
      url "https://github.com/facebook/hhvm/pull/2089.diff"
      sha1 "2e4b5db532f0da7e5bb6e536c27d8866ea519603"
    end

    patch do
      url "https://github.com/facebook/hhvm/pull/2147.diff"
      sha1 "4bea16fc99ccd6f49431a3c82a99c82ce5c4bba0"
    end
  end

  def patches
    DATA
  end
end

__END__
diff --git a/hphp/runtime/base/program-functions.cpp b/hphp/runtime/base/program-functions.cpp
index ed71df2..90288ab 100644
--- a/hphp/runtime/base/program-functions.cpp
+++ b/hphp/runtime/base/program-functions.cpp
@@ -1144,7 +1144,7 @@ static int execute_program_impl(int argc, char** argv) {
       return -1;
     }
     if (po.config.empty()) {
-      auto default_config_file = "/etc/hhvm/php.ini";
+      auto default_config_file = "/usr/local/etc/hhvm/php.ini";
       if (access(default_config_file, R_OK) != -1) {
         Logger::Verbose("Using default config file: %s", default_config_file);
         po.config.push_back(default_config_file);
diff --git a/hphp/runtime/ext/gd/libgd/gdft.cpp b/hphp/runtime/ext/gd/libgd/gdft.cpp
index e2a511b..c1a63be 100644
--- a/hphp/runtime/ext/gd/libgd/gdft.cpp
+++ b/hphp/runtime/ext/gd/libgd/gdft.cpp
@@ -61,7 +61,7 @@
 #else

 #include "gdcache.h"
-#include <freetype/config/ftheader.h>
+#include <ft2build.h>
 #include FT_FREETYPE_H
 #include FT_GLYPH_H

diff --git a/CMake/HPHPFindLibs.cmake b/CMake/HPHPFindLibs.cmake
index 2a1905c..429514d 100644
--- a/CMake/HPHPFindLibs.cmake
+++ b/CMake/HPHPFindLibs.cmake
@@ -27,6 +27,10 @@ if (LIBDL_INCLUDE_DIRS)
  endif()
 endif()

+foreach(path ${CMAKE_INCLUDE_PATH})
+  include_directories(${path})
+endforeach()
+
 # boost checks
 find_package(Boost 1.49.0 COMPONENTS system program_options filesystem regex REQUIRED)
 include_directories(${Boost_INCLUDE_DIRS})
