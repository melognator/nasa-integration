/**
 * Test class for ApodService
 * 
 * @see ApodService
 */
@isTest
public with sharing class ApodServiceTest {
    
    @TestSetup
    static void makeData(){
        // create 2 Apod__c records
        List<Apod__c> apods = new List<Apod__c>();
        apods.add(new Apod__c(Name='apod1', ApodID__c = 'apod1', Date__c = Date.today()));
        apods.add(new Apod__c(Name='apod2', ApodID__c = 'apod2', Date__c = Date.today()));
        insert apods;
    }

    @isTest
    static void testCreateApods(){
        // create 2 Apod__c records
        List<Apod__c> apods = new List<Apod__c>();
        apods.add(new Apod__c(Name='apod3', ApodID__c = 'apod3', Date__c = Date.today()));
        apods.add(new Apod__c(Name='apod4', ApodID__c = 'apod4', Date__c = Date.today()));
        ApodService.createApods(apods);
        System.assertEquals(4, [SELECT count() FROM Apod__c]);
    }

    @isTest
    static void testCreateApodsWithDuplicates(){
        // create 2 Apod__c records
        List<Apod__c> apods = new List<Apod__c>();
        apods.add(new Apod__c(Name='apod1', ApodID__c = 'apod1', Date__c = Date.today()));
        apods.add(new Apod__c(Name='apod3', ApodID__c = 'apod3', Date__c = Date.today()));
        ApodService.createApods(apods);
        System.assertEquals(3, [SELECT count() FROM Apod__c]);
    }

    @isTest
    static void testDeleteApods(){
        List<Apod__c> apods = [SELECT Id FROM Apod__c];
        ApodService.deleteApods(apods);
        System.assertEquals(0, [SELECT count() FROM Apod__c]);
    }
}