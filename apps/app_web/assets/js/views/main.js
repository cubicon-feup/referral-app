export default class MainView {
    mount() {
      // This will be executed when the document loads...
      this.baseUrl = window.location.protocol + "//" + window.location.host;
  
      this.csrf = document.querySelector("meta[name=csrf]").content;
      
    }
  
  
    unmount() {
      // This will be executed when the document unloads...
  
    }
  }
  