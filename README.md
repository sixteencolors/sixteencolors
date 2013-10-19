# Sixteen Colors

This repository hosts the code powering the [Sixteen Colors](http://sixteencolors.net/) ANSI/ASCII Art Archive.

## Installation

### Clone the repository

	git clone https://github.com/sixteencolors/sixteencolors.git

### Install required libraries and dependencies 

Sixteen Colors requires the following dependencies to be installed : 

	Module::Install
	libgd 2.0.28 or higher
	Expat XML Parser
	GMP (The GNU Multiple Precision Arithmetic Library)
	Libxml2
	zlib
	MySQL

Installing the required packages on Debian / Ubuntu :

	apt-get install build-essential libmodule-package-perl libgd-gd2-perl libexpat1-dev libgmp-dev libxml2-dev zlib1g-dev mysql-server

### Installing Perl modules

Run the following command to install all required CPAN modules automatically.

	perl Makefile.PL ; make

### Deploying databases

1) Edit `sixteencolors.conf` and `lib/SixteenColors/Schema.pl` to specify MySQL username and password.

2) Create the following databases : `sixteencolors` and `sixteencolors_audit`.

3) Deploy database schemas :

	etc/deploy_schema.pl
	etc/deploy_audit_db.pl        

##  Starting the server

The development server can be started by invoking the following script :

	script/sixteencolors_server.pl

## Indexing Artpacks

In order to add packs to the archive, use the `index_packs.pl` script.

Example :

	etc/index_packs.pl 2000 /path/to/artpacks/2000/*.*

Alternatively :

	etc/index_packs.pl /path/to/artpacks/

## Bug reports

If you find any bug, please report them using GitHub [issue tracker](http://github.com/sixteencolors/sixteencolors/issues), thank you. 

## License

This is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

## Contact

Sixteen Colors ANSI/ASCII Art Archive : http://sixteencolors.net/

Artpacks archive repository : https://github.com/sixteencolors/sixteencolors-archive

Twitter : [@sixteencolors](https://twitter.com/sixteencolors)
