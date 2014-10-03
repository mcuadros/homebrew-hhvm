require 'formula'

class Hhvm < Formula
  homepage 'http://hhvm.com/'

  head do
    url 'https://github.com/facebook/hhvm.git'
    resource 'third-party' do
      url 'https://github.com/hhvm/hhvm-third-party.git'
    end
    #resource 'folly' do
    #  url 'https://github.com/facebook/folly.git'
    #end
    #resource 'thrift' do
    #  url 'https://github.com/facebook/fbthrift.git'
    #end
  end

  stable do
    url 'https://github.com/facebook/hhvm/archive/HHVM-3.3.0.tar.gz'
    sha1 'ba911fbc9d06e418ec18e68f3736d69f79075ee5'
    version '3.3.0'
    resource 'third-party' do
      url 'https://github.com/hhvm/hhvm-third-party/archive/fdef620998ce599280904416263968b59ef21794.tar.gz'
      sha1 '10066e1faca7f3ceba8a5ad9c2d18b0670dc4fc8'
    end
    resource 'folly' do
      url 'https://github.com/facebook/folly/archive/6e46d468cf2876dd59c7a4dddcb4e37abf070b7a.tar.gz'
      sha1 'ca1d03214085a02783d06c5ab6886e5a13e451f0'
    end
  end

  devel do
    url 'https://github.com/facebook/hhvm/archive/3543a709f64b6ae1848e63628ec058c4af113254.tar.gz'
    sha1 '4c21ad80c229555adb72b176c2cdaf4ed818cad1'
    version '3.3.1a'
    resource 'third-party' do
      url 'https://github.com/hhvm/hhvm-third-party/archive/12acbba4c05d8cbe97fe2a94a4a833c0c80e8182.tar.gz'
      sha1 '04ac53659b8ba1ee3d5e0681a71d779a276f6f06'
    end
    resource 'folly' do
      url 'https://github.com/facebook/folly/archive/4ecd8cdd6396f2f4cbfc17c1063537884e3cd6b9.tar.gz'
      sha1 'd8b0dc49ff7854da83a900276718e3b31176c468'
    end
    resource 'thrift' do
      url 'https://github.com/facebook/fbthrift/archive/378e954ac82a00ba056e6fccd5e1fa3e76803cc8.tar.gz'
      sha1 '1a26eb22b0e36fe1823343c32ec79544cf1556d4'
    end
  end

  option 'with-cotire', 'Speed up the build by precompiling headers.'
  option 'with-debug', 'Enable debug build (default Release).'
  option 'with-gcc', 'Build with gcc-4.9 compiler.'
  option 'with-mariadb', 'Use mariadb as mysql package.'
  option 'with-minsizerel', 'Enable minimal size release build.'
  option 'with-percona-server', 'Use percona-server as mysql package.'
  option 'with-release-debug', 'Enable release with debug build.'
  option 'with-system-mysql', 'Try to use the mysql package installed on your system.'

  depends_on 'cmake' => :build
  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gcc' => :optional

  # Standard packages
  depends_on 'boost'
  depends_on 'binutilsfb'
  depends_on 'curl'
  depends_on 'freetype'
  depends_on 'gd'
  depends_on 'gettext'
  depends_on 'glog'
  depends_on 'icu4c'
  depends_on 'imagemagick'
  depends_on 'imap-uw'
  depends_on 'jemallocfb'
  depends_on 'jpeg'
  depends_on 'libdwarf'
  depends_on 'libelf'
  depends_on 'libevent'
  depends_on 'libmemcached'
  depends_on 'libpng'
  depends_on 'libssh2'
  depends_on 'libxslt'
  depends_on 'mcrypt'
  depends_on 'objective-caml'
  depends_on 'oniguruma'
  depends_on 'pcre'
  depends_on 're2c'
  depends_on 'readline'
  depends_on 'sqlite'
  depends_on 'tbb'
  depends_on 'unixodbc'

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
      "-DBOOST_INCLUDEDIR=#{Formula['boost'].opt_prefix}/include",
      "-DBOOST_LIBRARYDIR=#{Formula['boost'].opt_prefix}/lib",
      "-DCCLIENT_INCLUDE_PATH=#{Formula['imap-uw'].opt_prefix}/include/imap",
      "-DCMAKE_INCLUDE_PATH=\"#{HOMEBREW_PREFIX}/include:/usr/include\"",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DCMAKE_LIBRARY_PATH=\"#{HOMEBREW_PREFIX}/lib:/usr/lib\"",
      "-DCURL_INCLUDE_DIR=#{Formula['curl'].opt_prefix}/include",
      "-DCURL_LIBRARY=#{Formula['curl'].opt_prefix}/lib/libcurl.dylib",
      "-DFREETYPE_INCLUDE_DIRS=#{Formula['freetype'].opt_prefix}/include/freetype2",
      "-DFREETYPE_LIBRARIES=#{Formula['freetype'].opt_prefix}/lib/libfreetype.dylib",
      "-DICU_DATA_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicudata.dylib",
      "-DICU_I18N_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicui18n.dylib",
      "-DICU_INCLUDE_DIR=#{Formula['icu4c'].opt_prefix}/include",
      "-DICU_LIBRARY=#{Formula['icu4c'].opt_prefix}/lib/libicuuc.dylib",
      "-DJEMALLOC_INCLUDE_DIR=#{Formula['jemallocfb'].opt_prefix}/include",
      "-DJEMALLOC_LIB=#{Formula['jemallocfb'].opt_prefix}/lib/libjemalloc.dylib",
      "-DLIBDWARF_INCLUDE_DIRS=#{Formula['libdwarf'].opt_prefix}/include",
      "-DLIBDWARF_LIBRARIES=#{Formula['libdwarf'].opt_prefix}/lib/libdwarf.3.dylib",
      "-DLIBELF_INCLUDE_DIRS=#{Formula['libelf'].opt_prefix}/include/libelf",
      "-DLIBEVENT_INCLUDE_DIR=#{Formula['libevent'].opt_prefix}/include",
      "-DLIBEVENT_LIB=#{Formula['libevent'].opt_prefix}/lib/libevent.dylib",
      "-DLIBGLOG_INCLUDE_DIR=#{Formula['glog'].opt_prefix}/include",
      "-DLIBINTL_INCLUDE_DIR=#{Formula['gettext'].opt_prefix}/include",
      "-DLIBINTL_LIBRARIES=#{Formula['gettext'].opt_prefix}/lib/libintl.dylib",
      "-DLIBJPEG_INCLUDE_DIRS=#{Formula['jpeg'].opt_prefix}/include",
      "-DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula['imagemagick'].opt_prefix}/include/ImageMagick-6",
      "-DLIBMAGICKWAND_LIBRARIES=#{Formula['imagemagick'].opt_prefix}/lib/libMagickWand-6.Q16.dylib",
      "-DLIBMEMCACHED_INCLUDE_DIR=#{Formula['libmemcached'].opt_prefix}/include",
      "-DLIBODBC_INCLUDE_DIRS=#{Formula['unixodbc'].opt_prefix}/include",
      "-DLIBPNG_INCLUDE_DIRS=#{Formula['libpng'].opt_prefix}/include",
      "-DLIBSQLITE3_INCLUDE_DIR=#{Formula['sqlite'].opt_prefix}/include",
      "-DLIBSQLITE3_LIBRARY=#{Formula['sqlite'].opt_prefix}/lib/libsqlite3.0.dylib",
      "-DMcrypt_INCLUDE_DIR=#{Formula['mcrypt'].opt_prefix}/include",
      "-DOCAMLC_EXECUTABLE=#{Formula['objective-caml'].opt_prefix}/bin/ocamlc",
      "-DOCAMLC_OPT_EXECUTABLE=#{Formula['objective-caml'].opt_prefix}/bin/ocamlc.opt",
      "-DONIGURUMA_INCLUDE_DIR=#{Formula['oniguruma'].opt_prefix}/include",
      "-DPCRE_INCLUDE_DIR=#{Formula['pcre'].opt_prefix}/include",
      "-DREADLINE_INCLUDE_DIR=#{Formula['readline'].opt_prefix}/include",
      "-DREADLINE_LIBRARY=#{Formula['readline'].opt_prefix}/lib/libreadline.dylib",
      "-DTBB_INCLUDE_DIRS=#{Formula['tbb'].opt_prefix}/include",
      "-DTEST_TBB_INCLUDE_DIR=#{Formula['tbb'].opt_prefix}/include",
    ]

    if build.with? 'gcc'
      # Support GCC/LLVM stack-smashing protection: http://git.io/5Kzu3A
      # Preprocessor gcc performance regressions: http://git.io/4r7VCQ
      if build.devel?
        args << "-DCMAKE_C_FLAGS=-ftrack-macro-expansion=0 -fno-builtin-memcmp -pie -fPIC -fstack-protector-strong --param=ssp-buffer-size=4"
        args << "-DCMAKE_CXX_FLAGS=-ftrack-macro-expansion=0 -fno-builtin-memcmp -pie -fPIC -fstack-protector-strong --param=ssp-buffer-size=4"
      end
      args << "-DCMAKE_CXX_COMPILER=#{Formula['gcc'].opt_prefix}/bin/g++-4.9"
      args << "-DCMAKE_C_COMPILER=#{Formula['gcc'].opt_prefix}/bin/gcc-4.9"
      args << "-DCMAKE_ASM_COMPILER=#{Formula['gcc'].opt_prefix}/bin/gcc-4.9"
      args << "-DBoost_USE_STATIC_LIBS=ON"
      args << "-DBFD_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/libbfd.a"
      args << "-DCMAKE_INCLUDE_PATH=#{Formula['binutilsfb'].opt_prefix}/include"
      args << "-DLIBIBERTY_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/x86_64/libiberty.a"
    else
      args << "-DBFD_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/libbfd.a"
      args << "-DCMAKE_INCLUDE_PATH=#{Formula['binutilsfb'].opt_prefix}/include"
      args << "-DLIBIBERTY_LIB=#{Formula['binutilsfb'].opt_prefix}/lib/x86_64/libiberty.a"
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
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mariadb'].opt_prefix}/include/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['mariadb'].opt_prefix}/lib"
    elsif build.with? 'percona-server'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['percona-server'].opt_prefix}/include/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['percona-server'].opt_prefix}/lib"
    elsif build.without? 'system-mysql'
      args << "-DMYSQL_INCLUDE_DIR=#{Formula['mysql'].opt_prefix}/include/mysql"
      args << "-DMYSQL_LIB_DIR=#{Formula['mysql'].opt_prefix}/lib"
    end

    #Custome packages
    rm_rf 'third-party'
    third_party_buildpath = buildpath/'third-party'
    third_party_buildpath.install resource('third-party')
    if build.stable? or build.devel?
      rm_rf 'third-party/folly/src'
      folly_buildpath = buildpath/'third-party/folly/src'
      folly_buildpath.install resource('folly')
      if build.devel?
        rm_rf 'third-party/thrift/src'
        thrift_buildpath = buildpath/'third-party/thrift/src'
        thrift_buildpath.install resource('thrift')
      end
    end

    src = prefix + "src"
    src.install Dir['*']

    ENV['HPHP_HOME'] = src

    cd src do
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
      date.timezone = Europe/London

      ; hhvm specific
      ; example: https://gist.github.com/denji/1a2ff183a671efcabedf
      hhvm.log.level = Warning
      hhvm.log.always_log_unhandled_exceptions = true
      hhvm.log.runtime_error_reporting_level = 8191
      hhvm.mysql.typed_results = false
      hhvm.eval.jit = false
    EOS
  end

  def caveats_gcc;
    if build.with? 'gcc'
      cc_ver = 'gcc-4.9'
    end
    <<-EOS.undent

      If you are getting errors like 'Undefined symbols for architecture x86_64:' execute:
        $ brew reinstall --build-from-source --cc=#{cc_ver} boost gflags glog
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
end
