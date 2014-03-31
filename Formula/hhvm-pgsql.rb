require "formula"

class HhvmPgsql < Formula
  homepage "https://github.com/PocketRent/hhvm-pgsql"
  head "https://github.com/PocketRent/hhvm-pgsql.git", :revision => "f86c2d2d2a033fe1bee76d344955d6e8befdb10d"
  url "https://github.com/PocketRent/hhvm-pgsql/archive/f86c2d2d2a033fe1bee76d344955d6e8befdb10d.tar.gz"
  version "f86c2d"

  depends_on "hhvm"
  depends_on "cmake" => :build
  depends_on "postgresql"

  def install
    ENV['HPHP_HOME'] = Formula['hhvm'].opt_prefix + "/src/"

    system Formula['hhvm'].bin + "hphpize"

    system "cmake", "."
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
