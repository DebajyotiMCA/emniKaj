@isTest
private class  FinalUpdate_Test{
    static Quotation__c setupData(){   
        COpportunity__c Opp = new COpportunity__c(Business_Unit__c = 'Oman',CSRDecisionOnBid__c = 'YES');
        insert Opp;
        CostSheet__c costSheet = new CostSheet__c(Comment_if_any__c = 'test', discount_amount_if_any__c = 100,COpportunity__c = opp.Id,Labour_Cost__c = 100, Material_Cost__c= 100, Other_Cost__c = 100,Cost_Sheet_Amount__c = 100, Cost_Sheet_Preparation_Date__c = system.today());
        insert costSheet;
        Quotation__c Quotation = new Quotation__c(Final__c = false, Submit_for_review__c=true, COpportunity__c = Opp.Id, CostSheet__c  = costSheet.Id, Movex_quotation_docs_serial_no__c = '123');
        insert Quotation; 
        return Quotation;
    }
    
    static testMethod void UnitTest() {      
        Quotation__c Quotation = setupData(); 
        Quotation.Final__c = true;
        update Quotation;
    }
}