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

  sub init_data {
    my $json = path('links.json')->slurp;
    return JSON->new->decode($json);
  };

  field $src  = 'src';
  field $out  = 'docs';
  field $data = init_data();

  field $urls = {
    facebook   => {
      url  => "https://facebook.com/",
      name => 'Facebook',
    },
    twitter    => {
      url  => "https://twitter.com/",
      name => 'Twitter',
    },
    instagram  => {
      url  => "https://instagram.com/",
      name => 'Instagram',
    },
    tiktok     => {
      url  => "https://tiktok.com/@",
      name => 'TikTok',
    },
    linkedin   => {
      url  => "https://linkedin.com/in/",
      name => 'LinkedIn',
    },
    substack   => {
      url  => "https://XXXX.substack.com/",
      name => 'Substack',
    },
    github     => {
      url  => "https://github.com/",
      name => 'GitHub',
    },
    medium     => {
      url  => "https://XXXX.medium.com/",
      name => 'Medium',
    },
    reddit     => {
      url  => "https://reddit.com/user/",
      name => 'Reddit',
    },
    quora      => {
      url  => "https://quora.com/profile/",
      name => 'Quora',
    },
    mastodon   => {
      # Hmm...
      url  => "https://fosstodon.org/@",
      name => 'Mastodon',
    },
    threads    => {
      url  => "https://www.threads.net/@",
      name => 'Threads',
    },
    bluesky   => {
      url  => 'https://bsky.app/profile/',
      name => 'Bluesky',
    },
  };

  field $tt = Template->new({
    INCLUDE_PATH => "$Bin/$src",
    OUTPUT_PATH  => "$Bin/$out",
    VARIABLES    => {
      mk_social_icon => \&mk_social_icon,
      mk_link        => \&mk_link,
      urls           => $urls,
    },
  });
  method run {
    find( sub { $self->do_this }, $src);
  }

  method do_this {
    my $path = $File::Find::name =~ s|^$src/||r;

    if (/\.tt$/) {
      debug("Process $path to", basename($path, '.tt'));
      $tt->process($path, $data, basename($path, '.tt'))
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

  sub mk_social_link ($social, $urls, $default_handle) {
    my $handle = $social->{handle} // $default_handle;

    my $url;

    if (exists $urls->{$social->{service}}) {
      $url = $urls->{$social->{service}}{url};
    } else {
      warn('Unknown social service: ', $social->{service});
      return;
    }

    if ($url =~ /XXXX/) {
      $url =~ s/XXXX/$handle/g;
    } else {
      $url .= $handle;
    }

    return $url;
  }

  sub mk_social_icon ($social, $urls, $default_handle) {
    my $link = mk_social_link($social, $urls, $default_handle);

    return qq[<a title='$urls->{$social->{service}}{name}' href='$link'><i class='fa-brands fa-3x fa-$social->{service}'></i></a>];
  }

  sub mk_link ($link) {
    return qq[<li class='list-group-item list-group-item-action'><a href="$link->{link}">$link->{title}</a></li>];
  }
}

