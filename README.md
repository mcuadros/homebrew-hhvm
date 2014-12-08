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

* Building using clang broken, need to use flag `--with-gcc` and rebuild packages using gcc (issues: [#122](https://github.com/mcuadros/homebrew-hhvm/issues/122), [#137](https://github.com/mcuadros/homebrew-hhvm/issues/137))
* If you are getting errors like `Undefined symbols for architecture x86_64:` execute:  
  `brew reinstall --build-from-source --cc=gcc-4.9 boost gflags glog`  

  *Warning: Recompilation of libraries using `gcc` can break most of the other things from the Homebrew which depend on `boost` `gflags` `glog`*
* HHVM no longer supports the built-in webserver as of 3.0.0.  
  Please use your own webserver (nginx or apache) talking to HHVM over [fastcgi](https://github.com/facebook/hhvm/wiki/FastCGI).
* If you have XQuartz (X11) installed, you have to temporarily remove a symbolic link at '/usr/X11R6' in order to successfully install HHVM.
  You can use the following command: `sudo rm /usr/X11R6`
  After the install, you could return it with the command: `sudo ln -s /opt/X11 /usr/X11R6`
  For full reference, please see the issue [#28](https://github.com/mcuadros/homebrew-hhvm/issues/28).

Uninstall tap
------------

```sh
brew untap mcuadros/homebrew-hhvm
brew cleanup -s --force
brew prune
```

License
-------

MIT, see [LICENSE](LICENSE)
