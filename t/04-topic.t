use strict;
use warnings;
use Test::More tests => 3;
use WWW::AllTop::Topic;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new(
    agent => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)'
);
my $instance = WWW::AllTop::Topic->new(
    name => 'Venture Capital',
    url  => 'http://venturecapital.alltop.com/',
    mech => $mech,
);

my $listings;
ok( $listings = $instance->listings, 'listings works' );
isa_ok( $listings, 'ARRAY', 'listings' );

# There has to be an easier way to do this...
my $error = 0;
UNIVERSAL::isa( $_, 'WWW::AllTop::TopicListing' ) or $error = 1 
	foreach @$listings;
$error = 1 if !@$listings;
ok(!$error, 'listings is WWW::AllTop::TopicListing');
