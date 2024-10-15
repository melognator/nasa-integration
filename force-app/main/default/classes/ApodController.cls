/**
 * This class is used by the Lightning web components to interact with the APOD API.
 */
public with sharing class ApodController {
    @testVisible
    private static Boolean shouldThrowException = false;

    /**
     * Method to throw an exception if the 'shouldThrowException' flag is set to true.
     * 
     * @see ApodControllerTest
     */
    private static void throwException () {
        if (shouldThrowException) {
            throw new AuraHandledException('Expected exception');
        }
    }

    @AuraEnabled(cacheable=true)
    /**
     * Method to get the Astronomy Picture of the Day (APOD) for today.
     * 
     * @return The APOD record for today as a Apod__c object
     */
    public static Apod__c getTodayApod(){
        try {
            throwException();
            Apod__c todayApod = [Select Id, Name, Copyright__c, Date__c, Explanation__c, HDURL__c, Media_Type__c, URL__c from Apod__c WHERE Date__c = Today];
            return todayApod;
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    /**
     * Method to get all the Astronomy Picture of the Day (APOD) records.
     * 
     * @return A list of APOD records as a list of Apod__c objects
     */
    public static List<Apod__c> getAllApods(){
        try {
            throwException();
            List<Apod__c> allApods = [Select Id, Name, Copyright__c, Date__c, Explanation__c, HDURL__c, Media_Type__c, URL__c from Apod__c ORDER BY Date__c DESC];
            return allApods;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    /**
     * Method to get the Astronomy Picture of the Day (APOD) for today.
     * It's used in case the Scheduler is not working.
     */
    public static Boolean retrieveTodayApod() {
        try {
            throwException();
            ApodIntegration.getApod();
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    /**
     * Method to get the Astronomy Picture of the Day (APOD) for a specific date.
     * 
     * @param apodDate The date for which to get the APOD
     * @return The APOD record for the specified date as a Apod__c object
     */
    public static void getApodWithDate(Date apodDate) {
        try {
            throwException();
            ApodIntegration.getApodWithDate(apodDate);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    /**
     * Method to get the Astronomy Picture of the Day (APOD) records for a date range.
     * 
     * @param startDate The start date of the range
     * @param endDate The end date of the range
     * @return A string with the date range, this was used for testing purposes, could as well be rewritten to void
     */
    public static String getApodsWithDates(Date startDate, Date endDate){
        try {
            throwException();
            ApodIntegration.getApodsWithDates(startDate, endDate);
            return startDate.format() + ' - ' + endDate.format(); // Formato sin hora
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}