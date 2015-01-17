#!/usr/bin/perl

use strict;
use  File::Slurp;
use App::Daemon qw( daemonize );
use Proc::Fork;
#use POSIX 'WNOHANG'; 
#$SIG{CHLD}=sub {while (waitpid(-1,WNOHANG)>0) {}};

#$App::Daemon::background = 1;
my $code=read_file('ddns.pl');
$App::Daemon::logfile    = "/var/log/dnspod_ddns.log";
$App::Daemon::pidfile    = "/var/run/dnspod_ddns.pid";
$App::Daemon::as_user    = "root";
$App::Daemon::as_group   = "root";
daemonize();

#	print $code;
while(1){
	run_fork{
	child{ 
		eval($code);
		if($@){
			ERROR  $@;
		}
		exit;
	}
	parent{
		my $child_pid=shift;
		waitpid $child_pid,0;
	}
	};	
	sleep 60;#暂停后再执行
}
