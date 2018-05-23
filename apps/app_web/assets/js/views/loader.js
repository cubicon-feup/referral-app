import MainView    from './main';
import UserView from './user';
import PageView from './page';
import InfluencerView from './influencer';
import PaymentView from './payment';
import VoucherView from './voucher';
import BrandView from './brand';

// Collection of specific view modules
const views = {
    UserView,
    PageView,
    InfluencerView,
    PaymentView,
    VoucherView,
    BrandView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
