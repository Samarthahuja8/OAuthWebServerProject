public with sharing class MakeCalloutOAuth {
    @AuraEnabled
    public static String getAccessToken(String authCode){
        try {
            String body = 'grant_type=authorization_code&client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&redirect_uri=YOUR_REDIRECT_URL&code='+authCode;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            // Set the body as a JSON object
            request.setBody(body);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            return response.getBody();

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createAccount(String accessToken,String accName){
        try {
            String endPoint = 'https://YOUR_DOMAIN_NAME.my.salesforce.com/services/data/v56.0/sobjects/Account';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            request.setBody(json.serialize(new Map<String,String>{'Name'=>accName}));
            HttpResponse response = http.send(request);
            // Parse the JSON response
            return response.getBody();
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
