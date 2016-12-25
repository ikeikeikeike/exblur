$(function() {

  var slideout = new Slideout({
    'panel': document.getElementById('sliderpanel'),
    'menu': document.getElementById('slidermenu'),
    'padding': 256,
    'tolerance': 70,
    'touch': false,
    'side': 'right',
  });

  // Toggle button
  document.querySelector('.toggle-slidermenu').addEventListener('click', function() {
    slideout.toggle();
  });

});
