use strict;
use warnings;
use Test::More tests => 4;
use WWW::Mechanize;

my ( $class, $instance );

BEGIN {
    $class = 'WWW::AllTop::Topic';
    use_ok( $class );
}

ok( $instance = $class->new, 'instance can be created' );

my @methods = qw(url name);
can_ok( $class, @methods );
can_ok( $instance, @methods );
