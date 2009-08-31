package WWW::Alltop;

use Moose;
use WWW::Alltop::Topic;
use WWW::Mechanize;

has mech => ( 
    is   => 'rw', 
    isa  => 'WWW::Mechanize', 
    lazy => 1,
    default => sub {
        return WWW::Mechanize->new(
    		agent => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)'
		)
    }
);

our $VERSION = '0.01';

sub topics {
    my ($self) = @_;

    my $mech = $self->mech;
    my $res = $mech->get( 'http://alltop.com/widget/' );
    if (!$res->is_success) {
        return [];
    }

    my $form = $mech->form_number(1)->find_input('topic_name');

    return [
        map {
            WWW::Alltop::Topic->new(
                mech => $self->mech,
                name => $_->{name},
                url  => 'http://' . $_->{value} . '.alltop.com',
            )
        }
        grep { $_->{value} } 
        @{ $form->{menu} }
    ];
}

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

WWW::Alltop - Alltop.com feed scraper

=head1 SYNOPSIS

 use WWW::Alltop;

 my $ad = WWW::Alltop->new;

 # Arrayref of WWW::Alltop::Topic
 my $topics = $ad->topics;
 foreach my $t (@$topics) {
     ...
 }

=head1 DESCRIPTION

This module was designed to get a subset of the feeds used on Alltop.com

=head1 ATTRIBUTES

=over

=item I<mech>

A WWW::Mechanize instance.  Defaults to a new instance.

=back

=head1 METHODS

=over

=item B<topics>()

Fetches all the topics from Alltop.com, and returns them as an ArrayRef of
WWW::Alltop::Topic instances.

=back

=head1 AUTHOR

Josh Braegger E<lt>rckclmbr@gmail.comE<gt> for http://notify.me/

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
