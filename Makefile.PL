#!/usr/bin/env perl

use inc::Module::Install;

name 'SixteenColors';
all_from 'lib/SixteenColors.pm';

requires 'Catalyst::Runtime' => '5.80013';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Credential::OpenID';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::FillInForm';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::View::TT';
requires 'parent';
requires 'Config::General';

requires 'DBIx::Class';
requires 'JSON::XS';
requires 'Image::TextMode';
requires 'Try::Tiny';
requires 'Archive::Zip';
requires 'Directory::Scratch';
requires 'Encode';
requires 'File::Basename';
requires 'File::Copy';
requires 'Data::Dump';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
