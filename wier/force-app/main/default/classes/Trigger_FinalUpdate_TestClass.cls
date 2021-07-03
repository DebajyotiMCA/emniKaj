@isTest
private class Trigger_FinalUpdate_TestClass 
{
static testMethod void myUnitTest() 
    {
      List<Quotation__c> lstQuotation = new List<Quotation__c>();
      List<Quotation__c> quotationlistexist = new List<Quotation__c>();
      List<Quotation__c> quotationlistupdate = new List<Quotation__c>(); 
      
      COpportunity__c cop = new COpportunity__c();
      cop.Quotation_submittal_date__c = Date.today(); 
      //cop.Win_Probability__c = 90; 
      insert cop;
      
      CostSheet__c costSheet = new CostSheet__c();
      costSheet.Cost_Sheet_Version__c= 'testCostSheet';
      costSheet.COpportunity__c = cop.ID;
      insert costSheet;
      
      Quotation__c quot = new Quotation__c();
      quot.CostSheet__c = costSheet.id;
      quot.COpportunity__c = cop.id;
      quot.Final__c = False;
      insert quot; 
      quot.Final__c = TRUE;
      update quot;
      
     // lstQuotation.add(cop);
      insert lstQuotation;
      
      
    }
}