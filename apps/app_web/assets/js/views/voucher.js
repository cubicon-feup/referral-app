import MainView from './main';

export default class View extends MainView {
  
  static get csrf() {
    return $("meta[name=\"csrf\"]").attr("content");
  }
  
  mount() {
    super.mount();

    $('.share-shorten-url').on('click', View.retriveShortUrl);

   
  }

  static retriveShortUrl() {

    let fullUrl = 

    $.ajax({
      type: 'POST',
      url: '/api/shorten/new',
      data: {
        url: fullUrl
      },
      headers: {
          "X-CSRF-TOKEN": View.csrf
      },
      success: function (message) {
          
      }
    });
  }
  unmount() {
    super.unmount();
  }

}
