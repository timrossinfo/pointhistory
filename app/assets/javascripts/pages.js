document.addEventListener("turbolinks:load", function() {
  $('.thumbnail img').on('click', function() {
    window.open(this.src);
  });
});
