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
