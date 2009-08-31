use strict;
use warnings;
use Test::More tests => 6;
use WWW::Mechanize;

my ( $class, $instance );

BEGIN {
    $class = 'WWW::Alltop::TopicListing';
    use_ok( $class );
}

ok( $instance = $class->new, 'instance can be created' );

my @methods = qw(url name mech);
can_ok( $class, @methods );
can_ok( $instance, @methods );

my $name = 'Billy bob';
my $url  = 'http://www.google.com';

$instance->name( $name );
$instance->url( $url );

is( $instance->name, $name, 'name maintains state' );
is( $instance->url, $url, 'url maintains state' );
