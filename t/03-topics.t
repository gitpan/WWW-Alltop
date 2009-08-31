use strict;
use warnings;
use Test::More tests => 3;
use WWW::Mechanize;

my ( $class, $instance );
$class = 'WWW::Alltop';
eval "use $class";

$instance = $class->new;

isa_ok( $instance->mech, 'WWW::Mechanize', 'Gave us a mech for us' );

my $topics;
ok( $topics = $instance->topics, 'feeds works' );
isa_ok( $topics, 'ARRAY', 'topics' );
