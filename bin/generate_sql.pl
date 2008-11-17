#!/usr/bin/perl
use strict;
use warnings;
use lib qw! ../lib !;
use App::SimpleAjaxDemo::DB;

my $foo = App::SimpleAjaxDemo::DB->connect('dbi:SQLite:../data/sqlite.db');
$foo->create_ddl_dir(['SQLite'],
                       '0.1',
                       '../data/'
                       );
