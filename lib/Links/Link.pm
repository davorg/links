use Feature::Compat::Class;

class Links::Link {
  use strict;
  use warnings;
  no warnings 'experimental::class';

  field $title :param;
  field $subtitle :param = '';
  field $link :param;
  field $new_link :param(new) = 0;

  method title { return $title }
  method subtitle { return $subtitle }
  method link { return $link }
  method is_new { return $new_link }

  method mk_link {
    my $a_tag = q[<a href="] . $self->link . q[" class="text-decoration-none">] . $self->title . q[</a>];
    my $subtitle = $self->subtitle ? q[<br><small class="text-muted">] . $self->subtitle . q[</small>] : '';

    my @li_classes = qw[list-group-item list-group-item-action];
    push @li_classes, 'new-link' if $self->is_new;

    return qq[<li class='@li_classes'>$a_tag$subtitle</li>];
  }
}

1;
