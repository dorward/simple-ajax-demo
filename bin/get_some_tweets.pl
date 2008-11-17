#!/usr/bin/perl

use strict;
use warnings;
use Net::Twitter;
use Config::IniFiles;

my $cfg = Config::IniFiles->new( 
		-file => "../data/config.ini",
	) or die("No config.ini found");

my $twit = Net::Twitter->new(
	username => $cfg->{v}{auth}{username},
	password => $cfg->{v}{auth}{password},
);
  
my $messages = $twit->friends_timeline();

use Data::Dumper;
print Dumper $messages;