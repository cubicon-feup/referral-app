import MainView    from './main';
import UserView from './user';
import PageView from './page';
import InfluencerView from './influencer';
import VoucherView from './voucher';

// Collection of specific view modules
const views = {
    UserView,
    PageView,
    InfluencerView,
    VoucherView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
