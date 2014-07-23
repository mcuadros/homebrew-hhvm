require 'formula'

class HhvmThirdParty < Formula
  homepage 'https://github.com/hhvm/hhvm-third-party'
  url 'https://github.com/hhvm/hhvm-third-party/archive/b9463da0d286a6f070803bdaa01df47309d508b7.tar.gz'
  sha1 '4105be9132230b7cfabc613ca9eff9c27ff259e7'
  version 'b9463d'

  depends_on 'folly'

  def install
    prefix.install Dir['*']

    cd prefix do
        system "ln -s #{Formula['folly'].opt_prefix}/folly folly/src"
    end
  end
end
