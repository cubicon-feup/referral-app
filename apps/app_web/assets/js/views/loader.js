import MainView    from './main';
import UserView from './user';
import PageView from './page';
import InfluencerView from './influencer';
import PaymentView from './payment';

// Collection of specific view modules
const views = {
    UserView,
    PageView,
    InfluencerView,
    PaymentView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
