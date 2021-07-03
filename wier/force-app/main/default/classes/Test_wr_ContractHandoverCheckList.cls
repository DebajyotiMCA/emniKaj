@isTest(SeeAllData = true)
private class  Test_wr_ContractHandoverCheckList {    
    
    static testMethod void UnitTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [select Id from userrole where 
        Name = 'Contracts Manager' or 
        Name = 'Contracts Representative'        
        limit 1];
 
        User u = [select Id,Business_Unit__c from user where userroleId =: r.Id limit 1];

        COpportunity__c Opp = new COpportunity__c(Business_Unit__c = 'Oman',CSRDecisionOnBid__c = 'YES');
        insert Opp;
        
        CostSheet__c costSheet = new CostSheet__c(Comment_if_any__c = 'test', discount_amount_if_any__c = 100,COpportunity__c = opp.Id,Labour_Cost__c = 100, Material_Cost__c= 100, Other_Cost__c = 100,Cost_Sheet_Amount__c = 100, Cost_Sheet_Preparation_Date__c = system.today());
        insert costSheet;
        
        Quotation__c Quotation = new Quotation__c(Final__c = true, Submit_for_review__c=true, COpportunity__c = Opp.Id, CostSheet__c  = costSheet.Id, Movex_quotation_docs_serial_no__c = '123');
        insert Quotation;
        
        PO_Attachments__c poa = new PO_Attachments__c(
        Assign_Contract_Representative__c = u.Id,
        Customer_document_reference__c = 'TEST1234567890',
        Opportunity__c = opp.Id,
        PO_Amount__c = 100,
        Info_clarification_reqd_from_customer__c = false,
        PO_handed_over_to_contract__c = false,
        comments_if_any__c = 'testcom',
        Delivery_due_date_as_per_Customer_Order__c = system.today()
        
        );
        insert poa;    


        Contract_CheckList__c conlist = new Contract_CheckList__c(PO_Attachments__c = poa.Id, Opportunity__c = Opp.Id);
        insert conlist;
        
        
        ApexPages.StandardController std = new ApexPages.StandardController(conlist);
        PageReference pageRef = Page.Weir_ContractHandoverCheckList;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', conlist.id);
        wr_ContractHandoverCheckList   cont = new wr_ContractHandoverCheckList (std);
        cont.csave();
        cont.AddRow();
        cont.Cancel();
        

    }
}