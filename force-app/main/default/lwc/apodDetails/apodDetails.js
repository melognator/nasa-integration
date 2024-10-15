import { LightningElement, api, wire } from 'lwc';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Apod__c.Name';
import DATE_FIELD from '@salesforce/schema/Apod__c.Date__c';
import EXPLANATION_FIELD from '@salesforce/schema/Apod__c.Explanation__c';
import HDURL_FIELD from '@salesforce/schema/Apod__c.HDURL__c';
import URL_FIELD from '@salesforce/schema/Apod__c.URL__c';
import MEDIA_TYPE_FIELD from '@salesforce/schema/Apod__c.Media_Type__c';

export default class ApodDetails extends LightningElement {
  apod = null;

  @api recordId;
  @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD, DATE_FIELD, EXPLANATION_FIELD, HDURL_FIELD, URL_FIELD, MEDIA_TYPE_FIELD] })
  getApod({ error, data }) {
    if (data) {
      this.apod = {
        Name: getFieldValue(data, NAME_FIELD),
        Date__c: getFieldValue(data, DATE_FIELD),
        Explanation__c: getFieldValue(data, EXPLANATION_FIELD),
        HDURL__c: getFieldValue(data, HDURL_FIELD),
        URL__c: getFieldValue(data, URL_FIELD),
        Media_Type__c: getFieldValue(data, MEDIA_TYPE_FIELD)
      };
    } else if (error) {
      console.error('Error loading APOD');
    }
  }

  get loaded() {
    return this.apod !== null;
  }
}