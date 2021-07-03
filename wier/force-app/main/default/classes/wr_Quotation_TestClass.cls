@isTest
private class wr_Quotation_TestClass
{
    static testMethod void wr_Quotation_TestClassmethod() 
    {
     Quotation__c  c = new Quotation__c();
     Contact contact = new Contact();
     contact.Email= 'Aphidas@aphidas.com';
     contact.LastName= 'Aphidas';
     contact.FirstName= 'Aphidas';
     insert contact;
     
      Apexpages.standardController newController = new Apexpages.StandardController(c);
      wr_Quotation  wrQ = new wr_Quotation(newController);
       wrQ.tAttachment.Name= 'Testing';
      wrQ.csave();
      wrq.doUploadFile(contact.id);
     
    
    }}