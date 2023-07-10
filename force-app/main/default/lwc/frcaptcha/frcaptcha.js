import { LightningElement } from 'lwc';

export default class Frcaptcha extends LightningElement {
    siteURL;
    greeting = 'World';

    changeHandler(event) {
    this.greeting = event.target.value;
  }
  connectedCallback() {
       this.siteURL = '/apex/friendlycaptcha';
    }
}