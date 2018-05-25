import MainView from './main';
import c3 from "c3";

export default class View extends MainView {
  
  static get csrf() {
    return $("meta[name=\"csrf\"]").attr("content");
  }

  mount() {
    super.mount();

    $('.share-shorten-url').on('click', this.shorten);

    let country1Amount = $("#chart-donut").attr("country1-amount");
    let country2Amount = $("#chart-donut").attr("country2-amount");
    let country3Amount = $("#chart-donut").attr("country3-amount");
    let country1Name = $("#chart-donut").attr("country1-name");
    let country2Name = $("#chart-donut").attr("country2-name");
    let country3Name = $("#chart-donut").attr("country3-name");

      var chart = c3.generate({
          bindto: '#chart-donut', // id of chart wrapper
          data: {
            columns: [
                // each columns data
              ['data1', country1Amount],
              ['data2', country2Amount],
              ['data3', country3Amount]
            ],
            type: 'donut', // default type of chart
            colors: {
              'data1': "#5eba00",
              'data2': "#fd9644",
              'data3': "#a55eea"
            },
            names: {
                // name of each serie
              'data1': country1Name,
              'data2': country2Name,
              'data3': country3Name
            }
          },
          axis: {
          },
          legend: {
              show: false, //hide legend
          },
          padding: {
            bottom: 0,
            top: 0
          },
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
