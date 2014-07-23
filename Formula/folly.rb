require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/09a81a96ea2f9790242675f3c84013266c38d684.tar.gz'
  sha1 'a62ff00b97813a05981ae687eea07d2ce509871d'
  version 'e881a4'

  def install
    prefix.install Dir['*']
  end
end
