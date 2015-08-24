# Homebrew-HHVM

[![Join the chat at https://gitter.im/mcuadros/homebrew-hhvm](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mcuadros/homebrew-hhvm?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Repository with all the formulas to install [HHVM](https://github.com/facebook/hhvm)

Supported OSX
------------
* 10.11 El Capitan
* 10.10 Yosemite
* 10.9 Mavericks
* 10.8 Mountain Lion

Requirements
------------

* [Homebrew](http://brew.sh)

Installation
------------

And now tap this repository:

    brew tap mcuadros/homebrew-hhvm

Usage
-----

**Note**: For a list of available configuration options run:

    brew options hhvm
    brew info hhvm
    brew uses hhvm

##### Install the last stable release 3.9.0:

    brew install hhvm

HHVM requires MySQL to compile, by default will use mysql formula.  
If mysql is already installed, you can use `--with-system-mysql`.

###### But you can also use to compile alternative versions of mysql:

- MariaDB `--with-mariadb`
- Percona Server `--with-percona-server`

##### Install the devel branch:

    brew install hhvm --devel


##### Install the current master:

    brew install hhvm --HEAD

Known Problems
-----

* HHVM no longer supports the built-in webserver as of 3.0.0.
  - Please use [FastCGI](https://github.com/facebook/hhvm/wiki/FastCGI) own webserver (nginx or apache).
  - [HHVM builtin Webserver on Go](https://github.com/beberlei/hhvm-serve)

* If you have XQuartz (X11) installed, you will have to temporarily remove a symbolic link to/usr/X11R6` in order to successfully install HHVM.
  - You can use the following command: `sudo rm /usr/X11R6`
  - After the install, you could return it with the command: `sudo ln -s /opt/X11 /usr/X11R6`
  - For full reference, please see the issue #28.

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
