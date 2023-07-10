global with sharing class CaptchaWidgetController {
    
    @AuraEnabled(cacheable=true)
    public static String getCommunityOrigin() {
        return URL.getOrgDomainUrl().toExternalForm().split('.salesforce.')[0] + '.site.com';
    }

    @RemoteAction
    global static Boolean verifySolution(String solution) {
        Boolean success = true;

        // API callout to Friendly Captcha
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.captchaVerifyEndpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String body = '{"solution": "' + solution + '", ' + 
                  '"secret": "' + System.Label.captchaApiKey + '", ' + 
                     '"sitekey": "' + System.Label.captchaSiteKey + '"}';
        request.setBody(body);
        HttpResponse response = http.send(request);

        System.debug('Result is : ' + (Map<String, Object>) JSON.deserializeUntyped(response.getBody()));       
        if (response.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Boolean responseSuccess = (Boolean) result.get('success');
            success = responseSuccess;
        }
        return success;
    }
}