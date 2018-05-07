import MainView from './main';

export default class View extends MainView {

  static get csrf() {
    return $("meta[name=\"csrf\"]").attr("content");
  }

  mount() {
    super.mount();

    $('.share-shorten-url').on('click', this.shorten);

  }

  shorten() {

    let link = $(this);
    let discountCode = $(this).attr("discount-code");

    $.ajax({
      type: 'POST',
      url: '/api/shorten',
      headers: {
        "X-CSRF-TOKEN": View.csrf
      },
      data: {
        discount_code: discountCode,
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