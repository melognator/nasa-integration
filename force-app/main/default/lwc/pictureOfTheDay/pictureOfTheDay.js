import getTodayApod from '@salesforce/apex/ApodController.getTodayApod';
import { LightningElement, wire } from 'lwc';

export default class PictureOfTheDay extends LightningElement {

  @wire(getTodayApod)
  apod;

  handleRefresh() {
    refreshApex(this.apod);
  }

}