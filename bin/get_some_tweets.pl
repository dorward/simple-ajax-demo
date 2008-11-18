#!/usr/bin/perl

use strict;
use warnings;
use Net::Twitter;
use Config::IniFiles;
use DateTime;
use DateTime::Format::HTTP;
use lib qw( ../lib/ );
use App::SimpleAjaxDemo::DB;

my $cfg = Config::IniFiles->new( 
		-file => "../data/config.ini",
	) or die("No config.ini found");

my $schema = App::SimpleAjaxDemo::DB->connect('dbi:SQLite:../data/sqlite.db');
	
my $twit = Net::Twitter->new(
	username => $cfg->{v}{auth}{username},
	password => $cfg->{v}{auth}{password},
);
  
my $messages_ref = $twit->friends_timeline();

my @messages = sort { 
	$a->{time} cmp $b->{time} 
	} map {
		tweet_to_hash_ref($_);
	} @$messages_ref;

for my $message (@messages) {
	my $tweet = $schema->resultset('Twitter')->find_or_create($message);
}

sub format_time {
	my $time_string = shift;
	$time_string =~ s/\+0000/GMT/; # Hack 
	my $time = DateTime::Format::HTTP->parse_datetime($time_string);
	$time = $schema->storage->datetime_parser->format_datetime($time);
	return $time;
}

sub tweet_to_hash_ref {
	my $tweet = shift;
	
	return {
		user => $tweet->{user}->{name},
		message => $tweet->{text},
		time => format_time($tweet->{created_at})
	};
}