#!/usr/bin/perl

use strict;
use warnings;
use Net::Twitter;
use Config::IniFiles;
use DateTime::Format::HTTP;

my $cfg = Config::IniFiles->new( 
		-file => "../data/config.ini",
	) or die("No config.ini found");

my $twit = Net::Twitter->new(
	username => $cfg->{v}{auth}{username},
	password => $cfg->{v}{auth}{password},
);
  
my $messages = $twit->friends_timeline();

for my $message (@$messages) {
	my $user = $message->{user}{name};
	my $text = $message->{text};
	my $time_string = $message->{created_at};
	$time_string =~ s/\+0000/GMT/;
	my $time = DateTime::Format::HTTP->parse_datetime($time_string);
	
	print qq($user\n$text\n$time\n\n);	
}