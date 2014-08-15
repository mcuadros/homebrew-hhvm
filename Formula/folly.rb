require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/6e46d468cf2876dd59c7a4dddcb4e37abf070b7a.tar.gz'
  sha1 'ca1d03214085a02783d06c5ab6886e5a13e451f0'
  version '6e46d4'

  def install
    prefix.install Dir['*']
  end
end
