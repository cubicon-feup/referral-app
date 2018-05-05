import MainView from './main';

export default class View extends MainView {
  mount() {
    super.mount();
    /*$('#select-influencer').selectize({
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
    });*/
    console.log('Tramado');
   
  }
  unmount() {
    super.unmount();
  }
}