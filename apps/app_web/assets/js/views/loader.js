import MainView    from './main';
import UserView from './user';
import PageView from './page';
import InfluencerView from './influencer';

// Collection of specific view modules
const views = {
    UserView,
    PageView,
    InfluencerView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
