use Feature::Compat::Class;

class Links::Social {
  use strict;
  use warnings;
  use feature qw[say signatures];
  no warnings qw[experimental::signatures experimental::class];

  field $service :param;
  field $handle :param;
  field $url :param;

  # TODO: This needs to be a class field.
  field $urls = {
    facebook   => {
      url  => "https://facebook.com/",
      name => 'Facebook',
    },
    'x-twitter' => {
      # This is currently still the correct URL
      url  => "https://twitter.com/",
      name => 'X/Twitter',
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
    letterboxd => {
      url  => 'https://letterboxd.com/',
      name => 'Letterboxd',
    },
    lastfm => {
      url  => 'https://last.fm/user/',
      name => 'last.fm',
    },
  };

  method service { return $service }
  method handle { return $handle }
  method url { return $url }

  method mk_social_link {
    my $social_url;

    return $url if $url;

    if (exists $urls->{$service}) {
      $social_url = $urls->{$service}{url};
    } else {
      warn('Unknown social service: ', $service);
      return;
    }

    if ($social_url =~ /XXXX/) {
      $social_url =~ s/XXXX/$handle/g;
    } else {
      $social_url .= $handle;
    }

    return $social_url;
  }

  method mk_social_icon {
    my $link = $self->mk_social_link();

    return q[<a title='] . $urls->{$self->service}{name} .
      qq[' href='$link'><i class='fa-brands fa-3x fa-] . $self->service . q['></i></a>];
  }
}

1;
