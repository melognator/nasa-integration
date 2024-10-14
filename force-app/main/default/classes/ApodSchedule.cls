/**
 * Schedulable class to get the Astronomy Picture of the Day (APOD) daily.
 */
global class ApodSchedule implements Schedulable {
    /**
     * This methods uses the ApodIntegration class to make an API callout to get the Astronomy Picture of the Day (APOD).
     * 
     * @param sc The schedulable context
     */
    global void execute(SchedulableContext sc) {
        // make api callout using ApodIntegration getApod method
        ApodIntegration.getApod();
    }
}