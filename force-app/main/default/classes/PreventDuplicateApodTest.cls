@isTest
public class PreventDuplicateApodTest {
    
    @isTest
    static void testInsertApodWithUniqueDate() {
        // Insert a record with a unique date
        Apod__c apod1 = new Apod__c(Date__c = Date.newInstance(2023, 10, 1));
        insert apod1;
        
        // Verify the record was inserted successfully
        Apod__c insertedApod = [SELECT Id, Date__c FROM Apod__c WHERE Id = :apod1.Id];
        System.assertEquals(Date.newInstance(2023, 10, 1), insertedApod.Date__c);
    }
    
    @isTest
    static void testInsertApodWithDuplicateDate() {
        // Insert the first record
        Apod__c apod1 = new Apod__c(Date__c = Date.newInstance(2023, 10, 1));
        insert apod1;
        
        // Try to insert a second record with the same date, which should fail
        Apod__c apod2 = new Apod__c(Date__c = Date.newInstance(2023, 10, 1));
        try {
            insert apod2;
            // This line should not be reached, as an exception should be thrown
            System.assert(false, 'Expected a DMLException due to duplicate date');
        } catch (DmlException e) {
            // Verify the correct error message
            System.assert(e.getMessage().contains('A record with this date already exists'));
        }
    }
    
    @isTest
    static void testUpdateApodWithUniqueDate() {
        // Insert a record
        Apod__c apod1 = new Apod__c(Date__c = Date.newInstance(2023, 10, 1));
        insert apod1;
        
        // Insert another record with a different date
        Apod__c apod2 = new Apod__c(Date__c = Date.newInstance(2023, 10, 2));
        insert apod2;
        
        // Try to update the second record with a new unique date
        apod2.Date__c = Date.newInstance(2023, 10, 3);
        update apod2;
        
        // Verify the update was successful
        Apod__c updatedApod = [SELECT Id, Date__c FROM Apod__c WHERE Id = :apod2.Id];
        System.assertEquals(Date.newInstance(2023, 10, 3), updatedApod.Date__c);
    }
    
    @isTest
    static void testUpdateApodWithDuplicateDate() {
        // Insert two records with unique dates
        Apod__c apod1 = new Apod__c(Date__c = Date.newInstance(2023, 10, 1));
        insert apod1;
        
        Apod__c apod2 = new Apod__c(Date__c = Date.newInstance(2023, 10, 2));
        insert apod2;
        
        // Try to update the second record to have the same date as the first
        apod2.Date__c = Date.newInstance(2023, 10, 1);
        try {
            update apod2;
            // This line should not be reached, as an exception should be thrown
            System.assert(false, 'Expected a DMLException due to duplicate date');
        } catch (DmlException e) {
            // Verify the correct error message
            System.assert(e.getMessage().contains('A record with this date already exists'));
        }
    }
}