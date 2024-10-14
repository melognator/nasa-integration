import { LightningElement, wire } from 'lwc';
import { refreshApex } from "@salesforce/apex";
import getAllApods from '@salesforce/apex/ApodController.getAllApods';

export default class ApodTable extends LightningElement {

    // mocked data
    @wire(getAllApods)
    apods;

    handleRefresh() {
        refreshApex(this.apods);
    }

    columns = [
        { label: 'Date', fieldName: 'Date__c', type: 'date-local' },
        { label: 'Title', fieldName: 'Name', type: 'text' },
        { label: 'Description', fieldName: 'Explanation__c', type: 'text', wrapText: true },
        { label: 'URL', fieldName: 'URL__c', type: 'url' }
    ];
}