require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/a247c8d3ff52e65c097170614ecb0639edebc569.zip'
  sha1 '80e099d6083d7aa68143d172e4217a31e7767f30'
  version 'a247c8'

  def install
    prefix.install Dir['*']
  end
end
