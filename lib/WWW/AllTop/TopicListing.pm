package WWW::AllTop::TopicListing;

use Moose;
use HTML::TokeParser;

has url  => ( is => 'rw', isa => 'Str', );
has name => ( is => 'rw', isa => 'Str', );
has mech => ( is => 'rw', isa => 'WWW::Mechanize' );
has logger => ( 
    is => 'rw', 
    lazy => 1, 
    default => sub { 
           Log::Log4perl->get_logger() 
    }
);

my $mimetype_map = {
    'application/rss+xml'  => 'rss',
    'application/atom+xml' => 'atom',
};

sub _get_type_from_mimetype {
    my ($self, $mimetype) = @_;
    return $mimetype_map->{ $mimetype };
}

sub _verify_url_is_valid_feed {
	# TODO: Implement
	return 1; 
}

sub rss_url {
    my $self = shift;

    my $res = $self->mech->get( $self->url );
    if (!$res->is_success) {
        return;
    }

    my $content = $self->mech->content;
    my $parser = HTML::TokeParser->new( \$content );

	if ($self->mech->ct eq 'text/xml') {
		# Chances are, yes, it's a feed (is this wrong to assume?)
		$self->logger->debug( $self->url . ' is text/xml, so probably a feed' );
		return $self->url
	}

    # Go through all the link tags, grabbing the first Feed

    while ( my $t = $parser->get_tag('link') ) {
        my $l = $t->[1];
        if (
            $l && $l->{rel} && 
            $l->{rel} eq 'alternate' &&
            $self->_get_type_from_mimetype( $l->{type} )
        ) {
            return $self->_get_absolute_url( 
                $l->{href}
            );
        }
    }

    # Try to find the url in the body

    my $links = $self->mech->find_all_links( tag => 'a', url_regex => qr/rss\|atom/i );
    foreach my $l (@$links) {
		if ($l && $self->_verify_url_is_valid_feed( $l->url )) {
			return $self->_get_absolute_url( $l->url ) ;
		}
    }

    $links = $self->mech->find_all_links( tag => 'a', url_regex => qr/feed/i );
    foreach my $l (@$links) {
		if ($l && $self->_verify_url_is_valid_feed( $l->url )) {
			return $self->_get_absolute_url( $l->url ) ;
		}
    }


    return '';

}

sub _get_absolute_url {
    my ($self, $url) = @_;
    if ($url =~ /^\//o) {
        my ($domain) = ($self->url =~ /(https?:\/\/[^\/]+)/);
        $url = $domain . $url;
    }
    return $url;
}

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

WWW::AllTop::TopicListing - A TopicListing from AllTop.com

=head1 SYNOPSIS

  use WWW::AllTop::TopicListing;
  use WWW::Mechanize;
  use Log::Log4perl qw/:easy/;

  Log::Log4perl->easy_init( $ALL );

  my $tl = WWW::AllTop::TopicListing->new(
      url  => 'http://www.slashdot.org/',
      name => 'Slashdot',
      mech => WWW::Mechanize->new
  );
  print $tl->rss_url;

=head1 DESCRIPTION

A topic listing representation from AllTop.com, used to handle the listing
(or feed).

=head1 ATTRIBUTES

=over

=item I<name>

The name of the site for the listing. (eg Slashdot)

=item I<url>

The URL of the TopicListing, or html representation that should (hopefully)
contain the feed.

=item I<mech>

A WWW::Mechanize instance

=item I<logger>

A Log::Log4perl logger instance.

=back

=head1 METHODS

=over

=item B<rss_url>()

Attempts to fetch the RSS url of the TopicListing, by browsing to the site.
When not found, it will return an empty string.

=back

=head1 SEE ALSO

WWW::AllTop
WWW::AllTop::Topic

=cut
