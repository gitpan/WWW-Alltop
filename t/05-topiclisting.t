use strict;
use warnings;
use Test::More tests => 4;
use WWW::AllTop::TopicListing;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new(
    agent => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)'
);
my $name = 'Tech Crunch';
my $url = 'http://www.techcrunch.com';

my $instance = WWW::AllTop::TopicListing->new(
    name => $name,
    url  => $url,
    mech => $mech,
);

my $rss_url;
my $is_rss_url = 'http://feedproxy.google.com/TechCrunch';
ok( $rss_url = $instance->rss_url, 'rss_url works' );
cmp_ok( $rss_url, 'eq', $is_rss_url, 'rss_url is correct' );

diag( 'Trying MSNBC' );
# MSNBC is a fancy one, because it displays a page designed for phones when
# using the default agent.  So I just added it in as another test.

$instance->name('MSNBC Cancer News and Information');
$instance->url( 'http://www.msnbc.msn.com/id/3034576/' );

$is_rss_url = 'http://www.msnbc.msn.com/id/3034575/device/rss/rss.xml';
ok( $rss_url = $instance->rss_url, 'rss_url works' );
cmp_ok( $rss_url, 'eq', $is_rss_url, 'rss_url is correct' );
