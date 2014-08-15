require 'formula'

class HhvmThirdParty < Formula
  homepage 'https://github.com/hhvm/hhvm-third-party'
  url 'https://github.com/hhvm/hhvm-third-party/archive/f391aa6bca9b9ed000ba54864bcb87fabf52e56d.tar.gz'
  sha1 '876c7b10a995bb8154351d0a4b2e9dafa99aa515'
  version 'f391aa'

  depends_on 'folly'

  def install
    prefix.install Dir['*']

    cd prefix do
        system "ln -s #{Formula['folly'].opt_prefix}/folly folly/src"
    end
  end
end
