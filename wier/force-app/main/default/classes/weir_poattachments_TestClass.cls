@isTest
private class weir_poattachments_TestClass
{
    static testMethod void weir_poattachments_TestClassmethod() 
    {
     Test.startTest();
     PO_Attachments__c  po = new PO_Attachments__c();
     Contact contact = new Contact();
     contact.Email= 'test@test.com';
     contact.LastName= 'Test';
     contact.FirstName= 'Test';
     insert contact;
    Blob b = Blob.valueOf('Test Data');  
    Attachment attachment = new Attachment();  
    attachment.ParentId = contact.id;  
    attachment.Name = 'Test Attachment for Parent';  
    attachment.Body = b;  
    insert(attachment); 
     
     Apexpages.standardController newController = new Apexpages.StandardController(po);
     weir_poattachments wrAttachment = new weir_poattachments(newController);
    
     wrAttachment.csave();
     wrAttachment.doUploadFile(contact.id);
     Test.stopTest();
    
    }}