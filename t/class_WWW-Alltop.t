use strict;
use warnings;
use Test::More tests => 5;
use WWW::Mechanize;

my ( $class, $instance );
$class = 'WWW::Alltop';
eval "use $class";

ok( $instance = $class->new, 'instance can be created' );

my @methods = qw(mech topics);
can_ok( $class, @methods );
can_ok( $instance, @methods );

my $mech = WWW::Mechanize->new;
ok( $instance->mech( $mech ), 'set mech' );
is( $instance->mech, $mech, 'mech maintained state' );
