@istest
private class QuoteEmail_TestClass{
 static testMethod void myUnitTest() 
 {
   COpportunity__c oppty = new COpportunity__c();
   //oppty.Win_Probability__c = 90;
   oppty.status__c ='Quote Ready for Submital';
   oppty.Quotation_submittal_date__c = System.today();
   insert oppty;
   CostSheet__c costSheet = new CostSheet__c();
   costSheet.Cost_Sheet_Version__c= 'testCostSheet';
   costSheet.COpportunity__c = oppty.ID;
   insert costSheet;
  
   Quotation__c q = new Quotation__c();
   q.COpportunity__c = oppty.id;
   q.Submit_for_review__c =TRUE;
   q.CostSheet__c =costSheet.id;
   q.Final__c =TRUE;
   insert q;
   
   Blob b = Blob.valueOf('Test Data');  
   Attachment attachment = new Attachment();  
   attachment.ParentId = q.id;  
   attachment.Name = 'Test Attachment for Parent';  
   attachment.Body = b;  
   insert(attachment);
  
   ApexPages.currentPage().getParameters().put('qid',q.id);
   QuoteEmail qe = new QuoteEmail();
   qe.cemail = 'aphidas@aphidas.com';
   qe.sendEmail();
   q.Final__c =FALSE;
   update q;
   qe.sendEmail();
   
 }
}