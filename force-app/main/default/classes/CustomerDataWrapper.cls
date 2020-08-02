/**
 * Author: RH on 01/08/2020.
 * It is used for the Case object.
 * Provoked from: Case_AgentHelper_Controller
 * TestClass: CaseServiceHandler_TEST
 */

public class CustomerDataWrapper {
    @AuraEnabled
    public String productType  {get;set;} //They should have @AuraEnabled because the attributes are used in a lightning component.
    @AuraEnabled
    public String homeCountry  {get;set;}
    @AuraEnabled
    public String costPerMonth {get;set;}
    @AuraEnabled
    public String atmFee       {get;set;}
    @AuraEnabled
    public String cardReplace  {get;set;}

    /**
     * Receives a case record and returns the data related to its contact. If the "Product Type" or "Home Country" are not set in the contact
     * we set their values equal to "Not Set"
     */
    public CustomerDataWrapper(Case thisCase){
        this.productType = thisCase.Contact.Product__r != NULL ? thisCase.Contact.Product__r.Name : 'Not Set';
        this.homeCountry = thisCase.Contact.Home_Country__r != NULL ? thisCase.Contact.Home_Country__r.Name : 'Not Set';
        this.costPerMonth = thisCase.Contact.Cost_per_Calendar_Month__c;
        this.atmFee = thisCase.Contact.ATM_Fee_in_other_currencies__c;
        this.cardReplace = thisCase.Contact.Card_Replacement_Cost__c;
    }
}