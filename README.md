# Dist::Zilla::App::Command::aliendeps [![Build Status](https://secure.travis-ci.org/Perl5-Alien/Dist-Zilla-App-Command-aliendeps.png)](http://travis-ci.org/Perl5-Alien/Dist-Zilla-App-Command-aliendeps)

(DEPRECATED) Print your alien distributions alien prerequisites

# SYNOPSIS

    % dzil aliendeps | cpanm

# DESCRIPTION

**NOTE**: This [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) subcommand is deprecated in favor of [App::af](https://metacpan.org/pod/App::af)
which can produce useful results with [alienfile](https://metacpan.org/pod/alienfile) + [Alien::Build](https://metacpan.org/pod/Alien::Build) with the
`af missing` command.

[Alien::Base](https://metacpan.org/pod/Alien::Base) based [Alien](https://metacpan.org/pod/Alien) distributions may have optional dependencies
that are required when it is determined that a build from source code is
necessary.  This command probes your distribution for such optional requirements
and lists them.

This command of course works with [Dist::Zilla::Plugin::Alien](https://metacpan.org/pod/Dist::Zilla::Plugin::Alien) (and
[Dist::Zilla::PluginBundle::Alien](https://metacpan.org/pod/Dist::Zilla::PluginBundle::Alien)), but will also work with any
[Dist::Zilla::Plugin::ModuleBuild](https://metacpan.org/pod/Dist::Zilla::Plugin::ModuleBuild) based distribution that emits an
`alien_bin_requires` property.

# OPTIONS

- --env

    Honor the `ALIEN_FORCE` and `ALIEN_INSTALL_TYPE` environment variables used by
    [Alien::Base::ModuleBuild](https://metacpan.org/pod/Alien::Base::ModuleBuild) (see [Alien::Base::ModuleBuild::API](https://metacpan.org/pod/Alien::Base::ModuleBuild::API)).  That is
    do not list anything unless a source code build will be forced.  This may be useful
    when invoked from a .travis.yml file.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
