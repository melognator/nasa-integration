/**
 * This class handles integration with NASA's APOD (Astronomy Picture of the Day) API.
 * It performs HTTP requests to retrieve astronomical image data and maps it to custom Apod__c objects.
 */
public with sharing class ApodIntegration{

    /** URL of the APOD API endpoint with an API key included.*/
    public static String endPoint = 'https://api.nasa.gov/planetary/apod?api_key=OIXQUfZYBM3xGoFanDdawMbg0IyYLJ9pu11uKEPu';
    
    /**
     * Makes an HTTP GET request to the given endpoint and returns the deserialized result as a Map.
     * Throws a CalloutException if the response status is not successful.
     * 
     * @param endPoint - API URL to send the request to.
     * @return A Map representing the JSON response from the API.
     */
    public static Map<String, Object> getResult (String endPoint) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // Check if the response status code is within the 200-299 range (success).
        if(!(response.getStatusCode() >= 200 && response.getStatusCode() < 300)) {
            CalloutException e = new CalloutException();
            e.setMessage('Error in response');
            throw e;
        }
        // Deserialize the response body into a Map and return it.
        Map<String, Object> apodResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            for(String key: apodResult.keySet()){
        }
        return apodResult;
    }

    /**
     * Makes an HTTP GET request to the given endpoint, retrieves a list of results, and returns it.
     * 
     * @param endPoint - API URL to send the request to.
     * @return A List of Maps representing the JSON response from the API.
     */
    public static List<Map<String, Object>> getResults(String endPoint){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // Check if the response status code is within the 200-299 range (success).
        if(!(response.getStatusCode() >= 200 && response.getStatusCode() < 300)) {
            CalloutException e = new CalloutException();
            e.setMessage('Error in response');
            throw e;
        }
        // Deserialize the response body into a List of Maps.
        List<Object> apodResults = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<Map<String, Object>> apodListMap = new List<Map<String, Object>>();
        for(Object apodResult: apodResults){
            apodListMap.add((Map<String, Object>)apodResult);
        }
        return apodListMap;
    }

    /**
     * Maps the API result into an Apod__c custom object.
     * 
     * @param result - Map containing the APOD data from the API response.
     * @return A new Apod__c object populated with data from the API result.
     */
    public static Apod__c mapApod(Map<String, Object> result){
        String name = (String)result.get('title');
        Date apodDate = Date.valueOf((String)result.get('date'));
        String explanation = (String)result.get('explanation');
        String url = (String)result.get('url');
        String hdurl = (String)result.get('hdurl');
        String mediaType = (String)result.get('media_type');
        String copyright = (String)result.get('copyright');
        String ApodID = 'Apod' + result.get('date');
        // Create and return a new Apod__c record with the mapped data.
        return new Apod__c(Name=name, Date__c=apodDate, Explanation__c=explanation, URL__c=url,Media_Type__c=mediaType, HDURL__c=hdurl, Copyright__c=copyright, ApodID__c=ApodID);
    }

    @future (callout = true)
    /**
     * Fetches the latest APOD data from the API and stores it in the Apod__c object.
     * This method is marked as future to allow asynchronous callouts.
     */
    public static void getApod() {
        Map<String, Object> result = getResult(endPoint);
        Apod__c newAPOD = mapApod(result);
        ApodService.createApods(new List<Apod__c>{newAPOD});
    }

    @future (callout = true)
    /**
     * Fetches APOD data for a specific date and stores it in the Apod__c object.
     * This method is marked as future to allow asynchronous callouts.
     * 
     * @param apodDate - The date for which to fetch the APOD data.
     */
    public static void getApodWithDate(Date apodDate){
        String formattedDate = apodDate.year() + '-' + apodDate.month() +'-'+ apodDate.day(); 
        Map<String, Object> result = getResult(endPoint + '&date=' + formattedDate);
        Apod__c newAPOD = mapApod(result);
        ApodService.createApods(new List<Apod__c>{newAPOD});
    }

    @future (callout = true)
    /**
     * Fetches APOD data for a range of dates and stores it in multiple Apod__c objects.
     * This method is marked as future to allow asynchronous callouts.
     * 
     * @param startDate - The start date of the range.
     * @param endDate - The end date of the range.
     */
    public static void getApodsWithDates(Date startDate, Date endDate){
        String formattedStartDate = startDate.year() + '-' + startDate.month() +'-'+ startDate.day(); 
        String formattedEndDate = endDate.year() + '-' + endDate.month() +'-'+ endDate.day(); 
        List<Map<String, Object>> results = getResults(endPoint + '&start_date=' + formattedStartDate + '&end_date=' + formattedEndDate);
        List<Apod__c> newAPODs = new List<Apod__c>();
        for(Map<String, Object> result: results){
            newAPODs.add(mapApod(result));
        }
        ApodService.createApods(newAPODs);
    }
}