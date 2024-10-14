/**
 * A mock HTTP callout class for testing the APOD API integration.
 */
global class ApodCalloutMock implements HttpCalloutMock {

    /**
     * Main method to simulate an HTTP response based on the request.
     * 
     * @param req The HTTP request being made
     */
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json'); // Set the response header to return JSON content
        
        // Simulate an error if the URL contains the "error" parameter
        if (req.getEndpoint().contains('error')) {
            res.setBody('{"error": "Internal Server Error"}'); // Return an error message in the response body
            res.setStatusCode(500); // Set HTTP status code to 500 for internal server error
        } else {
            res.setBody(getMockResponse(req.getEndpoint())); // Return a mock success response
            res.setStatusCode(200); // Set HTTP status code to 200 for success
        }
        
        return res; // Return the simulated response
    }

    /**
     * Method to generate a mock response based on the request URL, it's used by the main method of this class.
     * 
     * @param url The URL of the request
     * @return The mock response as a JSON string
     * @see respond
     */
    private String getMockResponse(String url) {
        Boolean noParameters = !url.contains('&'); // Check if the URL contains parameters
        Boolean hasDate = url.contains('date'); // Check if the URL contains the 'date' parameter
        Boolean hasStartDate = url.contains('start_date'); // Check if the URL contains 'start_date'

        // Return mock response for a single APOD without parameters
        if (noParameters) {
            return '{"copyright": "Mock copy","date": "2024-10-09","explanation": "Mock explanation","hdurl": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_3500.jpg","media_type": "image","service_version": "v1","title": "Mock title","url": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_960.jpg"}';
        } 
        // Return mock response for multiple APODs when a date range is specified
        else if (hasStartDate) {
            return '[{"copyright": "Mock copy","date": "2023-10-08","explanation": "Mock explanation","hdurl": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_3500.jpg","media_type": "image","service_version": "v1","title": "Mock title","url": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_960.jpg"},{"copyright": "Mock copy","date": "2024-10-09","explanation": "Mock explanation","hdurl": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_3500.jpg","media_type": "image","service_version": "v1","title": "Mock title","url": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_960.jpg"}]';
        } 
        // Return mock response for a specific APOD with a date parameter
        else if (hasDate) {
            Integer dateStart = url.indexOf('date=') + 5; // Find the start of the date parameter in the URL
            String mockDate = url.substring(dateStart); // Extract the date from the URL
            return '{"copyright": "Mock copy","date": "' + mockDate + '","explanation": "Mock explanation","hdurl": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_3500.jpg","media_type": "image","service_version": "v1","title": "Mock title","url": "https://apod.nasa.gov/apod/image/2410/M106_Obaidly_960.jpg"}';
        }

        return null; // Return null if no conditions are met
    }
}