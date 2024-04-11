use Feature::Compat::Class;

class Links::App {

  use strict;
  use warnings;
  use feature qw[say signatures];
  no warnings 'experimental::signatures';

  use Template;
  use JSON;
  use Path::Tiny;
  use File::Find;
  use File::Basename;
  use FindBin '$Bin';

  use Links;
  use Links::Link;
  use Links::Social;

  field $src  = 'src';
  field $out  = 'docs';
  field $ga4;
  field $font_awesome_kit;
  field $link_object;

  method src { return $src }
  method out { return $out }
  method ga4 { return $ga4 }
  method font_awesome_kit { return $font_awesome_kit }
  method link_object { return $link_object }

  field $tt;

  ADJUST {
    my $json = path('links.json')->slurp;
    my $data = JSON->new->decode($json);

    $ga4 = $data->{ga4} // '';
    $font_awesome_kit = $data->{font_awesome_kit} // '';

    $tt = Template->new({
      INCLUDE_PATH => "$Bin/$src",
      OUTPUT_PATH  => "$Bin/$out",
      VARIABLES    => {
        ga4            => $ga4,
        font_awesome_kit => $font_awesome_kit,
      }
    });

    my $socials = [ map {
      $_->{handle} //= $data->{handle};
      Links::Social->new(%$_)
    } $data->{social}->@* ];

    my $links = [ map { Links::Link->new(%$_) } $data->{links}->@* ];

    $link_object = Links->new(
      name    => $data->{name},
      handle  => $data->{handle},
      image   => $data->{image},
      desc    => $data->{desc},
      og_image => $data->{og_image},
      site_url => $data->{site_url},
      socials => $socials,
      links   => $links,
    );
  }

  method run {
    find( sub { $self->do_this }, $src);
  }

  method do_this {
    my $path = $File::Find::name =~ s|^$src/||r;

    if (/\.tt$/) {
      debug("Process $path to", basename($path, '.tt'));
      $tt->process($path, { data => $self->link_object }, basename($path, '.tt'))
        or die $tt->error;
    } else {
      if (-d) {
        debug("Make directory $path");
        path("$Bin/$out/$path")->mkdir;
      } elsif (-f) {
        debug("Copy $path");
        path("$Bin/$src/$path")->copy("$Bin/$out/$path");
      } else {
        debug("Confused by $File::Find::name");
      }
    }
  }

  sub debug {
    warn "@_\n" if $ENV{LINKS_DEBUG};
  }
}

