require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/a247c8d3ff52e65c097170614ecb0639edebc569.tar.gz'
  sha1 'ee903df8909817e2b2966ddef786b120d99bc170'
  version 'a247c8'

  def install
    prefix.install Dir['*']
  end
end
