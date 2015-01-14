#!/usr/bin/perl

use strict;
use  File::Slurp;
use App::Daemon qw( daemonize );
daemonize();
while(1){
	my $code=read_file('ddns.pl');
	eval($code);
	if($@){
		print  $@;
	}
	sleep 60;#暂停后再执行
}
