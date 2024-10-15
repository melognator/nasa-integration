import { api, LightningElement } from 'lwc';
import retrieveTodayApod from '@salesforce/apex/ApodController.retrieveTodayApod';

export default class DisplayApod extends LightningElement {
  @api apod;
  @api loaded = false;
  @api pictureOfTheDay = false;

  get isImage() {
    return this.apod && this.apod.Media_Type__c === 'image';
  }

  refreshApod () {
    this.dispatchEvent(new CustomEvent('refreshapod'));
  }

  async retrieveApod() {
    this.loaded = false;
    await retrieveTodayApod();
    // check if apod is not null every 1 second, till it is not null, maximum 10 seconds
    let count = 0;
    while (count < 20) {
      this.refreshApod();
      await new Promise(resolve => setTimeout(resolve, 500));
      if (this.apod) {
        break;
      }
      count++;
    }
    this.loaded = true;
  };
}