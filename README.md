# Homebrew-HHVM

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

Install the last stable version (2.4.0)

```sh
brew install hhvm
```

or the current master

```sh
brew install hhvm --HEAD
```

HHVM requires MySQL to compile, by default will use `mysql` formula, but 
you can use `--with-mariadb` or `--with-percona-server` to compile with other
mysql alternatives.

License
-------

MIT, see [LICENSE](LICENSE)