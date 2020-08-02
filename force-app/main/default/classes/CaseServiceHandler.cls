/**
 * Author: RH on 01/08/2020
 * It is providing the case details to an external system
 * TestClass: CaseServiceHandler_TEST
 */

@RestResource(urlMapping='/CaseDetails')
global with sharing class CaseServiceHandler {

    @HttpGet
    global static Case getCase(){
        String caseExternalId;
        RestRequest req = RestContext.request; // Request from the external system
        RestResponse res = RestContext.response; // Response sent to the external system

        if (req.params.containsKey('caseExternal')) caseExternalId = req.params.get('caseExternal');

        // Check if the external id is not empty and if the length 6, otherwise respond as an error
        if (caseExternalId == null || caseExternalId.length() != 6) {
          res.StatusCode = 406;
          res.addHeader('Error', 'caseExternal is not valid.');
          return null;
        }

        // Retreive the case with the external id retreived above
        system.debug('*** INFO: caseExternal: ' + caseExternalId + ' ***');
        try {
            List<Case> foundCase = [SELECT Id,Contact.Product__r.Name,Contact.Home_Country__r.Name,
                             Contact.ATM_Fee_in_other_currencies__c,Contact.Cost_per_Calendar_Month__c,
                             Contact.Card_Replacement_Cost__c
                             FROM Case WHERE CaseExternalUI__c =: caseExternalId LIMIT 1];

            // Case is found and sent back to the external system
            if (foundCase.size() > 0){
                res.addHeader('Content-Type', 'application/json');
                res.StatusCode = 200;
                return foundCase[0];
            } else {
                res.StatusCode = 400;
                res.addHeader('Error', 'There is no Case found with such caseExternal in our system.');
                return null;
            }

        } catch (Exception e) {
            res.statusCode = 500;
            res.addHeader('Error', e.getMessage());
            system.debug('*** ERRRO at line: ' + e.getStackTraceString() + ' Message: ' + e.getMessage() + ' ***');
            return null;
        }
    }

}