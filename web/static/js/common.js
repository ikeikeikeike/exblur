(function($) {

var $jq = $;


$(document).on('ready', function() {
  $('.linker').on('click', function(e){
    e.stopPropagation();
    e.preventDefault();

    var w, url = $(this).data('link');

    // happend error in phoenix router
    // if (document.referrer) {
      // var referrer = "referrer=" + encodeURIComponent(document.referrer);
      // url = url + (location.search ? '&' : '?') + referrer;
    // }

    if ($(this).attr('target') === '_blank') {
      w = window.open();
      w.location.href = url;
      return;
    }

    if (e.ctrlKey || e.metaKey) {
      w = window.open();
      w.location.href = url;
      return;
    }

    location.href = url;
  })
});

$(function() {
  $('.btn-loading').on('click', function() {
    const $btn = $(this).button('loading');
    setTimeout(() => $btn.button('reset'), 3000);
  });
});


})($);
