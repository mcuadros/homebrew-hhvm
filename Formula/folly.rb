require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/d9c79af86a4dc0576d8df453804d3354347c07dc.tar.gz'
  sha1 'e881a4cb50ac9731c3d92394ae2f940a69f57259'
  version 'd9c79a'

  def install
    prefix.install Dir['*']
  end
end
