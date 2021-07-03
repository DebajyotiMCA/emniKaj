@isTest
private class triggerParentPotential_TestController
{
    static testMethod void triggerParentPotential_Testmethod()
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
             insert ac;
             Contact con = new Contact();
             con.Lastname ='TestLast';
             con.Accountid = ac.id;
             insert con;
             
             Potential_revenue_for_the_year__c pe = new Potential_revenue_for_the_year__c();
             pe.Customer__c = ac.id;
             pe.APS__c = 4000;
             insert pe;
             pe.APS__c = 5000;
             Update pe;
             
        }
     }
}