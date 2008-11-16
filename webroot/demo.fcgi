#!/usr/bin/perl

use strict;
use warnings;
use CGI::Fast;

my $COUNTER = 0;

while (my $q = new CGI::Fast) {
	&process_request($q);
}

sub process_request {
	my $q = shift;
	
	print $q->header;
	print $q->start_html("Fast CGI Rocks");
	print
	    $q->h1("Fast CGI Rocks"),
	    "Invocation number ",$q->b($COUNTER++),
            " PID ",$q->b($$),".",
	    $q->hr;
        print $q->end_html;	
}