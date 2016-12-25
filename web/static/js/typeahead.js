(function($) {


var $jq = $;

$(document).on('ready', function() {
  var $modal, divaSuggest, tagSuggest, $searchform, strlength;

  if (window.isMobile) {
    $modal = $('.js-autocomplete-modal');
    $modal.on('shown.bs.modal', function() {
      $searchform = $(this).find('input[name="search"]');
      strlength = $searchform.val().length * 2;

      $searchform.focus();
      $searchform[0].setSelectionRange(strlength, strlength);
    });
    $modal.on('hidden.bs.modal', function() {
      $('input.js-autocomplete-firedom').val($(this).find('input[name="search"]').val());
    });
  }

  tagSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/tags/autocomplete/%QUERY.json'
  });
  divaSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/divas/autocomplete/%QUERY.json'
  });

  tagSuggest.initialize();
  divaSuggest.initialize();

  return $('#remote .typeahead').typeahead({
    hint: true,
    highlight: true
  }, {
    name: 'tag-suggest',
    displayKey: 'value',
    source: tagSuggest.ttAdapter(),
    // templates: { header: '<h5 class="league-name"><i>Tag</i></h5>' }
  }, {
    name: 'diva-suggest',
    displayKey: 'value',
    source: divaSuggest.ttAdapter(),
    // templates: { header: '<h5 class="league-name"><i>Diva</i></h5>' }
  });
});


})($);
