use Feature::Compat::Class;

class Links {
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
}