require 'formula'

class Libeventfb < Formula
  homepage 'http://libevent.org/'
  url 'https://github.com/libevent/libevent.git', :tag => 'release-1.4.14b-stable' 
  version '1.4.14b'

  keg_only 'We are just a patched version.'

  depends_on :automake
  depends_on :libtool

  def patches
    "https://raw.github.com/facebook/hiphop-php/master/hphp/third_party/libevent-1.4.14.fb-changes.diff"
  end 

  def install
    ENV.j1
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end 
end