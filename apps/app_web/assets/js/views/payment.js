import MainView from './main';

export default class View extends MainView {
  mount() {
    super.mount();

    $(function () {

      var start = moment();

      function cb(start) {
        $('input[name="payment[deadline_date]"]').val(start.format('YYYY-MM-DD'));
      }

      $('input[name="payment[deadline_date]"]').daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        minDate: moment(),
        ranges: {
          'Today': [moment(), moment()],
          'Tomorrow': [moment().add(1, 'days'), moment()],
          'One Week': [moment().add(7, 'days'), moment()],
          'One Month': [moment().add(1, 'months'), moment()]
        }
      }, cb);

      cb(start);
    });

    $("select").change(function () {
      var $select = $(this);
      var c = $select.val();
      $select.removeClass("pending cancelled complete").addClass(c);

      var $form = $select.parents(".status")[0]
      $.ajax({
        url: $form.getAttribute('action'),
        type: "PUT",
        data: $select.parents(".status").serialize(),
        success: function (data) {
          console.log("success");
        }
      });
    });


    $("select").each(function () {
      var $select = $(this);
      var c = $select.val();
      $select.removeClass("pending cancelled complete").addClass(c);
    });

    $('input[type=radio][name=view]').on('change', function () {
      switch ($(this).val()) {
        case 'board':
          $("#list").hide();
          $("#board").show();
          break;
        case 'list':
          $("#board").hide();
          $("#list").show();
          break;
      }
    });

    $("#board").hide();
    $("#list").show();

    console.log('Tramado3');

    $('#select-influencer').selectize({
      create: true,
      render: {
        option: function (data) {
          return '<div>' +
            //'<span class="image"><img src="' + data.image + '" alt=""></span>' +
            '<span class="title">' + data.text + '</span>' +
            '</div>';
        },
        item: function (data) {
          return '<div>' +
            //'<span class="image"><img src="' + data.image + '" alt=""></span>' +
            data.text + 23 +
            '</div>';
        }
      }
    });
    console.log('Tramado2');

  }
  unmount() {
    super.unmount();
  }
}