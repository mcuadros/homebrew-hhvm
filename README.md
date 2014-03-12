# Homebrew-HHVM  [![Build Status](https://travis-ci.org/mcuadros/homebrew-hhvm.png?branch=master)](https://travis-ci.org/mcuadros/homebrew-hhvm)

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

Install the last stable version (2.4.2)

```sh
brew install hhvm
```

or the current master

```sh
brew install hhvm --HEAD
```

HHVM requires MySQL to compile, by default will use `mysql` formula, but 
you can use `--with-mariadb` or `--with-percona-server` to compile with other
mysql alternatives. You can use `--with-system-mysql` if mysql is already installed.

Caveats
-------

If you have XQuartz (X11) installed, you have to temporarily remove a symbolic link at '/usr/X11R6' in order to successfully install HHVM.

You can use the following command:
```sh
sudo rm /usr/X11R6
```

It's the root-owned file so your login password will be asked.

After the install, you could return it with the command:
```sh
sudo ln -s /opt/X11 /usr/X11R6
```

For full reference, please see the issue [#28](https://github.com/mcuadros/homebrew-hhvm/issues/28).

License
-------

MIT, see [LICENSE](LICENSE)
