import MainView from './main';

export default class View extends MainView {


  mount() {
    super.mount();

    $('.share-shorten-url').on('click', this.shorten);


    $('#voucher_price_rule').selectize({
      create: false,
      sortField: {
        field: 'text',
        direction: 'asc'
      },
      dropdownParent: 'body'
    });

    $('#voucher_discount_type').change(function() {
      if (this.value === 'free_shipping') {
        $("#discount_value_group").hide();
        $("#voucher_discount_value").prop('required', false);


      } else if (this.value === 'fixed_amount') {
        $("#discount_value_group").show();
        $("#voucher_discount_value").prop('required', true);
      } else if (this.value === 'percentage') {
        $("#discount_value_group").show();
        $("#voucher_discount_value").prop('required', true);
      };
    });

    $('#radial_amount').click(function() {
      $('#minimun_amount_group').show()
      $('#minimun_items_group').hide()
    });

    $('#radial_items').click(function() {
      $('#minimun_amount_group').hide()
      $('#minimun_items_group').show()
    });

    $('#radial_none').click(function() {
      $('#minimun_amount_group').hide()
      $('#minimun_items_group').hide()
    });

    $('#usage_limit_checkbox').click(function() {
      $('#usage_limit').toggle()
    });
    if ($('#voucher_discount_type').val() === 'free_shipping') {
      $("#discount_value_group").hide();
    }

    if ($('#voucher_add_price_rule').prop('checked')) {
      $('#select-beast-div').show()
    }

    $('#voucher_add_price_rule').click(function() {
      $('#select-beast-div').toggle()
      if ($('#voucher_add_price_rule').prop('checked')) {
        $('#voucher_price_rule').prop('required', true);
        $('#voucher_discount_value').prop('required', '');
      } else {
        $('#voucher_price_rule').prop('required', '');
      }
    });

    $(function() {
      $('input[name="voucher[start_date]"]').daterangepicker({
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
        },

        function(start, label) {
          var drp = $('input[name="voucher[end_date]"]').data('daterangepicker');
          drp.minDate = start;

        });
    });

    $('input[name="voucher[end_date]"]').daterangepicker({
      singleDatePicker: true,
      showDropdowns: true,
      autoUpdateInput: false,
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

    $('input[name="voucher[end_date]"]').on('apply.daterangepicker', function(ev, picker) {
      $(this).val(picker.startDate.format('YYYY-MM-DD'));
    });

    $('input[name="voucher[end_date]"]').on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
    });

    $('#end_date_checkbox').click(function() {
      $('#end_date_section').toggle();
      $('input[name="voucher[end_date]"]').val('');
    });

    $('#voucher_price_rule').change(function() {
      let id = $('#voucher_price_rule').find(":selected").val()
      let brand_id = $("meta[name=\"brand_id\"]").attr("content");
      let url = "../../../../api/price_rule/" + brand_id + "/" + id;
      $.ajax({
        type: "GET",
        url: url,
        data: {
          format: 'json'
        },
        cache: false,
        success: function(data) {
          let value_type = data["price_rule"]["value_type"]
          let discount_value = data["price_rule"]["value"]

          document.getElementById('voucher_discount_type').value = value_type;
          document.getElementById('voucher_discount_type').disabled = true;
          document.getElementById('voucher_discount_value').value = discount_value;
          document.getElementById('voucher_discount_value').disabled = true;
        },
        error: function() {}
      });
    });

    $('#reward_type').change(function() {
      if (this.value === 'none') {
        $("#number_sales_group").hide();
        $("#amount_sales_group").hide();
        $("#comission_group").hide();
        $("#monthly_group").hide();


      } else if (this.value === 'sales') {
        $("#number_sales_group").show();
        $("#amount_sales_group").show();
        $("#comission_group").hide();
        $("#monthly_group").hide();
      } else if (this.value === 'comission') {
        $("#number_sales_group").hide();
        $("#amount_sales_group").hide();
        $("#comission_group").show();
        $("#monthly_group").hide();
      } else if (this.value === 'monthly') {
        $("#number_sales_group").hide();
        $("#amount_sales_group").hide();
        $("#comission_group").hide();
        $("#monthly_group").show();
      }
    });
  }

  shorten() {

    let link = $(this);
    let discountCode = $(this).attr("discount-code");
    let voucherId = $(this).attr("voucher-id");

    $.ajax({
      type: 'POST',
      url: '/api/shorten',
      headers: {
        "X-CSRF-TOKEN": View.csrf
      },
      data: {
        discount_code: discountCode,
        voucher_id: voucherId
      },
      success: (response) => {

        let baseUrl = window.location.protocol + "//" + window.location.host;
        let shortUrl = baseUrl + "/promo/" + response.shortcode;

        $(this).html(shortUrl);
        $(this).attr('href', shortUrl);
        $(this).removeClass('share-shorten-url');
      }
    });
  }

  unmount() {
    super.unmount();
  }

}
