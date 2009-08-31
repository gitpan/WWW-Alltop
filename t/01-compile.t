use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
    use_ok( $_ ) 
        foreach qw/
            WWW::Alltop
            WWW::Alltop::Topic
            WWW::Alltop::TopicListing
            WWW::Alltop::OPML
        /;
}
