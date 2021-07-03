@isTest
private class Trigger_RFQToOpportunity_TestClass 
{
    static testMethod void myUnitTest() 
    {
         Profile p = [SELECT Id FROM Profile WHERE Name='CSR']; 
         UserRole r = [ Select id from UserRole where Name='Customer Service Representative'];
         User u1 = new User(Alias = 'weuetwet', Email='dfhdfhhfd@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='hdfdhhfdh', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, UserRoleID = r.id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuhdfhdfhser@testorg.com');
         System.RunAs(u1)
         {
             Account ac = new Account(name='TestAccount');
             ac.Customer_Service_Representative__c = UserInfo.getUserId();
             insert ac;
            
             RFQ__c rfq = new RFQ__c();
             rfq.Account__c = ac.id;
             rfq.Date_on_Enquiry__c = system.today();
             rfq.Customer_Acknowledgement_Name__c = 'Testing';
             rfq.Customer_s_reference_in_RFQ__c ='Testing2';
             insert rfq;
            
             Apexpages.standardController newController = new Apexpages.StandardController(rfq);
        }
      
      }
}