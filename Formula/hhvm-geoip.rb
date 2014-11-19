require "formula"

class HhvmGeoip < Formula
  homepage "https://github.com/vipsoft/hhvm-ext-geoip"
  head "https://github.com/vipsoft/hhvm-ext-geoip.git", :revision => "0a8e4f36755f76e730e7e784aa431885d2fd2eed"
  url "https://github.com/vipsoft/hhvm-ext-geoip/archive/0a8e4f36755f76e730e7e784aa431885d2fd2eed.tar.gz"
  version "0a8e4f"

  depends_on "hhvm"
  depends_on "geoip"
  depends_on "cmake" => :build

  def install
    ENV['HPHP_HOME'] = Formula['hhvm'].opt_prefix + "/src/"

    system Formula['hhvm'].bin + "hphpize"

    system "cmake", "."
    system "make", "install"
  end
end
