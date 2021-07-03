@isTest
private class Test_wr_CostSheet {    
    
    static testMethod void UnitTest() {

        COpportunity__c Opp = new COpportunity__c(Business_Unit__c = 'Oman',CSRDecisionOnBid__c = 'YES');
        insert Opp;
        
        CostSheet__c costSheet = new CostSheet__c(Comment_if_any__c = 'test', discount_amount_if_any__c = 100,COpportunity__c = opp.Id,Labour_Cost__c = 100, Material_Cost__c= 100, Other_Cost__c = 100,Cost_Sheet_Amount__c = 100, Cost_Sheet_Preparation_Date__c = system.today());
        insert costSheet;
        
        
        ApexPages.StandardController std = new ApexPages.StandardController(costSheet);
        PageReference pageRef = Page.wr_CostSheet;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', costSheet.id);
        wr_CostSheet   cont = new wr_CostSheet (std);
        cont.csave();
    }
}