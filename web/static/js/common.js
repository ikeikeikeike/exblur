$(document).on('ready', function() {
  $('.linker').on('click', function(e){
    e.stopPropagation();
    e.preventDefault();

    location.href = $(this).data('link');
  })
});
