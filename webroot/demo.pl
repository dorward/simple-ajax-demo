#!/usr/bin/perl

use strict;
use warnings;
use CGI::Fast;
use Template;
use JSON::XS;
use DateTime;
use lib qw( ../lib/ );
use App::SimpleAjaxDemo::DB;

my $tt = Template->new({
    INCLUDE_PATH => '/home/david/prog/simple-ajax-demo/templates',
    INTERPOLATE  => 1,
}) || die "$Template::ERROR\n";

my $json = JSON::XS->new;
my $schema = App::SimpleAjaxDemo::DB->connect('dbi:SQLite:../data/sqlite.db');

while (my $q = new CGI::Fast) {
	&process_request($q);
}

sub process_request {
	my $q = shift;
	my $view = $q->param("type") || "html";
	
	# By default, don't limit the query with a WHERE clause
	my $query = undef;
	
	# If data from a specific point is requested, add it to the query 
	if (my $start = $q->param('start')) {
		$query = { tweetid => {  '>' => $start } };
	}
	
	# Standard SQL settings
	my $limits = {
		rows => 20,
		order_by => q(tweetid DESC),
		};

	my @messages = $schema->resultset('Twitter')->search($query, $limits);
	
	# Identify highest id (we use it to request more data from the server)
	my @ids = sort { $a <=> $b } map { $_->tweetid } @messages;
	my $id = pop @ids;
	
	# Prepare data to send to the client
	my $vars = {messages => \@messages, most_recent => $id};
	
	# Now format that data as JSON or HTML	
	if ($view eq "json") {
		my $data = $json->convert_blessed->encode($vars);
		print $q->header('application/json;charset=utf-8'), $data;
		return;
	}

	my $output;
	$tt->process('html.tt', $vars, \$output)
    || die $tt->error(), "\n";
	
	print $q->header('text/html;charset=utf-8'), $output;
}
