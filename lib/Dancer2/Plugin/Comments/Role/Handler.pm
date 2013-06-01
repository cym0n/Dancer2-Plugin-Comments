package Dancer2::Plugin::Comments::Role::Handler;

use Moo::Role;

has conf => (is => 'ro', required => 1);
has dsl => (is => 'ro', required => 1);

requires qw( write_comment get_comments );

1;

