@isTest
private class triggerParentLead_TestController
{
    static testMethod void triggerParentLead_Testmethod()
    {
         Profile p = [SELECT Id FROM Profile WHERE Name='CSR']; 
         UserRole r = [ Select id from UserRole where Name='Customer Service Representative'];
         User u1 = new User(Alias = 'safddsfs', Email='newusegdr@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='fsdggdg', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, UserRoleID = r.id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newusergdgg@testorg.com');
         
         System.RunAs(u1)
         {
             Account ac = new Account(name='TestAccount');
             ac.Customer_Service_Representative__c = UserInfo.getUserId();
             ac.No_of_Leads_Open_YTD__c = 2000;
             ac.Value_of_Leads_open_YTD__c = 3000;
             insert ac;
             Lead l = new Lead();
             l.lastname = 'Testname';
             l.status = 'Open';
             l.Company ='Aphidas';
             l.Customer_Profile__c='Existing Customer';
             l.Expected_Value__c =40000;
             l.Account_Name__c= ac.id;
             insert l;
             l.Company ='Aphidasedsgfh';
             Update l;
             
        }
     }
}