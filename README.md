# Packer PHP vagrant box builder

## Introduction

Using [packer.io](https://packer.io), build and provision a [Vagrant](https://www.vagrantup.com/) box capable of running a LAMP stack application.
This also puts a copy of [SilverStripe](http://www.silverstripe.org) into the `/var/www` webroot on each box with some fake pages for testing.

Also bundled is a `build-minimal.json` file for building boxes with only VirtualBox Guest Additions on them. Useful if you just want to start from scratch.

## Boxes

### virtualbox-web-wheezy-php54

 * Debian 7 "wheezy"
 * MariaDB 10
 * Apache 2.2
 * PHP 5.4 (dotdeb) w/ extensions: apcu, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy, zendopcache

### virtualbox-web-wheezy-php55

 * Debian 7 "wheezy"
 * MariaDB 10
 * Apache 2.2
 * PHP 5.5 (dotdeb) w/ extensions: apcu, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy

### virtualbox-web-jessie-php56

 * Debian 8 "jessie"
 * MariaDB 10
 * Apache 2.4
 * PHP 5.6 w/ extensions: apcu, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy

### virtualbox-web-jessie-hhvm

 * Debian 8 "jessie"
 * MariaDB 10
 * nginx 1.6
 * HHVM

## Usage

### Building

Build a specific box:

	packer build -only="virtualbox-web-wheezy-php54" build.json

Build multiple boxes at once:

	packer build -only="virtualbox-web-jessie-php56,virtualbox-web-jessie-hhvm" build.json

Build everything by leaving out the `only` argument:

	packer build build.json

Build minimal boxes with only VirtualBox Guest Additions installed on them:

	packer build build-minimal.json

### Benchmarking

A `test.sh` script is provided which, when run, will go through each `vagrant.box` output artifact, start
the box and run some `siege` benchmarks on each box. Each box is allocated 2 virtual CPU cores and 2GB of RAM.

This is useful for testing raw application performance on different versions of PHP.

The results (in CSV format) will be placed into a `test-results/` directory.
