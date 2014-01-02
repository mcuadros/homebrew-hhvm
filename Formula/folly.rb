require 'formula'

class Folly < Formula
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/8e8b5e75d573305b7a9c34f4a405be5df0f17738.zip'
  sha1 '48a7dad3ced18670d796870b382f173093748efe'

  def install
    prefix.install Dir['*']
  end 
end
