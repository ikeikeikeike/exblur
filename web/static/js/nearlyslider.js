(function($) {

var $jq = $;


$(document).on('ready', function() {

  $('.nearly-box').removeClass('hide');
  $('.nearly-slider').slick({
    infinite: true,
    dots: false,
    slidesToShow: 8,
    slidesToScroll: 8,
    prevArrow: '<a type="button" data-role="none" class="slick-prev" aria-label="Previous" tabindex="0" role="button">Previous</a>',
    nextArrow: '<a type="button" data-role="none" class="slick-next" aria-label="Next" tabindex="0" role="button">Next</a>',
    responsive: [
      {
        breakpoint: 1200,
        settings: {
          slidesToShow: 8,
          slidesToScroll: 8,
        }
      }, {
        breakpoint: 992,
        settings: {
          slidesToShow: 6,
          slidesToScroll: 6,
        }
      }, {
        breakpoint: 768,
        settings: {
          slidesToShow: 4,
          slidesToScroll: 4,
        }
      }, {
        breakpoint: 480,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 3,
        }
      }
    ]
  });


});


})($);
