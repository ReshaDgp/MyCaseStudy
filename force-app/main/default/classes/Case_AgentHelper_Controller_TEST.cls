@IsTest
private class Case_AgentHelper_Controller_TEST {

    @testSetup
    static void testSetup() {
        // Test Products
        Product__c testProd01 = new Product__c(Name = 'Standard');
        Product__c testProd02 = new Product__c(Name = 'Metal');
        insert new List<Product__c>{ testProd01, testProd02 };

        // Test Home Countries
        Home_Country__c testHC01 = new Home_Country__c(Name = 'DE', Currency_Symbol__c = '€');
        Home_Country__c testHC02 = new Home_Country__c(Name = 'UK', Currency_Symbol__c = '£');
        insert new List<Home_Country__c>{ testHC01, testHC02 };

        // Test Contacts
        Contact testContact01 = new Contact(LastName = 'N26 User A', Product__c = testProd01.Id, Home_Country__c = testHC02.Id);
        Contact testContact02 = new Contact(LastName = 'N26 User B', Product__c = testProd02.Id, Home_Country__c = testHC01.Id);
        insert new List<Contact>{ testContact01, testContact02 };

        // Test Cases with the data above
        Case testCase01 = new Case(ContactId = testContact01.Id, Status = 'New', Subject = 'Test UK');
        Case testCase02 = new Case(ContactId = testContact02.Id, Status = 'New', Subject = 'Test DE');
        insert new List<Case>{ testCase01, testCase02 };
    }

    static testMethod void testDE() {
        Id caseDE = [SELECT Id FROM Case WHERE Contact.LastName = 'N26 User B'].Id;
        CustomerDataWrapper cdw = Case_AgentHelper_Controller.getCustomerDetails(caseDE);
        system.assertEquals('DE', cdw.homeCountry);
        system.assertEquals('Metal', cdw.productType);
        // The following assertions in real project should be commented since the values may change over time (suggestion)
        system.assertEquals('€16.90', cdw.costPerMonth);
        system.assertEquals('€45', cdw.cardReplace);
        system.assertEquals('Free', cdw.atmFee);
    }

    static testMethod void testUK() {
        Id caseUK = [SELECT Id FROM Case WHERE Contact.LastName = 'N26 User A'].Id;
        CustomerDataWrapper cdw = Case_AgentHelper_Controller.getCustomerDetails(caseUK);
        system.assertEquals('UK', cdw.homeCountry);
        system.assertEquals('Standard', cdw.productType);
        // The following assertions in real project should be commented since the values may change over time (suggestion)
        system.assertEquals('£0', cdw.costPerMonth);
        system.assertEquals('£6', cdw.cardReplace);
        system.assertEquals('1.7%', cdw.atmFee);
    }

}