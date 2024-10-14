/**
 * Test class for ApodSchedule
 * 
 * @see ApodSchedule
 */
@isTest
public with sharing class ApodScheduleTest {
    
    @isTest
    static void testSchedule() {
        Test.setMock(HttpCalloutMock.class, new ApodCalloutMock());
        Test.startTest();
        String sch = '0 0 0 15 3 ? 2030';
        String jobId = System.schedule('Test ApodSchedule', sch, new ApodSchedule());
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM CronTrigger WHERE Id = :jobId]);
    }
}