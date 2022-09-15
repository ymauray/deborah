* bump the version number in pubspec.yaml (ex: version: 0.1.0-alpha.2)
* push to github
* create and push version tag (ex: v0.1.0-alpha.2)
* build the tarball (`make bin`)
* upload to launchpaf (`make ppa`)
* wait for the `.deb`s to build
* download the `.deb`s
* create a new release on GitHub

Legacy notes, for reference :

* `cd /mnt/data/dev/debianpackages/deborah.deb/deborah`
* `head debian/changelog` to check the latest changelog
* `dch -v a.b.c "New changelog message"`
* `nano debian/changelog` to change the release (ex: 0.1.0-alpha.2~focal1.0 focal)
* `uscan --noconf --force-download --rename --download-current-version --destdir=.. --verbose` to download the tarball properly
* `dpkg-buildpackage -d -S -sa` to build the changes file (the name of the key to use is in ~/.config/dpkg/buildpackage.conf)
* `nano debian/changelog` to change the release (ex: 0.1.0-alpha.2~impish1.0 impish)
* `dpkg-buildpackage -d -S -sa`
* `nano debian/changelog` to change the release (ex: 0.1.0-alpha.2~jammy.0 jammy)
* `dpkg-buildpackage -d -S -sa`
* `dput ppa:yannick-mauray/deborah ../deborah_0.1.0-alpha.2~focal1.0_source.changes`
* `dput ppa:yannick-mauray/deborah ../deborah_0.1.0-alpha.2~impish1.0_source.changes`
* `dput ppa:yannick-mauray/deborah ../deborah_0.1.0-alpha.2~jammy1.0_source.changes`
