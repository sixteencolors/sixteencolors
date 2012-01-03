#!/usr/bin/env perl

use inc::Module::Install;

name 'SixteenColors';
all_from 'lib/SixteenColors.pm';

requires 'Archive::Zip';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Credential::OpenID';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Model::XML::Feed' => '0.04'; # does not die on failed parsing
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode';
requires 'CatalystX::RoleApplicator';
requires 'Catalyst::Runtime' => '5.9';
requires 'Catalyst::View::JSON';
requires 'Catalyst::View::TT';
requires 'Class::Data::Accessor' => '0.04004';
requires 'Config::General';
requires 'Data::Dump';
requires 'DateTime';
requires 'DBIx::Class';
requires 'DBIx::Class::ResultSet::Data::Pageset';
requires 'DBIx::Class::Schema::Journal';
requires 'DBIx::Class::TimeStamp';
requires 'Directory::Scratch';
requires 'Encode';
requires 'File::Basename';
requires 'File::Copy';
requires 'HTML::FormFu' => '0.09';
requires 'HTML::FormFu::Model::DBIC';
requires 'Image::TextMode' => '0.12';
requires 'Image::TextMode::Reader::ANSI::XS';
requires 'parent';
requires 'Text::Markdown';
requires 'Try::Tiny';
requires 'XML::Atom::SimpleFeed';
requires 'GD';

# API Dependencies
# requires 'Net::HTTP::Spore'; # For SixteenColors::Client
# requires 'JSON::XS';
# requires 'Catalyst::Controller::REST';

requires_external_bin 'unzip'; # for zip files not supported by Archive::Zip
requires_external_bin 'rar'; # easiest way to handle .rar files

#catalyst; I commented this out because it was breaking when declared.

install_script glob('script/*.pl');
auto_install;
WriteAll;
