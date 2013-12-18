# Homebrew-PHP

A repository with all formulas related to install [HHVM](http://www.hiphop-php.com/blog/), based on [Building and installing HHVM on OSX 10.8](https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-OSX-10.8) by [Daniel Sloof](https://github.com/danslo)

Supported OSX
------------
* Mountain Lion
* Mavericks

Requirements
------------

* Homebrew
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

Install the last stable version (2.3.1)

```sh
brew install hhvm
```

or the current master

```sh
brew install hhvm --HEAD
```

License
-------

MIT, see [LICENSE](LICENSE)
