@isTest
private class Trigger_Numbercallreportupdate_TestClass 
{
    static testMethod void myUnitTest() 
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
             Call_Report__c c = new Call_Report__c();
             c.Call_Visit_date__c = system.today();
             c.Customer__c =ac.id;
             c.Communication_type__c ='Telephone';
             c.Contacted_Spoken__c =TRUE;
             insert c;
             Task ta =  new Task();
             ta.Subject ='call';
            // ta.Owner = u1[0].id;
             ta.status = 'Open';
             ta.Priority = 'High';
             ta.Assigned_To_CRM_User__c ='Test@test.com';
             ta.ActivityDate = system.today();
             ta.WhatID = c.id;
             insert ta;
             
             
            
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