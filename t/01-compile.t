use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
    use_ok( $_ ) 
        foreach qw/
            WWW::AllTop
            WWW::AllTop::Topic
            WWW::AllTop::TopicListing
            WWW::AllTop::OPML
        /;
}
