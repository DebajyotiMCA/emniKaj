@isTest
private class triggerParentSalesBudget_TestController
{
    static testMethod void triggerParentSalesBudget_Testmethod()
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
             Sales_budget_for_the_year__c sb = new Sales_budget_for_the_year__c();
             sb.Account__c = ac.id;
             sb.First_Quarter_APS__c = 4000;
             insert sb;
             sb.First_Quarter_APS__c = 5000;
             Update sb;
             
        }
     }
}