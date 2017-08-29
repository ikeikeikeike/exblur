(function($) {


const $jq = $;

$(document).on('ready', function() {
  let $modal, vidSuggest, footerSuggest, divaSuggest, tagSuggest, $searchform, strlength;

  const isMobile = () => {
    return !(typeof window.matchMedia !== "undefined" && window.matchMedia('(min-width: 768px)').matches);
  }, titleText = (text) => {
    const rlen = isMobile() ? 29 : 47;
    return (text && text.mbLength() > rlen ? text.mbSubstr(0, rlen) + '...' : text) || '';
  },
  queryText = (text) => {
    const rlen = isMobile() ? 3 : 22;
    return (text && text.mbLength() > rlen ? text.mbSubstr(0, rlen) + "..." : text) || '';
  },
  imgFallback = (thumb) => {
    return thumb || 'https://placehold.it/60/79b74a/fff.jpg/?text=' // 'http://placehold.jp/888/ffffff/30x30.png?css=%7B%22border-radius%22%3A%2290px%22%7D&text=WANTED'
  };

  if (isMobile) {
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

  const limit = isMobile() ? 2 : 3;

  vidSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: limit,
    remote: '/autocomplete/vid/%QUERY.json'
  });
  tagSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: limit,
    remote: '/autocomplete/tag/%QUERY.json'
  });
  divaSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: limit,
    remote: '/autocomplete/diva/%QUERY.json'
  });
  footerSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: limit,
    remote: '/autocomplete/vid/__NONE__.json'
  });

  vidSuggest.initialize();
  tagSuggest.initialize();
  divaSuggest.initialize();
  footerSuggest.initialize();

  return $('#remote .typeahead').typeahead({
    hint: true,
    highlight: true
  }, {
    name: 'vid-suggest',
    displayKey: 'value',
    limit: limit,
    source: vidSuggest.ttAdapter(),
    templates: {
      header: '<h3 class="suggest-header league-name">Video</h3>',
      suggestion: (data) => {
        // console.log('diva: ', data);
        return `
        <a href="">
          <div class="my-suggest row">
            <div class="media">
              <div class="pull-left">
                <div class="my-suggest-image" style="background-image: url(${imgFallback(data.thumb)});"></div>
              </div>
              <div class="media-body">
                ${titleText(data.title)}
                <p class="media-heading"><small>${titleText(data.site_name)}</small></p>
              </div>
            </div>
          </div>
        </a>
        `;
      },
    }
  }, {
    name: 'diva-suggest',
    displayKey: 'value',
    limit: limit,
    source: divaSuggest.ttAdapter(),
    templates: {
      header: '<h3 class="suggest-header league-name">Diva</h3>',
      suggestion: (data) => {
        console.log('diva: ', data);
        return `
        <a href="">
          <div class="my-suggest row">
            <div class="media">
              <div class="pull-left">
                <div class="my-suggest-image" style="background-image: url(${imgFallback(data.image)});"></div>
              </div>
              <div class="media-body">
                ${titleText(data.name)}
                <p class="media-heading"><small>${titleText(data.kana)}</small></p>
              </div>
            </div>
          </div>
        </a>
        `;
      },
    }
  }, {
    name: 'tag-suggest',
    displayKey: 'value',
    limit: limit,
    source: tagSuggest.ttAdapter(),
    templates: {
      header: '<h3 class="suggest-header league-name">Tag</h3>',
      suggestion: (data) => {
        // console.log('tag:', data);
        return `
        <a href="">
          <div class="my-suggest row">
            <div class="media">
              <div class="pull-left">
                <div class="my-suggest-image" style="background-image: url();"></div>
              </div>
              <div class="media-body">
                ${titleText(data.value)}
                <p class="media-heading"><small>${titleText(data.value)}</small></p>
              </div>
            </div>
          </div>
        </a>
        `;
      }
    }
  }, {
    name: 'footer-suggest',
    displayKey: 'value',
    source: footerSuggest.ttAdapter(),
    templates: {
      suggestion: (data) => "<span class='clearfix'></span>",
      footer: (data) => {
        // console.log('footer: ', data);
        return `
        <a href="/search?=${data.query}">
          <div class="my-suggest my-footer">
            <i class="fa fa-search" aria-hidden="true"></i>
            "<strong>${queryText(data.query)}</strong>", See all resutls
          </div>
        </a>
        `;
      }
    }
  }
);
});


})($);
