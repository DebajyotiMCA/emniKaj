@isTest
private class wr_CheckList_TestClass
{
    static testMethod void wr_CheckList_TestClassmethod() 
    {
     
     COpportunity__c oppty = new COpportunity__c();
     oppty.Quotation_submittal_date__c = Date.today(); 
     //oppty.Win_Probability__c = 90;
     insert oppty;
     
     
     Check_List__c checkList = new Check_List__c();
     checkList.Due_date__c= Date.Today();
     checkList.Opportunity__c= oppty.id;
     checkList.Assignee_Comments__c = 'TestingData';
     checkList.Assigned_Status__c = 'Outstanding';
     insert checkList;  
     
     ApexPages.StandardController con = new ApexPages.StandardController(checklist);
     wr_CheckList wrCheckList = new wr_CheckList(con);
     wrCheckList.csave();
     wrCheckList.AddRow();
     wrCheckList.cancel();
     
    }

}