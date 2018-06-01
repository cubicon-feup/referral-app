import MainView from './main';

export default class View extends MainView {
  mount() {
    super.mount();

    $(function () {

      $('input[name="payment[deadline_date]"]').daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        minDate: moment(),
        ranges: {
          'Today': [moment(), moment()],
          'Tomorrow': [moment().add(1, 'days'), moment()],
          'One Week': [moment().add(7, 'days'), moment()],
          'One Month': [moment().add(1, 'months'), moment()]
        },
        locale: {
          format: 'YYYY-MM-DD'
        }
      });

      calculate_deadline();
    });

    var change_view = function (view) {
      switch (view) {
        case 'board':
          $("#list").hide();
          $("#board").show();
          break;
        case 'list':
          $("#board").hide();
          $("#list").show();
          break;
      }
    }

    var change_deadline = function (date) {
      $('input[name="payment[deadline_date]"]').val(date.format('YYYY-MM-DD'));
    }

    var calculate_deadline = function () {
      var influencer = $("#select-influencer");
      var option = influencer.find("option[value=" + influencer.val() + "]")
      var date = moment().add(option.data("payment-period"), 'days')
      change_deadline(date)
    }

    var update_status_color = function ($select) {
      var c = $select.val();
      $select.removeClass("pending cancelled complete").addClass(c);
    }

    $('input[type=radio][name=view]').on('change', function () {
      change_view($(this).val())
    });

    $("#select-influencer").change(function () {
      calculate_deadline();
    });

    $(".status select").change(function () {
      var $select = $(this);
      update_status_color($select);

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


    //On init
    change_view('list');
    $(".status select").each(function () {
      update_status_color($(this));
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
             data.text +
             '</div>';
         }
       }
    });
    console.log('Tramado3');

  }
  unmount() {
    super.unmount();
  }
}
