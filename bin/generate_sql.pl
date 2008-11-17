#!/usr/bin/perl
use strict;
use warnings;
use lib qw! ../lib !;
use DB;

my $foo = DB->connect('dbi:SQLite:../data/sqlite.db');
$foo->create_ddl_dir(['SQLite'],
                       '0.1',
                       '../data/'
                       );
