/**
 * Test class for ApodController
 * 
 * @see ApodController
 */
@isTest
public class ApodControllerTest {

    @isTest
    static void testGetTodayApod() {
        // Test getting today's APOD when it exists
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

        Date today = Date.today();
        Apod__c todayApod = new Apod__c(Name = 'Mock title', Date__c = today, Explanation__c = 'Mock explanation', 
                                        URL__c = 'https://mock-url.com', Media_Type__c = 'image', 
                                        HDURL__c = 'https://mock-hd-url.com', Copyright__c = 'Mock copyright');
        insert todayApod;
        
        Test.startTest();
        Apod__c result = ApodController.getTodayApod();
        Test.stopTest();
        
        System.assertEquals('Mock title', result.Name);
        System.assertEquals(today, result.Date__c);
        System.assertEquals('Mock explanation', result.Explanation__c);
        System.assertEquals('https://mock-url.com', result.URL__c);
    }

    @isTest
    static void testGetTodayApod_NoRecord() {
        // Test exception when no APOD exists for today
        Test.startTest();
        try {
            ApodController.getTodayApod();
            System.assert(false, 'Expected exception because no APOD for today.');
        } catch (AuraHandledException e) {
          
        }
        Test.stopTest();
    }

    @isTest
    static void testGetAllApods() {
        // Test getting all APODs
        List<Apod__c> apods = new List<Apod__c>{
            new Apod__c(Name = 'Mock title 1', Date__c = Date.today().addDays(-1), Explanation__c = 'Explanation 1', 
                        URL__c = 'https://mock-url1.com', Media_Type__c = 'image', HDURL__c = 'https://mock-hd-url1.com', Copyright__c = 'Mock copyright 1'),
            new Apod__c(Name = 'Mock title 2', Date__c = Date.today().addDays(-2), Explanation__c = 'Explanation 2', 
                        URL__c = 'https://mock-url2.com', Media_Type__c = 'image', HDURL__c = 'https://mock-hd-url2.com', Copyright__c = 'Mock copyright 2')
        };
        insert apods;
        
        Test.startTest();
        List<Apod__c> result = ApodController.getAllApods();
        Test.stopTest();
        
        System.assertEquals(2, result.size());
        System.assertEquals('Mock title 1', result[0].Name);
        System.assertEquals('Mock title 2', result[1].Name);
    }

    @isTest
    static void testGetApodWithDate() {
        // Test getting APOD for a specific date
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());
        
        Date testDate = Date.newInstance(2024, 10, 10);
        
        Test.startTest();
        ApodController.getApodWithDate(testDate);
        Test.stopTest();
        
        Apod__c apodRecord = [SELECT Name, Date__c FROM Apod__c WHERE Date__c = :testDate LIMIT 1];
        System.assertEquals('Mock title', apodRecord.Name);
        System.assertEquals(testDate, apodRecord.Date__c);
    }

    @isTest
	static void testGetApodsWithDates() {
    // Test getting APODs within a date range
    Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());

    Date startDate = Date.newInstance(2024, 10, 1);
    Date endDate = Date.newInstance(2024, 10, 9);
    
    Test.startTest();
    String result = ApodController.getApodsWithDates(startDate, endDate);
    Test.stopTest();
    
    // Verificar que el registro fue creado en el rango de fechas dado
    List<Apod__c> apodRecords = [SELECT Name, Date__c FROM Apod__c WHERE Date__c >= :startDate AND Date__c <= :endDate];
        System.assertEquals(1, apodRecords.size()); // Suponiendo que el mock devuelve solo un registro
    }

    @isTest
    static void testGetTodayApodException() {
        // Test throwing an exception
        ApodController.shouldThrowException = true;
        
        Test.startTest();
        try {
            ApodController.getTodayApod();
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }
     @isTest
    static void testGetAllApodsException() {
        // Test throwing an exception
        ApodController.shouldThrowException = true;
        
        Test.startTest();
        try {
            ApodController.getAllApods();
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }
         @isTest
    static void testgetApodWithDateException() {
        // Test throwing an exception
        ApodController.shouldThrowException = true;
        
        Test.startTest();
        try {
            ApodController.getApodWithDate(Date.Today());
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }
             @isTest
    static void testgetApodsWithDatesException() {
        // Test throwing an exception
        ApodController.shouldThrowException = true;
        
        Test.startTest();
        try {
            ApodController.getApodsWithDates(Date.Today(), Date.Today());
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }
}