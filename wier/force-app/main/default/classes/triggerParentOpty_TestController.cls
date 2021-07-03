@isTest
private class triggerParentOpty_TestController
{
    static testMethod void triggerParentOpty_Testmethod()
    {
         Profile p = [SELECT Id FROM Profile WHERE Name='CSR']; 
         //UserRole r = [ Select id from UserRole where Name='Customer Service Representative'];
         UserRole r = [ Select id from UserRole where Name='Business Head UAE'];
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
             ac.No_of_Leads_Open_YTD__c = 0;
             ac.Value_of_Leads_open_YTD__c = 0;
             ac.No_of_call_visit_reports_YTD__c = 0;
             ac.No_of_customer_contacts__c  = 0;
             ac.Primary_Customer_Contact__c = '';
             ac.No_of_Opportunities_YTD__c = 0;
             ac.No_of_Bids_Declined_YTD__c = 0;
             ac.No_of_Opportunities_Lost_YTD__c = 0;
             ac.No_of_Opportunities_won_YTD__c = 0;
             ac.No_of_enquiries_received__c = 0;
             ac.No_of_enquiries_declined__c  = 0 ;
             ac.No_of_enquiries_lost__c = 0;
             ac.No_of_quotes_sent_out__c = 0;
             ac.Value_of_Opportunities_won_YTD__c = 0;
             ac.No_of_enquiries_not_yet_quoted__c = 0;
             ac.No_of_quotes_overdue__c = 0;
             ac.No_of_quotes_not_yet_due__c = 0;
             ac.No_of_quotes_due__c = 0;
             ac.No_of_quotes_due_and_sent__c = 0;
             ac.No_of_quotes_overdue_OnDay__c = 0;
             ac.Budget_Current_Year__c = 0;
             insert ac;
             
             ac.No_of_quotes_due_and_sent__c = 100;
             ac.No_of_quotes_overdue_OnDay__c = 100;
             ac.Budget_Current_Year__c = 1000;
             update ac;
             
             COpportunity__c oppty = new COpportunity__c();
             //oppty.Win_Probability__c = 90;
             oppty.Customer__c = ac.id;
             oppty.OwnerId = ac.Customer_Service_Representative__c;
             oppty.Quotation_submittal_date__c = System.today();
             oppty.Status__c = 'Initial Review';
             insert oppty;

             COpportunity__c oppty13 = new COpportunity__c();
             //oppty13.Win_Probability__c = 90;
             oppty13.OwnerId = ac.Customer_Service_Representative__c;
             oppty13.Quotation_submittal_date__c = System.today();
             oppty13.Status__c = 'Opportunity closed';
             oppty13.Customer__c = ac.id;
             insert oppty13;
             
             COpportunity__c updateopp = new COpportunity__c();
             updateopp.Id = oppty13.Id;
             updateopp.Tendering_Manager__c = '005b0000001O6WO';
             updateopp.Is_this_opp_a_project__c = true;
             update updateopp;
             
        }
     }
}