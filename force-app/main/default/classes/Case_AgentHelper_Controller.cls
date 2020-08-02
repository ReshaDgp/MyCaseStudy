/**
 * Author: RH on 01/08/2020
 * It is the controller of Case_AgentHelper lightning component
 * TestClass: Case_AgentHelper_Controller_TEST
 */

public with sharing class Case_AgentHelper_Controller {

    /**
     * Receives a caseId as parameter and returns the data related to its customer using a wrapper: CustomerDataWrapper
     */
    @AuraEnabled
    public static CustomerDataWrapper getCustomerDetails(Id caseId){
        Case thisCase = [SELECT Contact.Product__r.Name,Contact.Home_Country__r.Name,
                         Contact.ATM_Fee_in_other_currencies__c,Contact.Cost_per_Calendar_Month__c,
                         Contact.Card_Replacement_Cost__c
                         FROM Case WHERE Id =: caseId];
        CustomerDataWrapper datawrapper = new CustomerDataWrapper(thisCase);
        return datawrapper;
    }

}