#!/usr/bin/perl
#[root@dnspod]# cat d.pl 
use strict;
use Daemonise;
use  File::Slurp;

Daemonise::daemonise;
#ddopen FH,'ddns.pl';  #要变为进程的脚本名字
my $code=read_file('ddns.pl');
#print $code;
while(1){
	eval($code);
	if($@){
		print  $@;
	}
	sleep 300;#暂停后再执行
}