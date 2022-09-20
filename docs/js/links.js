$(document).ready( function() {
  $.getJSON( "/links.json", function ( data ) {
    $('#img').children('img').attr('src', '/img/' + data.image);
    $('#name h1').text(data.name + ' / @' + data.handle);
    $('title').text(data.name + ' / @' + data.handle);
    $('#desc').text(data.desc);

    $.each(data.social, function( index, value ) {
      let link = mk_social_link(value, data.handle);
      $('#social p').append(
        $('<a>').attr('href', link).append(
          $('<i>').attr('class', 'fa-brands fa-' + value.service + ' fa-3x')
        )
      );
    });

    $.each(data.links, function( index, value ) {
      $('#links ul').append(
        $('<li>').attr('class', 'list-group-item list-group-item-action').append(
          $('<a>').attr('href', value.link).append(value.title)
        )
      );
    });
  })
  .fail(function(jqXHR, stat, err) {
    console.log( stat + ': ' + err );
  })
});

function mk_social_link (social, default_handle) {
  let urls = {
    "facebook": "https://facebook.com/",
    "twitter": "https://twitter.com/",
    "instagram": "https://instagram.com/",
    "tiktok": "https://tiktok.com/@",
    "linkedin": "https://linkedin.com/in/",
    "email": "mailto:",
    "substack": "https://XXXX.substack.com/",
    "github": "https://github.com/",
    "medium": "https://XXXX.medium.com/"
  };

  let handle = social.handle || default_handle;

  let url;

  if (social.service in urls) {
    url = urls[social.service];
  } else {
    console.log('Unknown social service: ' + social.service);
    return "";
  }

  if (url.match('XXXX')) {
    url = url.replace('XXXX', handle);
  } else {
    url = url + handle;
  }

  return(url);
}
