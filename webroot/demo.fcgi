#!/usr/bin/perl

use strict;
use warnings;
use CGI::Fast;
use Template;

my $tt = Template->new({
    INCLUDE_PATH => '/home/david/prog/simple-ajax-demo/templates',
    INTERPOLATE  => 1,
}) || die "$Template::ERROR\n";

while (my $q = new CGI::Fast) {
	&process_request($q);
}

sub process_request {
	my $q = shift;
	
	my $view = "html";
	
	my $json = $q->Accept('application/json');
	my $html = $q->Accept('text/html');
	
	use Data::Dumper;
	warn Dumper [ $json, $html ];
	
	my $vars = {};
	
	my $output;
	$tt->process('html.tt', $vars, \$output)
    || die $tt->error(), "\n";
	
	print $q->header;
	print $output;
	
	
}