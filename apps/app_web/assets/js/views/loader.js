import MainView    from './main';
import UserView from './user';
import PageView from './page';

// Collection of specific view modules
const views = {
    UserView,
    PageView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
