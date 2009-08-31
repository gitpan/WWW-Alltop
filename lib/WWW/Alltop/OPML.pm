package WWW::Alltop::OPML;

use Moose;
use DateTime;
use XML::OPML;

extends qw/WWW::Alltop/;

has num_per_topic => ( is => 'rw', isa => 'Int', default => 4 );
has logger => ( 
    is => 'rw', 
    lazy => 1, 
    default => sub { 
           Log::Log4perl->get_logger() 
    }
);
has debug => ( is => 'rw', isa => 'Bool' );

sub generate_opml {
    my ($self) = @_;

    my $data = { opmlvalue => 'embed' };

    my $num = 0;
    my $topics = $self->topics;

    @$topics = @$topics[0..2]
        if ($self->debug);

    foreach my $t ( @$topics ) {
        $data->{'outline_'.$num++} = $self->_generate_opml_by_topic( $t );
    }

    my $opml = XML::OPML->new( version => '1.1' );
    $opml->head(
        title        => 'Alltop.com Feeds',
        dateCreated  => DateTime->now,
        dateModified => DateTime->now,
    );


    $opml->add_outline( %$data );
    return $opml->as_string;

}

sub _generate_opml_by_topic {
    my ($self, $topic) = @_;
    my @rss_urls;

    my $logger   = $self->logger;

    my $listings = $topic->listings;

    $logger->info(sprintf 'Found %s listings for %s', scalar(@$listings), $topic->name);

    @$listings = @$listings[0..$self->num_per_topic - 1] 
        if @$listings > $self->num_per_topic;

    my @values = (1..$self->num_per_topic);
    my $outline = { 
        opmlvalue => 'embed',
        text      => $topic->name,
    };

    foreach my $tl (@$listings) {
        my $rss_url;
        eval {
            $rss_url = $tl->rss_url;
        };
        if ($@) {
            $logger->error(sprintf "Couldn't get RSS for %s (%s)", $tl->url, $@);
            next;
        }
        if (!$rss_url) {
            $logger->error(sprintf "Missing rss for %s (%s)", $tl->name, $tl->url);
            next;
        }

        $logger->debug($tl->name . ' ' . $rss_url);

        $outline->{ 'outline_'.shift(@values) } = {
            title   => $tl->name,
            text    => $tl->name,
            type    => 'rss',
            version => 'RSS',
            htmlUrl => $tl->url,
            xmlUrl  => $rss_url,
        };
     }
     return $outline;
}

sub _make_child_do_work {
    my $self = shift;
    my $pid = fork;
        # child
    if ($pid) {
        # parent
    }
    elsif ($pid == 0) {
        # child
        $self->logger->debug("Child");
    }
    else {
        die "Couldnt fork: $!\n";
    }
    $self->logger->debug("doh");

}

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

WWW::Alltop::OPML - Create an OPML document that contains WWW::Alltop feeds

=head1 SYNOPSIS

  use WWW::Alltop::OPML;

  my $ad = WWW::Alltop::OPML->new;
  print $ad->generate_opml;

=head1 DESCRIPTION

A subclass of WWW::Alltop, this generates an OPML document containing data
from Alltop.com

=head1 ATTRIBUTES

=over

=item I<logger>

A Log::Log4Perl logger.  Defaults to Log::Log4perl->get_logger.  Best used 
when logging $ALL output.

=item I<num_per_topic>

For specifying how many of each topic to retrieve.  Defaults to the top 4 per
topic.

=item I<debug>

When true, only generates a small subset of the topics.  This is useful when
debugging the output of the opml.

=back

=head1 METHODS

=over

=item B<generate_opml>()

Generates the OPML, based on the settings the object has.

=back

=head1 AUTHOR

Josh Braegger E<lt>rckclmbr@gmail.comE<gt> for http://notify.me/

=head1 SEE ALSO

WWW::Alltop

=cut
