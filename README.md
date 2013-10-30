# Homebrew-PHP

A repository with all formulas related to install [HHVM](http://www.hiphop-php.com/blog/), based on [Building and installing HHVM on OSX 10.8](https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-OSX-10.8) by [Daniel Sloof](https://github.com/danslo)


Requirements
------------

* Homebrew
* Mountain Lion and Mavericks (requires [use this workarround](https://github.com/mxcl/homebrew/issues/23687#issuecomment-27339429))
* homebrew/dupes

Installation
------------

Tap additional repositories:

```sh
brew tap homebrew/dupes
brew tap homebrew/versions
```

And now tap this repository:

```sh
brew tap mcuadros/homebrew-hhvm
```

Usage
-----

```sh
brew install hhvm
```



License
-------

MIT, see [LICENSE](LICENSE)
