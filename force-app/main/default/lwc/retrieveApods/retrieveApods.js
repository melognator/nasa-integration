import getApodsWithDates from '@salesforce/apex/ApodController.getApodsWithDates';
import { LightningElement } from 'lwc';

export default class RetrieveApods extends LightningElement {

  startDate;
  endDate;

  inputOnChange(event) {
    this[event.target.name] = event.target.value;
  }

  async handleRetrieve() {
    try {
      await getApodsWithDates({ startDate: this.startDate, endDate: this.endDate });
      this.startDate = '';
      this.endDate = '';
    } catch (error) {
      console.error('Error retrieving APODs', error);
    }
  }

}