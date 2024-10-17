trigger PreventDuplicateApod on Apod__c (before insert, before update) {
    // Create a set to store the dates of the records being inserted or updated
    Set<Date> apodDates = new Set<Date>();
    
    for (Apod__c apod : Trigger.new) {
        // Ensure the date is not null
        if (apod.Date__c != null) {
            // For insert, always add the date; for updates, only if the date has changed
            if (Trigger.isInsert) {
                apodDates.add(apod.Date__c);
            } else if (Trigger.isUpdate && apod.Date__c != Trigger.oldMap.get(apod.Id).Date__c) {
                apodDates.add(apod.Date__c);
            }
        }
    }
    
    // Only query if there are dates to check
    if (!apodDates.isEmpty()) {
        // Query existing records that have the same dates
        // For insert: we don't need to exclude anything (no old records to update)
        // For update: exclude current records being updated
        List<Apod__c> existingApods;
        if (Trigger.isInsert) {
            existingApods = [
                SELECT Id, Date__c 
                FROM Apod__c 
                WHERE Date__c IN :apodDates
            ];
        } else if (Trigger.isUpdate) {
            existingApods = [
                SELECT Id, Date__c 
                FROM Apod__c 
                WHERE Date__c IN :apodDates
                AND Id NOT IN :Trigger.newMap.keySet()
            ];
        }
        
        // Create a set of existing dates to check for duplicates
        Set<Date> existingDates = new Set<Date>();
        for (Apod__c existingApod : existingApods) {
            existingDates.add(existingApod.Date__c);
        }
        
        // Check for duplicates and add an error if necessary
        for (Apod__c apod : Trigger.new) {
            if (apod.Date__c != null && existingDates.contains(apod.Date__c)) {
                apod.addError('A record with this date already exists: ' + apod.Date__c);
            }
        }
    }
}