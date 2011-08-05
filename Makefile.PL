#!/usr/bin/env perl

use inc::Module::Install;

name 'SixteenColors';
all_from 'lib/SixteenColors.pm';

requires 'Archive::Zip';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Credential::OpenID';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Model::XML::Feed' => '0.04'; # does not die on failed parsing
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::FillInForm';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode';
requires 'Catalyst::Runtime' => '5.80013';
requires 'Catalyst::View::JSON';
requires 'Catalyst::View::TT';
requires 'Class::Data::Accessor' => '0.04004';
requires 'Config::General';
requires 'Data::Dump';
requires 'DateTime';
requires 'DBIx::Class';
requires 'DBIx::Class::ResultSet::Data::Pageset';
requires 'DBIx::Class::TimeStamp';
requires 'Directory::Scratch';
requires 'Encode';
requires 'File::Basename';
requires 'File::Copy';
requires 'Image::TextMode' => '0.12';
requires 'Image::TextMode::Reader::ANSI::XS';
requires 'JSON::XS';
requires 'parent';
requires 'Text::Markdown';
requires 'Try::Tiny';
requires 'XML::Atom::SimpleFeed';

requires_external_bin 'unzip'; # for zip files not supported by Archive::Zip
requires_external_bin 'rar'; # easiest way to handle .rar files

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
