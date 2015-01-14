package dnspodApi;

use strict;
use warnings;
use HTTP::Tiny;
use Moo;
use Data::Dumper;
#use Smart::Comments;
use JSON;

has email => (is => 'rw');
has password => (is => 'rw');
has domain => (is => 'rw');
has domain_id => (is => 'rw', default => '');
has record_id => (is => 'rw');
has baseUrl => ( is => 'rw', default => 'https://dnsapi.cn');
has form_data => (is => 'rw');
has options => (is => 'rw');

sub __init__ {
	my $self = shift;
	my $parameter = shift || {};	
	my $form_data = {
	       login_email => $self->email,
	       login_password => $self->password,
		   format => 'json',
	};

	my %options = (
		"Content-type" => "application/x-www-form-urlencoded", 
		"Accept" => "text/json", 
		"User-Agent" => "wanyne.zhou"
	);

	my %new = (%$form_data, %$parameter);
	$form_data = \%new;
	$self->form_data($form_data);
	$self->options(\%options);
}

sub InfoVersion {
	my $self = shift;
	my $uri = '/Info.Version';
	my $res = $self->request($uri, {});
	return $res;
}

sub UserDetail {
	my $self = shift;
	my $uri  = '/User.Detail';
	my $res  = $self->request($uri, {});
	return $res;
}

sub UserInfo {
	my $self = shift;
	my $uri  = '/User.Info';
	my $res = $self->request($uri, {});
	return $res;
}

sub UserLog {
	my $self = shift;
	my $uri  = '/User.Log';
	my $res = $self->request($uri, {});
	return $res;
}

sub DomainCreate {
	my $self = shift;
	my $para = shift;
	my $uri = '/Domain.Create';
	my $res = $self->request($uri, $para);
	return $res;
}

sub DomainId {
	my $self = shift;
	my $para = shift;
	my $uri = '/Domain.Id';
	my $res = $self->request($uri, $para);
	return $res;
}

sub DomainList {
	my $self = shift;
	my $para = shift;
	my $uri  = '/Domain.List';
	my $res  = $self->request($uri, {});
}

sub DomainRemove {
	my $self = shift;
	my $para = shift;
	my $uri	 = '/Domain.Remove';
	my $res  = $self->request($uri, $para);
	return $res;
}

sub DomainStatus {
	my $self = shift;
	my $para = shift;
	my $uri  = '/Domain.status';
	my $res  = $self->request($uri, $para);
	return $res;
}

sub DomainInfo {
	my $self = shift;
	my $para = shift;
	my $uri  = '/Domain.Info';
	my $res  = $self->request($uri, $para);
	return $res;
}

sub DomainLog {
	my $self = shift;
	my $para = shift;
	my $uri  = '/Domain.Log';
	my $res  = $self->request($uri, $para);
	return $res;
}

sub RecordLine {
	my $self = shift;
	my $para = shift;
	my $uri  = '/RecordLine';
	my $res  = $self->request($uri, $para);
	return $res;
}
sub RecordList {
	my $self = shift;
	my $para = shift;
	my $uri = '/Record.List';
	return $self->request($uri,$para);

}
sub RecordDdns {
	my $self = shift;
	my $para = shift;
	my $uri = '/Record.Ddns';
	return $self->request($uri,$para);

}
sub request {
	my $self = shift;
	my $uri  = shift;
	my $para = shift;

	$self->__init__($para); # 初始化参数

	my $form_data = $self->form_data;
	my $options   = $self->options;
	my $url       = $self->baseUrl . $uri;

	my $http     = HTTP::Tiny->new('agent'=>'HTTP::Tiny(fy@yiyou.org)');
	### $http
	my $response = $http->post_form($url, $form_data, $options);
	### $response
	die "Failed!\n" unless $response->{success};
	 
	my $res_hash = decode_json $response->{content} if length $response->{content};
	if ($res_hash->{status}{code} == 1) {
		return $res_hash;	
	}
	else {
		die Dumper $res_hash;	
	}
}

1;
