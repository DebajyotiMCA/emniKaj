@isTest
private class triggerParentCallVisit_TestController
{
    static testMethod void triggerParentCallVisit_Testmethod()
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
             Call_Report__c c = new Call_Report__c();
             c.Call_Visit_date__c = system.today();
             c.Customer__c =ac.id;
             c.Attendee1__c = con.id;
             c.Communication_type__c ='Telephone';
             c.Contacted_Spoken__c =TRUE;
             insert c;
             
        }
     }
}