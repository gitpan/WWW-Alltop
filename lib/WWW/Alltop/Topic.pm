package WWW::Alltop::Topic;

use Moose;
use WWW::Alltop::TopicListing;

has name => ( is => 'rw', isa => 'Str' );
has url  => ( is => 'rw', isa => 'Str' );
has mech => ( is => 'rw', isa => 'WWW::Mechanize' );

sub listings {
    my $self = shift;

    my $res = $self->mech->get( $self->url );

    if (!$res->is_success) {
        return [];
    }

    my $links = $self->mech->find_all_links( class => 'snap_shots' );
    return [ 
        map {
            WWW::Alltop::TopicListing->new(
                mech => $self->mech,
                name => $_->text,
                url  => $_->url,
            );
        } @$links 
    ];

}

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

WWW::Alltop::Topic - A Topic from Alltop.com

=head1 SYNOPSIS

  use WWW::Alltop::Topic;
  use WWW::Mechanize;

  my $t = WWW::Alltop::Topic->new(
    name => 'Tech',
    url  => 'http://tech.alltop.com/',
    mech => WWW::Mechanize->new,
  );

  # ArrayRef of WWW:Alltop::TopicListing
  my $listings =  $t->listings;
  foreach my $listing (@$listings) {
    ...
  }

=head1 DESCRIPTION

A topic representation from Alltop.com, used to fetch all listings for a
given topic (a topic being a subdomain of alltop.com).

=head1 ATTRIBUTES

=over

=item I<name>

The name of the topic.  For example, 'Tech'.

=item I<url>

The url of the topic.  For example, http://tech.alltop.com/.

=item I<mech>

A WWW::Mechanize instance

=back

=head1 METHODS

=over

=item B<listings>()

Fetches the listings (WWW::Alltop::TopicListing) for the topic, returning
an ArrayRef of all the listings found.

=back

=head1 SEE ALSO

WWW::Alltop

