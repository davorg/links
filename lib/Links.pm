use Feature::Compat::Class;

class Links {
  use JSON;

  field $name :param;
  field $handle :param;
  field $image :param;
  field $desc :param;

  method name { return $name }
  method handle { return $handle }
  method image { return $image }
  method desc { return $desc }

  field $socials :param = [];
  field $links :param = [];

  method socials { return $socials }
  method links { return $links }

  method json_ld {
    my $json = {
      '@context' => 'https://schema.org',
      '@type' => 'Person',
      name => $self->name,
      image => $self->image,
      sameAs => [ map { $_->mk_social_link } $self->socials->@* ],
      relatedLink => [ map { $_->link } $self->links->@* ],
    };

    return JSON->new->pretty->encode($json);
  }
}