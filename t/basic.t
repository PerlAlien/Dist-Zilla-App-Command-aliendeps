use strict;
use warnings;
use Test::More;
use Dist::Zilla::App::Tester;

plan skip_all => 'Test requires Dist::Zilla::PluginBundle::Alien'
  unless eval q{ require Dist::Zilla::PluginBundle::Alien; 1 };
plan tests => 1;

delete $ENV{$_} for qw( ALIEN_FORCE ALIEN_INSTALL_TYPE );

subtest normal => sub {
  my $output = test_dzil('corpus/dist1', ['aliendeps'])->output;
  chomp $output;
  is_deeply [split /\n/, $output], [qw( Alien::bar Alien::foo )], "expexted alien prereqs";
};

