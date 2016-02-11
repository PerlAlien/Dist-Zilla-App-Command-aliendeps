package Dist::Zilla::App::Command::aliendeps;

use strict;
use warnings;
use Dist::Zilla::App -command;
use Ref::Util qw( is_hashref );

# ABSTRACT: Print your alien distributions alien prerequisites
# VERSION

=head1 SYNOPSIS

 % dzil aliendeps | cpanm

=head1 DESCRIPTION

L<Alien::Base> based L<Alien> distributions may have optional dependencies
that are required when it is determined that a build from source code is
necessary.  This command probes your distribution for such optional requirements
and lists them.

This command of course works with L<Dist::Zilla::Plugin::Alien> (and
L<Dist::Zilla::PluginBundle::Alien>), but will also work with any
L<Dist::Zilla::Plugin::ModuleBuild> based distribution that emits an
C<alien_bin_requires> property.


=head1 OPTIONS

=over 4

=item --env

Honor the C<ALIEN_FORCE> and C<ALIEN_INSTALL_TYPE> environment variables used by
L<Alien::Base::ModuleBuild> (see L<Alien::Base::ModuleBuild::API>).  That is
do not list anything unless a source code build will be forced.  This may be useful
when invoked from a .travis.yml file.

=back

=cut

sub abstract { "print your alien distributions alien prerequisites" }

sub opt_spec { [ 'env', 'honor ALIEN_FORCE and ALIEN_INSTALL_TYPE environment variables' ] }

sub execute
{
  my ($self, $opt, $arg) = @_;

  if($opt->env)
  {
    if(defined $ENV{ALIEN_INSTALL_TYPE})
    {
      return if $ENV{ALIEN_INSTALL_TYPE} eq 'system';
    }
    elsif(defined $ENV{ALIEN_FORCE})
    {
      return if !$ENV{ALIEN_FORCE};
    }
  }
  
  # Dist::Zilla::Plugin::ModuleBuild
  # module_build_args
  $self->app->chrome->logger->mute;
  
  my $zilla = $self->zilla;
  $_->before_build for @{ $zilla->plugins_with(-BeforeBuild) };
  $_->gather_files for @{ $zilla->plugins_with(-FileGatherer) };
  $_->set_file_encodings for @{ $zilla->plugins_with(-EncodingProvider) };
  $_->prune_files  for @{ $zilla->plugins_with(-FilePruner) };
  $_->munge_files  for @{ $zilla->plugins_with(-FileMunger) };
  $_->register_prereqs for @{ $zilla->plugins_with(-PrereqSource) };

  my($pmb) = grep { $_->isa("Dist::Zilla::Plugin::ModuleBuild") } @{ $zilla->plugins };
  
  return unless $pmb;
  
  my $alien_bin_requires = $pmb->module_build_args->{alien_bin_requires};
  
  return unless is_hashref $alien_bin_requires;
  
  foreach my $name (sort keys %$alien_bin_requires)
  {
    print "$name\n";
  }
}

1;
