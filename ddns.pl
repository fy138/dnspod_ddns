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
use Log::Log4perl qw(:easy);

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
		#print "ip not update\n";
	}else{
		$ipcache{lastip}=$ip;
		INFO "IP update:".$ip;
		INFO updateip($email,$password,$domain,$sub_domain,$ip);
	}
}else{
	ERROR "can't get ip\n";
}

sub updateip{
	my $email	= shift;
	my $password	= shift;
	my $domain	= shift;
	my $sub_domain	= shift;
	my $ip		= shift;

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
		ERROR  $res->{status}->{message};
		return ;
	}
	my $recordlist = $obj->RecordList({domain_id=>$domainid});
### $recordlist;

	unless($recordlist->{status}->{code}){
		ERROR  $recordlist->{status}->{message};
		return ;
	}
	my $sub_id;
	for my $r(@{$recordlist->{records}}){
		if($r->{name} eq $sub_domain){
			$sub_id=$r->{id};
			last;
		}	
	}

	unless ($sub_id){
		ERROR  "sub domain not found ,please add on your DNSPOD\n";
		return ;
	}


	my $result=$obj->RecordDdns({
		domain_id=>$domainid
		,record_id=>$sub_id
		,sub_domain=>$sub_domain
		,record_line=>'默认'
		,value=>$ip
	});

	### $result
	if($result->{status}->{code}){
		INFO "SUCCESS!\n";
	}else{
		ERROR "FAIL!\n";
		ERROR $result->{status}->{message}."\n";
	}
}
