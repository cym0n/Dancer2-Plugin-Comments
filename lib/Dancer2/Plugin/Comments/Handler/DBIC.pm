package Dancer2::Plugin::Comments::Handler::DBIC;

use Moo;
#use Dancer2::Plugin::DBIC;
use DBIx::Class::ResultClass::HashRefInflator;
use Data::Dumper;

with "Dancer2::Plugin::Comments::Role::Handler";

sub write_comment
{
    my $self = shift;
    my $data = shift;
    my $table = $self->conf->{'db_class'};
    $self->dsl->schema->resultset($table)->create($data);
}

sub get_comments
{
    my $self = shift;
    my $reference = shift;
    my $table = $self->conf->{'db_class'};
    my $rs = $self->dsl->schema->resultset($table)->search({ 'page' => $reference }, { order_by => 'timestamp DESC' });
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    return $rs->all;
}

1;
