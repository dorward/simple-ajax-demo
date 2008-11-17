#!/usr/bin/perl

use strict;
use warnings;
use CGI::Fast;
use Template;
use JSON::XS;
use lib qw( ../lib/ );
use DB;

my $tt = Template->new({
    INCLUDE_PATH => '/home/david/prog/simple-ajax-demo/templates',
    INTERPOLATE  => 1,
}) || die "$Template::ERROR\n";

my $json = JSON::XS->new;

# TODO: Check that SQLite doesn't like it if something else writes to the DB while it is open here
my $schema = DB->connect('dbi:SQLite:../data/sqlite.db');

while (my $q = new CGI::Fast) {
	&process_request($q);
}

sub process_request {
	my $q = shift;
	my $view = $q->param("type") || "html";
	
	# TODO - limit this by time stamp
	my @messages = $schema->resultset('Twitter')->all();
	
	my $vars = {messages => \@messages};
	
	if ($view eq "json") {
		my $data = $json->encode($vars);
		print $q->header('application/json'), $data;
		return;
	}

	my $output;
	$tt->process('html.tt', $vars, \$output)
    || die $tt->error(), "\n";
	
	print $q->header, $output;
}
