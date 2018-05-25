import MainView from './main';

export default class View extends MainView {
  mount() {
    super.mount();
    $('input[name="dates"]').daterangepicker();

    $(function() {

        var start = moment().subtract(29, 'days');
        var end = moment();
    
        function cb(start, end) {
            $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        }
    
        $('#reportrange').daterangepicker({
            startDate: start,
            endDate: end,
            ranges: {
               'Today': [moment(), moment()],
               'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
               'Last 7 Days': [moment().subtract(6, 'days'), moment()],
               'Last 30 Days': [moment().subtract(29, 'days'), moment()],
               'This Month': [moment().startOf('month'), moment().endOf('month')],
               'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        }, cb);
    
        cb(start, end);
    
    });

    
    var change_view = function (view) {
      switch (view) {
        case 'payments':
          $("#voucher_list").hide();
          $("#payment_board").show();
          break;
        case 'vouchers':
          $("#voucher_list").show();
          $("#payment_board").hide();
          break;
      }
    }    
    $('input[type=radio][name=view]').on('change', function () {
      change_view($(this).val())
    });
    change_view('payments');
  }

  unmount() {
    super.unmount();
  }

}
