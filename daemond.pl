#!/usr/bin/perl

use strict;
use  File::Slurp;
use App::Daemon qw( daemonize );
daemonize();

my $code=read_file('ddns.pl');
#print $code;
while(1){
	eval($code);
	if($@){
		print  $@;
	}
	sleep 300;#暂停后再执行
}
