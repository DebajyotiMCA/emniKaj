@isTest(SeeAllData = true)
private class  Test_weir_poattachments{    
    
    static testMethod void UnitTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [select Id from userrole where 
        Name = 'Contracts Manager' or 
        Name = 'Contracts Representative'        
        limit 1];
 
        User u = [select Id,Business_Unit__c from user where userroleId =: r.Id limit 1];

        COpportunity__c Opp = new COpportunity__c(Business_Unit__c = 'Oman',CSRDecisionOnBid__c = 'YES');
        insert Opp;
        
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
        
        Blob b = Blob.valueOf('Test Data');  
        Attachment attachment = new Attachment();  
        attachment.ParentId = poa.id;  
        attachment.Name = 'Test Attachment for Parent';  
        attachment.Body = b;  
        insert(attachment);
        
        ApexPages.StandardController std = new ApexPages.StandardController(poa);
        PageReference pageRef = Page.weir_poattachments;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', poa.id);
        ApexPages.currentPage().getParameters().put('CF00Ng0000000boAK_lkid', opp.Id);
        weir_poattachments  cont = new weir_poattachments (std);
        cont.tAttachment = Attachment;
        cont.csave();
        

    }
}