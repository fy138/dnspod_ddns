#!/bin/bash
cpanm="/bin/cpanm";
if [ ! -f $cpanm ];then
#	wget http://xrl.us/cpanm -O $cpanm;
wget -O $cpanm --no-check-certificate  https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm
fi
if [ ! -x $cpanm ];then
	chmod +x $cpanm
fi
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
	'Net::SSLeay',
	'IO::Socket::SSL',
	'File::Slurp',
	'App::Daemon'
);

print "You must be root to run this program\n" and exit 1 unless ($> == 0);

foreach my $module ( @packages ) {
     unless (eval { require $module }) {
     print "Need to install [ $module ] module.  I'll do that for you now:\n";
     my $ret = system("/bin/cpanm --mirror http://mirrors.163.com/cpan --mirror-only -n -f $module");
     print $ret;
    }
}

