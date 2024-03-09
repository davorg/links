use Feature::Compat::Class;

class Links::Link {
  field $title :param;
  field $link :param;

  method title { return $title }
  method link { return $link }

  method mk_link {
    return q[<li class='list-group-item list-group-item-action'><a href="] .
      $self->link . q[">] . $self->title . q[</a></li>];
  }
}