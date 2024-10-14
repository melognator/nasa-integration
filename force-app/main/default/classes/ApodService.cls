/**
 * This class provides methods to interact with the Apod__c object in the database.
 */
public with sharing class ApodService {
    /**
     * This method receives a list of Apod__c records and upserts them into the database.
     * If the record already exists, it will update the existing record.
     * 
     * @param apods - List of Apod__c records to be upserted
     * @return List of Apod__c records that were upserted
     */
    public static Apod__c[] createApods(Apod__c[] apods){
        Set<String> apodIds = new Set<String>();
        for(Apod__c apod : apods){
            apodIds.add(apod.ApodID__c);
        }
        List<Apod__c> existingApods = [SELECT Id, ApodID__c FROM Apod__c WHERE ApodID__c IN :apodIds];
        Map<String, Apod__c> apodMap = new Map<String, Apod__c>();
        for(Apod__c existingApod : existingApods){
            apodMap.put(existingApod.ApodID__c, existingApod);
        }
        for (Apod__c apod : apods){
            Apod__c existingApod = apodMap.get(apod.ApodID__c);
            if(existingApod != null){
                apod.Id = existingApod.Id;
            }
        }
        upsert apods;
        return apods;
    }

    /**
     * This method receives a list of Apod__c records and deletes them from the database.
     */
    public static void deleteApods(Apod__c[] apods){
        delete apods;
    }
}