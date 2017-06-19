document.addEventListener('turbolinks:load', function() {
  $('.thumbnail img').each(function(index) {
    var $image = $(this);
    var $caption = $image.siblings('.caption');
    $image.wrap(function() {
      return '<a href="' + $image.attr('src') + '" data-lightbox="image"\
        data-title="' + $caption.text() + '"></a>'
    });
  });
  lightbox.init();

  $('a.download-book').click(function(e) {
    var url = $(this).attr('href');
    ga('send', 'event', 'Book', 'download', url, {
      'hitCallback': function() {
        document.location = url;
      }
    });
    e.preventDefault();
  });
});
