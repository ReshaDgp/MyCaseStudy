@IsTest
private class CaseServiceHandler_TEST {

    @testSetup
    static void testSetup() {
        // Test Product
        Product__c testProd = new Product__c(Name = 'Standard');
        insert testProd;

        // Test Home Country
        Home_Country__c testHC = new Home_Country__c(Name = 'DE', Currency_Symbol__c = '€');
        insert testHC;

        // Test Contact
        Contact testContact = new Contact(LastName = 'N26 User', Product__c = testProd.Id, Home_Country__c = testHC.Id);
        insert testContact;

        // Test Case with the data above
        Case testCase = new Case(ContactId = testContact.Id, Status = 'New', Subject = 'Test WEB Service', CaseExternalUI__c = 'A1B2C3');
        insert testCase;
    }

    /**
     * Test the happy path where the ExternalId received exists in our system
     */
    static testMethod void testSuccess() {
        Case existingCase = [SELECT Id,Contact.Product__r.Name,Contact.Home_Country__r.Name,
                             Contact.ATM_Fee_in_other_currencies__c,Contact.Cost_per_Calendar_Month__c,
                             Contact.Card_Replacement_Cost__c
                             FROM Case WHERE CaseExternalUI__c = 'A1B2C3']; // Case that is inserted into database in setup method

        // Preparing the REST call with a valid caseExternal
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CaseDetails';
        req.httpMethod = 'GET';
        req.addParameter('caseExternal', 'A1B2C3');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Case resultCase = CaseServiceHandler.getCase();
        system.assertEquals(existingCase.Id, resultCase.Id);
        system.assertEquals(existingCase.ContactId, resultCase.ContactId);
        system.assertEquals(existingCase.Contact.ATM_Fee_in_other_currencies__c, resultCase.Contact.ATM_Fee_in_other_currencies__c);
        system.assertEquals(existingCase.Contact.Cost_per_Calendar_Month__c, resultCase.Contact.Cost_per_Calendar_Month__c);
        system.assertEquals(existingCase.Contact.Cost_per_Calendar_Month__c, resultCase.Contact.Cost_per_Calendar_Month__c);
        system.assertEquals(existingCase.Contact.Home_Country__r, resultCase.Contact.Home_Country__r);
        system.assertEquals(existingCase.Contact.Product__r, resultCase.Contact.Product__r);
        Test.stopTest();
    }

    /**
     * Test API when the ExternalId does not exist in our system
     */
    static testMethod void testFail01() {
        // Preparing the REST call with an invalid caseExternal
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CaseDetails';
        req.httpMethod = 'GET';
        req.addParameter('caseExternal', 'ABC123');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Case resultCase = CaseServiceHandler.getCase();
        system.assertEquals(null, resultCase);
        system.assertEquals(400, res.StatusCode);
        Test.stopTest();
    }

    /**
     * Test API when the ExternalId is not a valid (length is not 6).
     */
    static testMethod void testFail02() {
        // Preparing the REST call with an invalid caseExternal
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CaseDetails';
        req.httpMethod = 'GET';
        req.addParameter('caseExternal', 'ABCD1234');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Case resultCase = CaseServiceHandler.getCase();
        system.assertEquals(null, resultCase);
        system.assertEquals(406, res.StatusCode);
        Test.stopTest();
    }

}