package Dist::Zilla::App::Command::aliendeps;

use strict;
use warnings;
use Dist::Zilla::App -command;
use Ref::Util qw( is_hashref );

# ABSTRACT: Print your alien distributions alien prerequisites
# VERSION

sub abstract { "print your alien distributions alien prerequisites" }

sub opt_spec { () }

sub execute
{
  my ($self, $opt, $arg) = @_;
  
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
