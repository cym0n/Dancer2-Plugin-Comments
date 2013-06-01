package Dancer2::Plugin::Comments::Handler::Dumb;

use Moo;
#use Dancer2::Plugin::DBIC;
use Dancer2::FileUtils qw/path/;
use Data::Dumper;

with "Dancer2::Plugin::Comments::Role::Handler";

sub write_comment
{
    my $self = shift;
    my $data = shift;
    my $file = path($self->dsl->config->{appdir}, $self->conf->{'filename'});
    open(my $fh, ">> $file") or die "Argh: $file<br />$!";
    $data->{'mail'} = '' if ! $self->conf->{'mail'};
    $data->{'site'} = '' if ! $self->conf->{'site'};
    print {$fh} $data->{'author'}.';'.$data->{'text'}.';'.$data->{'page'}.';'.$data->{'mail'}.';'.$data->{'site'}.';'. time."\n";
    close($fh);
}

sub get_comments
{
    my $self = shift;
    my $reference = shift;
    my $file = path($self->dsl->config->{appdir}, $self->conf->{'filename'});
    open(my $fh, "< $file") or return undef;
    my @out;
    for(<$fh>)
    {
        chomp;
        my @data = split(';', $_);
        my $c;
        $c->{'author'} = $data[0];
        $c->{'text'} = $data[1];
        $c->{'page'} = $data[2];
        $c->{'mail'} = $self->conf->{'mail'} ? $data[3] : '';
        $c->{'site'} = $self->conf->{'site'} ? $data[4] : '';
        $c->{'timestamp'} = $data[5];
        push @out, $c if($c->{'page'} eq $reference);
    }
    @out = sort {$b->{'timestamp'} <=> $a->{'timestamp'}} @out;
    return @out;
}

1;
