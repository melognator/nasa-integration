import getTodayApod from '@salesforce/apex/ApodController.getTodayApod';
import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';

export default class PictureOfTheDay extends LightningElement {

  @wire(getTodayApod)
  apod;

  get loaded() {
    return this.apod.data || this.apod.error || this.apod.data === null;
  }

  handleRefresh() {
    refreshApex(this.apod);
  }

}