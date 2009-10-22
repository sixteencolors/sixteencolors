#!/usr/bin/env perl

use inc::Module::Install;

name 'SixteenColors';
all_from 'lib/SixteenColors.pm';

requires 'Catalyst::Runtime' => '5.80013';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General';

requires 'Catalyst::View::TT';
requires 'DBIx::Class';
requires 'Catalyst::Model::DBIC::Schema';
requires 'JSON::XS';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
