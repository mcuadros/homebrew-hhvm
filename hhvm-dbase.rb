class HhvmDbase < Formula
  homepage "https://github.com/skyfms/hhvm-ext_dbase"
  head "https://github.com/skyfms/hhvm-ext_dbase.git", :revision => "b36853ffb9ad446f1a7412a37d87ee1edc6150ad"
  url "https://github.com/skyfms/hhvm-ext_dbase/archive/b36853ffb9ad446f1a7412a37d87ee1edc6150ad.tar.gz"
  version "b36853"

  depends_on "hhvm"
  depends_on "cmake" => :build

  def install
    ENV['HPHP_HOME'] = Formula['hhvm'].opt_prefix + "/src/"

    system Formula['hhvm'].bin + "hphpize"

    system "cmake", "."
    system "make", "install"
  end
end
