#!/usr/bin/perl

use strict;
use  File::Slurp;
use App::Daemon qw( daemonize );
#$App::Daemon::background = 1;
my $code=read_file('ddns.pl');
$App::Daemon::as_user    = "root";
$App::Daemon::as_group   = "root";
daemonize();

#	print $code;
while(1){
	eval($code);
	if($@){
		print  $@;
	}
	sleep 60;#暂停后再执行
}
