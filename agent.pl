#!perl

use strict;
use warnings;
use utf8;

use Config::Pit;
use Net::Twitter::Lite::WithAPIv1_1;
use DDP;

my $config = pit_get(
    "api.twitter.com",
    require => {
        "consumer_key"        => "your consumer key",
        "consumer_key_secret" => "your consumer key secret",
        "token"        => "",
        "token_secret" => ""
    }
);

my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
    consumer_key    => $config->{consumer_key},
    consumer_secret => $config->{consumer_key_secret},
    apiurl => 'https://api.twitter.com/1.1',
	legacy_lists_api => 0,
    ssl => 1
);

$nt->access_token($config->{token});
$nt->access_token_secret($config->{token_secret});

my $res = $nt->search({q=>'#yapcasia',count => 5, lang => 'ja'});

p $res;
