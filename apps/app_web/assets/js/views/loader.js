import MainView    from './main';
import UserView from './user';
import PageView from './page';
import ContractView from './contract';
import PaymentView from './payment';
import VoucherView from './voucher';
import BrandView from './brand';

// Collection of specific view modules
const views = {
    UserView,
    PageView,
    ContractView,
    PaymentView,
    VoucherView,
    BrandView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
