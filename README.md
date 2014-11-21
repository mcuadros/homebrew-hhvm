# Homebrew-HHVM

A repository with all formulas related to install [HHVM](https://github.com/facebook/hhvm).

Supported OSX
------------
* 10.10 Yosemite
* 10.9 Mavericks
* 10.8 Mountain Lion

Requirements
------------

* Homebrew

Installation
------------

And now tap this repository:

```sh
brew tap mcuadros/homebrew-hhvm
```

Usage
-----

Install the last stable version (3.4.0)

```sh
brew install hhvm
```

or the current branch

```sh
brew install hhvm --devel
```

or the current master

```sh
brew install hhvm --HEAD
```

HHVM requires MySQL to compile, by default will use `mysql` formula.

If mysql is already installed, you can use `--with-system-mysql`.

But you can also use `--with-mariadb` or `--with-percona-server` to compile alternative versions of mysql.

Known Problems
-----

* HHVM no longer supports the built-in webserver as of 3.0.0.  
  Please use your own webserver (nginx or apache) talking to HHVM over [fastcgi](https://github.com/facebook/hhvm/wiki/FastCGI).

* Recompilation of libraries using `gcc` can break most of the other things from the Homebrew which depend on `boost` `gflags` `glog`

Uninstall tap
------------

```sh
brew untap mcuadros/homebrew-hhvm
brew cleanup -s --force
brew prune
```

For full reference, please see the issue [#28](https://github.com/mcuadros/homebrew-hhvm/issues/28).

License
-------

MIT, see [LICENSE](LICENSE)
