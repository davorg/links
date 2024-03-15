use Feature::Compat::Class;

class Links::Link {
  field $title :param;
  field $subtitle :param = '';
  field $link :param;

  method title { return $title }
  method subtitle { return $subtitle }
  method link { return $link }

  method mk_link {
    my $a_tag = q[<a href="] . $self->link . q[" class="text-decoration-none">] . $self->title . q[</a>];
    my $subtitle = $self->subtitle ? q[<br><small class="text-muted">] . $self->subtitle . q[</small>] : '';

    return q[<li class='list-group-item list-group-item-action'>] . $a_tag . $subtitle . q[</li>];
  }
}