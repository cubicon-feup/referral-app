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
    console.log('Tramado');

  }
  unmount() {
    super.unmount();
  }
}