@isTest
private class  QuoteEmail_Test{    
    
    static testMethod void UnitTest() {

        COpportunity__c Opp = new COpportunity__c(Business_Unit__c = 'Oman',CSRDecisionOnBid__c = 'YES',Status__c = 'Quote Ready for Submital');
        insert Opp;
        CostSheet__c costSheet = new CostSheet__c(Comment_if_any__c = 'test', discount_amount_if_any__c = 100,COpportunity__c = opp.Id,Labour_Cost__c = 100, Material_Cost__c= 100, Other_Cost__c = 100,Cost_Sheet_Amount__c = 100, Cost_Sheet_Preparation_Date__c = system.today());
        insert costSheet;
        Quotation__c Quotation = new Quotation__c(Final__c = true, Submit_for_review__c=true, COpportunity__c = Opp.Id, CostSheet__c  = costSheet.Id, Movex_quotation_docs_serial_no__c = '123');
        insert Quotation;
        
        
        
        Blob b = Blob.valueOf('Test Data');  
        Attachment attachment = new Attachment();  
        attachment.ParentId = Quotation.id;  
        attachment.Name = 'Test Attachment for Parent';  
        attachment.Body = b;  
        insert(attachment);
        
        PageReference pageRef = Page.QuoteEmail;
        Test.setCurrentPage(pageRef);
        //Add parameters to page URL
        ApexPages.currentPage().getParameters().put('qid', Quotation.id);
        QuoteEmail  con = new QuoteEmail();
        con.cemail = 'test.test@gmail.com';
        Opp.Status__c = 'Quote Ready for Submital';
        update opp;
        con.sendEmail(); 
    }
}