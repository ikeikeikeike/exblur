$(function() {
  $('.report-like').on('click', function() {
    const $btn = $(this).button('loading');

    $.ajax({
      method: "POST",
      url: $btn.data('href'),
      data: {_csrf_token: $btn.data('token')}
    })
    .done(msg => {
      setTimeout(_ => {
        $btn.button('reset')
            .removeClass('btn-default')
            .addClass('btn-success');

        setTimeout(_ => $btn.addClass('disabled'), 1000);
      }, 3000);

    });
  });

  $('.report-broken-link').on('click', function() {
    const $btn = $(this).button('loading');

    $.ajax({
      method: "POST",
      url: $btn.data('href'),
      data: {_csrf_token: $btn.data('token')}
    })
    .done(msg => {
      setTimeout(_ => {
        $btn.button('reset')
            .removeClass('btn-default')
            .addClass('btn-danger');

        setTimeout(_ => $btn.addClass('disabled'), 1000);
      }, 3000);
    });
  });

});
