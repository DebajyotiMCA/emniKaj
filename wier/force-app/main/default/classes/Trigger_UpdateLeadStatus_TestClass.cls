@isTest
private class Trigger_UpdateLeadStatus_TestClass 
{
    static testMethod void myUnitTest() 
    {
       
        Lead l = new Lead();
        l.lastname = 'Testname';
        l.status = 'Open';
        l.Company ='Aphidas';
        insert l;
        
        COpportunity__c oppty = new COpportunity__c();
        //oppty.Win_Probability__c = 90;
       // oppty.OwnerId = acc.Customer_Service_Representative__c;
        oppty.Quotation_submittal_date__c = System.today();
        insert oppty;
        
        Call_Report__c c = new Call_Report__c();
        c.Call_Visit_date__c = system.today();
        c.Lead__c =l.id;
        c.Communication_type__c ='Telephone';
        c.Contacted_Spoken__c =TRUE;
        insert c; 
        Call_Report__c copp = new Call_Report__c();
        copp.Call_Visit_date__c = system.today();
        copp.Opportunity__c =oppty.id;
        copp.Communication_type__c ='Telephone';
        copp.Contacted_Spoken__c =TRUE;
        insert copp ; 
      
    }
}