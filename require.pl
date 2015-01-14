#!/bin/bash
wget http://xrl.us/cpanm -O /bin/cpanm;
chmod +x /bin/cpanm
echo "must install openssl-devel";
apt-get -y install  libssl-dev
yum -y install openssl-devel
#! -*-perl-*-
eval 'exec perl -x -wS $0 ${1+"$@"}'
  if 0;

use strict;
my @packages=(
	'Moo',
	'Smart::Comments',
	'JSON',
	'HTTP::Tiny',
	'Net::SSLeay'
);

print "You must be root to run this program\n" and exit 1 unless ($> == 0);

foreach my $module ( @packages ) {
     unless (eval { require $module }) {
     print "Need to install [ $module ] module.  I'll do that for you now:\n";
     my $ret = system("/bin/cpanm --mirror http://mirrors.163.com/cpan --mirror-only $module");
     print $ret;
    }
}

