class HhvmMsgpack < Formula
  homepage "https://github.com/reeze/msgpack-hhvm"
  head "https://github.com/reeze/msgpack-hhvm.git", :revision => "7f76d892f99043af365c3c83bdc3487859481a40"
  url "https://github.com/reeze/msgpack-hhvm/archive/7f76d892f99043af365c3c83bdc3487859481a40.tar.gz"
  version "7f76d8"

  depends_on "hhvm"
  depends_on "cmake" => :build

  def install
    ENV['HPHP_HOME'] = Formula['hhvm'].opt_prefix + "/src/"

    system Formula['hhvm'].bin + "hphpize"

    system "cmake", "."
    system "make", "install"
  end
end
