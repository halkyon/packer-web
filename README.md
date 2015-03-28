# Packer PHP vagrant box builder

## Introduction

Using [packer.io](https://packer.io), build and provision a [Vagrant](https://www.vagrantup.com/) box capable of running a LAMP stack application.

Currently this puts a copy of [SilverStripe](http://www.silverstripe.org) into the `/var/www` webroot with some fake data for testing.

## Usage

A number of builders are included in `build.json` for various versions of PHP, as well as HHVM.
To build a PHP 5.6 box, for example, specify that builder name in the `only` argument:

	packer build -only="virtualbox-web-debian8-php56" build.json

You can also build multiple boxes at once, either by specifying specific builder names in the `only`
argument:

	packer build -only="virtualbox-web-debian8-php56,virtualbox-web-debian8-hhvm" build.json

or leaving out the `only` argument, which builds everything:

	packer build build.json
