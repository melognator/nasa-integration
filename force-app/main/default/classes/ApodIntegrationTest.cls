/**
 * Test class for ApodIntegration
 * 
 * @see ApodIntegration
 */
@isTest
public class ApodIntegrationTest {

    // 1. Test to validate fetching a single APOD and checking that the record is inserted correctly
    @isTest
    static void testGetApod() {
        // Simulate the callout using the mock
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        Test.startTest();
        ApodIntegration.getApod(); // Call method to fetch the APOD
        Test.stopTest();
        
        // Validate that the record was inserted correctly in the database
        Apod__c apodRecord = [SELECT Name, Date__c, Explanation__c, URL__c, Media_Type__c, HDURL__c, Copyright__c FROM Apod__c LIMIT 1];
        
        System.assertEquals('Mock title', apodRecord.Name);
        System.assertEquals(Date.newInstance(2024, 10, 9), apodRecord.Date__c);
        System.assertEquals('Mock explanation', apodRecord.Explanation__c);
        System.assertEquals('https://apod.nasa.gov/apod/image/2410/M106_Obaidly_960.jpg', apodRecord.URL__c);
        System.assertEquals('image', apodRecord.Media_Type__c);
        System.assertEquals('https://apod.nasa.gov/apod/image/2410/M106_Obaidly_3500.jpg', apodRecord.HDURL__c);
        System.assertEquals('Mock copy', apodRecord.Copyright__c);
    }
    
    // 2. Test to validate that the CalloutException is thrown when an error occurs
    @isTest
    static void testGetResultWithError() {
        // Simulate the callout using the mock
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        String endpoint = 'https://api.nasa.gov/planetary/apod?error=true'; // Endpoint that triggers the error

        Test.startTest();
        try {
            ApodIntegration.getResult(endpoint);
            System.assert(false, 'An exception was expected but not thrown.');
        } catch (CalloutException e) {
            System.assertEquals('Error in response', e.getMessage(), 'The exception message does not match.');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetResultsWithError() {
        // Simulate the callout using the mock
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        String endpoint = 'https://api.nasa.gov/planetary/apod?error=true'; // Endpoint that triggers the error

        Test.startTest();
        try {
            ApodIntegration.getResults(endpoint);
            System.assert(false, 'An exception was expected but not thrown.');
        } catch (CalloutException e) {
            System.assertEquals('Error in response', e.getMessage(), 'The exception message does not match.');
        }
        Test.stopTest();
    }
    
    // 3. Test fetching an APOD with a specific date and validate that the record is correctly inserted
    @isTest
    static void testGetApodWithDate() {
        // Simulate the callout using the mock
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        Date apodDate = Date.newInstance(2024, 10, 9); // APOD date to fetch
        
        Test.startTest();
        ApodIntegration.getApodWithDate(apodDate); // Call method to fetch the APOD with date
        Test.stopTest();

        // Validate that the record with the correct date was inserted
        Apod__c apodRecord = [SELECT Name, Date__c, Explanation__c, URL__c, Media_Type__c, HDURL__c, Copyright__c FROM Apod__c WHERE Date__c = :apodDate LIMIT 1];
        
        System.assertEquals('Mock title', apodRecord.Name);
        System.assertEquals(apodDate, apodRecord.Date__c);
        System.assertEquals('Mock explanation', apodRecord.Explanation__c);
        System.assertEquals('https://apod.nasa.gov/apod/image/2410/M106_Obaidly_960.jpg', apodRecord.URL__c);
        System.assertEquals('image', apodRecord.Media_Type__c);
        System.assertEquals('https://apod.nasa.gov/apod/image/2410/M106_Obaidly_3500.jpg', apodRecord.HDURL__c);
        System.assertEquals('Mock copy', apodRecord.Copyright__c);
    }

    // 4. Test fetching multiple APODs between two dates and validating the correct insertion of records
    @isTest
    static void testGetApodsWithDates() {
        // Simulate the callout using the mock
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        Date startDate = Date.newInstance(2024, 10, 1);
        Date endDate = Date.newInstance(2024, 10, 9);
        
        Test.startTest();
        ApodIntegration.getApodsWithDates(startDate, endDate); // Call method to fetch APODs for a date range
        Test.stopTest();
        
        // Verify that records were created correctly
        List<Apod__c> apodRecords = [SELECT Name, Date__c FROM Apod__c];
        System.assertEquals(2, apodRecords.size()); // Mock simulates 2 records
        System.assertEquals('Mock title', apodRecords[0].Name);
    }

    // 5. Test the conversion of a list of objects into a list of maps (used for deserialization)
    @isTest
    static void testListConversion() {
        // Simulate the callout using the mock for multiple APODs
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        Date startDate = Date.newInstance(2024, 10, 1);
        Date endDate = Date.newInstance(2024, 10, 9);
        
        Test.startTest();
        List<Map<String, Object>> results = ApodIntegration.getResults(ApodIntegration.endPoint + '&start_date=' + startDate + '&end_date=' + endDate); // Call method to get the results as a list of maps
        Test.stopTest();
        
        // Validate that the list is not empty and contains the expected number of elements
        System.assert(results != null, 'The result list should not be null.');
        System.assertEquals(2, results.size()); // Mock simulates 2 records
        System.assertEquals('Mock title', results[0].get('title'));
    }

    // 6. Test creating multiple APOD records from API results and verifying their insertion
    @isTest
    static void testCreateMultipleApods() {
        // Simulate the callout using the mock
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        Date startDate = Date.newInstance(2024, 10, 1);
        Date endDate = Date.newInstance(2024, 10, 9);
        
        Test.startTest();
        ApodIntegration.getApodsWithDates(startDate, endDate); // Call method to create multiple APOD records
        Test.stopTest();
        
        // Verify that records were created correctly for the specified date range
        List<Apod__c> apodRecords = [SELECT Name, Date__c FROM Apod__c WHERE Date__c >= :startDate AND Date__c <= :endDate];
        System.assertEquals(1, apodRecords.size()); // Mock simulates only 1 record
        System.assertEquals('Mock title', apodRecords[0].Name);
    }
}