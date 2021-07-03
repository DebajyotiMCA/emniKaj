@isTest
private class wr_CostSheet_TestClass
{
    static testMethod void wr_CostSheet_TestClassmethod() 
    {
      COpportunity__c oppty = new COpportunity__c();
      //oppty.Win_Probability__c = 90;
      oppty.Quotation_submittal_date__c = System.today();
      insert oppty;
      
      CostSheet__c   c= new CostSheet__c ();
      c.COpportunity__c = oppty.id;
      c.Upsell_amount_if_any__c =2000;
      c.Discount_amount_if_any__c =5000;
      c.Cost_Sheet_Amount__c = 50000;
      c.Labour_Cost__c = 3000;
      insert c;
      Blob b = Blob.valueOf('Test Data');  
      Attachment attachment = new Attachment();  
      attachment.ParentId = c.id;  
      attachment.Name = 'Test Attachment for Parent';  
      attachment.Body = b;  
      insert(attachment);
      Contact contact = new Contact();
      contact.Email= 'Aphidas@aphidas.com';
      contact.LastName= 'Aphidas';
      contact.FirstName= 'Aphidas';
      insert contact;
     
      Apexpages.standardController newController = new Apexpages.StandardController(c);
      wr_CostSheet  wrCost = new wr_CostSheet(newController);
      wrCost.tAttachment.Name= 'Testing';
      wrCost.csave();
      wrCost.doUploadFile(contact.id);
    
    }
    
}