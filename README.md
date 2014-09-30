# Homebrew-HHVM

A repository with all formulas related to install [HHVM](https://github.com/facebook/hhvm).
Based on [Building and installing HHVM on OSX 10.8](https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-OSX-10.8) by [Daniel Sloof](https://github.com/danslo)

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

Tap additional repositories:

```sh
brew tap homebrew/dupes
```

And now tap this repository:

```sh
brew tap mcuadros/homebrew-hhvm
```

Usage
-----

Install the last stable version (3.3.0)

```sh
brew install hhvm
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

HHVM no longer supports the built-in webserver as of 3.0.0.

    Please use your own webserver (nginx or apache)
    talking to HHVM over [fastcgi](https://github.com/facebook/hhvm/wiki/FastCGI).

Extension, **mysqli broken**. This extension was broken in 3.0.0 and is fixed in 3.0.1.

    Make sure to upgrade if you were having remove the Eval.CheckReturnTypeHints workaround if you were using it.

Uninstall tap
------------

```sh
rm -rf /usr/local/Library/Taps/mcuadros-hhvm
brew cleanup -s --force
brew prune
```

For full reference, please see the issue [#28](https://github.com/mcuadros/homebrew-hhvm/issues/28).

License
-------

MIT, see [LICENSE](LICENSE)
