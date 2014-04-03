require 'formula'

class UniversalPython < Requirement
  satisfy(:build_env => false) { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python is not a universal build

    Boost compiles against the Python it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class Boostfb < Formula
  homepage 'http://www.boost.org'
  url 'https://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2'
  sha1 'cef9a0cc7084b1d639e06cd3bc34e4251524c840'

  depends_on 'gcc48'

  env :userpaths

  keg_only 'We dont want to interfere with normal boost.'

  def install
    # Force gcc 4.7 due to the following bug:
    # http://stackoverflow.com/questions/12470118/malloc-error-using-boost-with-osx
    ENV['CC'] = "#{Formula['gcc48'].opt_prefix}/bin/gcc-4.8"
    ENV['LD'] = "#{Formula['gcc48'].opt_prefix}/bin/gcc-4.8"
    ENV['CXX'] = "#{Formula['gcc48'].opt_prefix}/bin/g++-4.8"

    # Adjust the name the libs are installed under to include the path to the
    # Homebrew lib directory so executables will work when installed to a
    # non-/usr/local location.
    #
    # otool -L `which mkvmerge`
    # /usr/local/bin/mkvmerge:
    #   libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #
    # becomes:
    #
    # /usr/local/bin/mkvmerge:
    #   /usr/local/lib/libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/local/lib/libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/local/lib/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{HOMEBREW_PREFIX}/lib/"

    # boost will try to use cc, even if we'd rather it use, say, gcc-4.2
    inreplace 'tools/build/v2/engine/build.sh', 'BOOST_JAM_CC=cc', "BOOST_JAM_CC=#{ENV.cc}"
    inreplace 'tools/build/v2/engine/build.jam', 'toolset darwin cc', "toolset darwin #{ENV.cc}"

    # Force boost to compile using the appropriate GCC version
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.with? 'mpi'
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    bargs << "--with-toolset=clang" if build.with? "c++11"

    if build.with? 'icu'
      icu4c_prefix = Formula['icu4c'].opt_prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    else
      bargs << '--without-icu'
    end

    # The context library is implemented as x86_64 ASM, so it
    # won't build on PPC or 32-bit builds
    # see https://github.com/mxcl/homebrew/issues/17646
    bargs << "--without-libraries=context" if Hardware::CPU.type == :ppc || Hardware::CPU.bits == 32 || build.universal?

    boost_layout = (build.include? "use-system-layout") ? "system" : "tagged"
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=#{boost_layout}",
            "--user-config=user-config.jam",
            "threading=multi",
            "install"]

    if MacOS.version >= :lion and build.with? 'c++11'
      args << "toolset=clang" << "cxxflags=-std=c++11"
      args << "cxxflags=-stdlib=libc++" << "cxxflags=-fPIC"
      args << "cxxflags=-arch x86_64" if MacOS.prefer_64_bit? or build.universal?
      args << "cxxflags=-arch i386" if !MacOS.prefer_64_bit? or build.universal?
      args << "linkflags=-stdlib=libc++"
      args << "linkflags=-headerpad_max_install_names"
      args << "linkflags=-arch x86_64" if MacOS.prefer_64_bit? or build.universal?
      args << "linkflags=-arch i386" if !MacOS.prefer_64_bit? or build.universal?
    end

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?
    args << "--without-python" if build.without? 'python'

    system "./bootstrap.sh", *bargs
    system "./b2", *args
  end
end
