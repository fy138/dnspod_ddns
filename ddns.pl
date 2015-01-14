#!/usr/bin/perl

# author : fy@yiyou.org
# 2015-01-12
# http://www.yiyou.org

use strict;
use warnings;
#use Smart::Comments; #uncomment to DEBUG
use dnspodApi;
use HTTP::Tiny;
use utf8;
use DB_File;
use Data::Dumper;

#------- CONFIG ------#
my $domain	= 'yiyou.org';
my $sub_domain	= 'home';
my $email	= ''; #dnspod account
my $password	= ''; #dnspod password
#------ END CONFIG -------#

my $tiny = HTTP::Tiny->new->get('http://members.3322.org/dyndns/getip');
my $ip;
if($tiny->{success}){
	$ip = $tiny->{content};
	chomp $ip;
	my %ipcache;
	tie(%ipcache, 'DB_File','/dev/shm/lastip'.$sub_domain.$domain, O_CREAT|O_RDWR, 0666, $DB_BTREE)
    		or die "Cannot open file : $!\n";
	if($ipcache{lastip} && $ipcache{lastip} eq $ip){
		print "ip not update\n";
		exit;
	}else{
		$ipcache{lastip}=$ip;
		### ip renew $ip
	}
}else{
	print "can't get ip\n";
	exit;
}

my $obj = dnspodApi->new(
	email => $email,
	password => $password
);


my $res = $obj->DomainId({domain => $domain});
### $res;
my $domainid;
if($res->{status}->{code}){
	$domainid=$res->{domains}->{id};
}else{
	die $res->{status}->{message};
}
my $recordlist = $obj->RecordList({domain_id=>$domainid});
### $recordlist;

unless($recordlist->{status}->{code}){
	die $recordlist->{status}->{message};
}
my $sub_id;
for my $r(@{$recordlist->{records}}){
	if($r->{name} eq $sub_domain){
		$sub_id=$r->{id};
		last;
	}	
}

unless ($sub_id){
	die "sub domain not found ,please add on your DNSPOD\n";
}


my $result=$obj->RecordDdns({
		domain_id=>$domainid
		,record_id=>$sub_id
		,sub_domain=>'home'
		,record_line=>'默认'
		,value=>$ip
	});

### $result
if($result->{status}->{code}){
	print "SUCCESS!\n";
}else{
	print "FAIL!\n";
	print $result->{status}->{message}."\n";
}
