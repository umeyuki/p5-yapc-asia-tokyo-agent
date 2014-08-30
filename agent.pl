#!perl

use strict;
use warnings;
use utf8;

use Config::Pit;
use Net::Twitter::Lite::WithAPIv1_1;
use Encode;
use DDP;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage qw/pod2usage/;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new();

=head

Option
  date: YAPC前夜祭の開催日付

=cut



GetOptions(
    \my %opt, qw/
    date=s
/) or pod2usage(1);


# see https://metacpan.org/pod/Config::Pit
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

sub main {
    my $cond = join(" OR ", qq/#yapcasia YAPC yapc/);
    $cond = $cond . " -rt/-via exclude:retweets filter:links since:$opt{date}";
    my $since_id = 0;
    my %result = ();

    while ( my $res = &search_tweet( $nt, $cond, $since_id ) ) {
        last unless @{$res->{statuses}};
        for my $tweet ( @{ $res->{statuses} } ) {
            my $url = $tweet->{entities}->{urls}->[0]->{url};
            if ($url) {
                my $res = &get_post($url);

                # 短縮URL リダイレクト先URL
                my $post_url = $res->request->uri;
                my $title    = &get_title( $res->content );

                #TODO instagramとか外す
                next unless  $title;
                # 重複除く
                $result{$post_url} = $title;
            }
        }
        $since_id = $res->{search_metadata}->{max_id};
    }

    # アンカータグにして出力
    for my $url ( keys %result ) {
        print sprintf( "<a href='%s'>%s</a>", $url, $result{$url} ) . "\n";
    }
}


sub search_tweet {
    my ( $nt, $cond, $since_id) = @_;
    $nt->search({q => $cond, since_id => $since_id ,count => 100, lang => 'ja'});
}

sub get_post {
    my $url = shift;
    $ua->get($url);
}

sub get_title {
    my $html = shift;
    my ($title) = $html =~ m!<title>(.+?)</title>!i;
    return $title;
}


&main();
