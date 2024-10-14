import { api, LightningElement } from 'lwc';

export default class DisplayApod extends LightningElement {
  @api apod;
  @api refreshApod;

  get isImage() {
    return this.apod && this.apod.Media_Type__c === 'image';
  }
}