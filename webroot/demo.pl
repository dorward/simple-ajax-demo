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
	
	my $query = undef;
	
	if (my $start = $q->param('start')) {
		$query = { tweetid => {  '>' => $start } };
	}
	
	my $limits = {
		rows => 20,
		order_by => q(time DESC),
		};

	my @messages = $schema->resultset('Twitter')->search($query, $limits);
	
	my $vars = {messages => \@messages};
	
	if ($view eq "json") {
		my $data = $json->convert_blessed->encode($vars);
		print $q->header('application/json'), $data;
		return;
	}

	my $output;
	$tt->process('html.tt', $vars, \$output)
    || die $tt->error(), "\n";
	
	print $q->header, $output;
}
