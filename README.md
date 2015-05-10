# Packer PHP vagrant box builder

## Introduction

Using [packer.io](https://packer.io), build and provision a [Vagrant](https://www.vagrantup.com/) box capable of running a LAMP stack application.
This also puts a copy of [SilverStripe](http://www.silverstripe.org) into the `/var/www` webroot on each box with some fake pages for testing.

## Boxes

### virtualbox-web-squeeze-php53

 * Debian 6 "squeeze"
 * MariaDB 10
 * Apache 2.2.16
 * Latest PHP 5.3 (dotdeb) w/ extensions: apc, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy

### virtualbox-web-wheezy-php54

 * Debian 7 "wheezy"
 * MariaDB 10
 * Apache 2.2.22
 * Latest PHP 5.4 (dotdeb) w/ extensions: apcu, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy, zendopcache

### virtualbox-web-wheezy-php55

 * Debian 7 "wheezy"
 * MariaDB 10
 * Apache 2.2.22
 * Latest PHP 5.5 (dotdeb) w/ extensions: apcu, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy

### virtualbox-web-jessie-php56

 * Debian 8 "jessie"
 * MariaDB 10
 * Apache 2.4.10
 * PHP 5.6.7 w/ extensions: apcu, curl, gd, imagick, ldap, mcrypt, mysqlnd, sqlite, tidy

### virtualbox-web-jessie-hhvm

 * Debian 8 "jessie"
 * MariaDB 10
 * nginx 1.6.2
 * HHVM 3.6 LTS

## Usage

### Building

Build a specific box:

	packer build -only="virtualbox-web-wheezy-php54" build.json

Build multiple boxes at once:

	packer build -only="virtualbox-web-jessie-php56,virtualbox-web-jessie-hhvm" build.json

Build everything by leaving out the `only` argument:

	packer build build.json

### Benchmarking

A `test.sh` script is provided which, when run, will go through each `vagrant.box` output artifact, start
the box and run some `siege` benchmarks on each box. Each box is allocated 2 virtual CPU cores and 2GB of RAM.

This is useful for testing raw application performance on different versions of PHP.

The results (in CSV format) will be placed into a `test-results/` directory.
