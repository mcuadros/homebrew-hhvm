require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/19e5f7ed316251e9c559c42322b97f9a5e9f47d8.tar.gz'
  sha1 'cf640341d0b5833b507be4ca6413ed40289f1d2e'

  def install
    prefix.install Dir['*']
  end
end