@isTest
private class  Test_wr_CheckList{    
    
    static testMethod void UnitTest() {

        COpportunity__c Opp = new COpportunity__c(Business_Unit__c = 'Oman',CSRDecisionOnBid__c = 'YES');
        insert Opp;
        
        Check_List__c conlist = new Check_List__c(Opportunity__c = Opp.Id);
        insert conlist;        
        
        ApexPages.StandardController std = new ApexPages.StandardController(conlist);
        PageReference pageRef = Page.wr_CheckList;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', conlist.id);
        wr_CheckList  cont = new wr_CheckList(std);
        cont.csave();
        cont.AddRow();
        cont.Cancel();
        

    }
}