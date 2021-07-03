@isTest(SeeALLData = true)
private class  Test_RFQToOpportunity{
    static void setupData(){ 
    
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        UserRole r = [select Id from userrole where 
        Name = 'Customer Service Representative' or 
        Name = 'Head of Sales' or 
        Name = 'Non DXB Iraq Team member' or 
        Name = 'Non DXB Non Iraq Team member' or 
        Name = 'Senior Customer Services Representative - 1' or 
        Name = 'Senior Customer Services Representative - 2' or 
        Name = 'Sub Customer Service Representative - 1' or 
        Name = 'Sub Customer Service Representative - 2' or 
        Name = 'Iraq Customer Service Representative'         
        limit 1];

 
        User u = [select Id,Business_Unit__c from user where userroleId =: r.Id limit 1];
        
        
        
            
        Account Acc = new Account(Name = 'TesTACC',Business_Unit__c = u.Business_Unit__c ,Customer_Service_Representative__c = u.Id);insert Acc;
        Contact Con = new Contact(LastName = 'TestCon',AccountId = Acc.Id);insert con;
        con.FirstName = 'Test';
        update con;
        
        Lead l = new Lead(LastName = 'Test Lead',
        Expected_Date_of_Input__c = system.today(),Expected_Value__c = 100, 
        Probability__c = 1, 
        LeadSource = 'Email',
        Revenue_Stream__c = 'APS',
        Type_of_Lead__c = 'Commissioning',
        Type_of_Customer__c = 'Competitor',
        industry = 'UAE',
        Strategic__c = 'Advanced Parts Solution',
        Company = 'Manjunath',
        Account_Name__c = Acc .Id);
        insert l;
        
        UserRole r1 = [select Id from userrole where 
        Name = 'Tendering Manager' or 
        Name = 'Head of Tendering'          
        limit 1];

 
        User u1 = [select Id,Business_Unit__c from user where userroleId =: r1.Id or alias = 'Durga' or alias ='Santhosh'  limit 1];
        
        
        RFQ__c rqc = new RFQ__c(Received_From__c = 'Test RQ',
        Date_on_Enquiry__c = system.today(),
        Time_of_Email_Receipt__c = system.now(),
        Account__c = Acc.Id,
        Tendering_Manager__c = u1.Id,
        Lead__c = l.Id,
        Not_available__c  = true,
        Customer_Acknowledgement_Name__c = 'Test Ack',
        Customer_Email__c = 'test@gmail.com');

        insert rqc;
        
        
    }
    
    static testMethod void UnitTest() {      
        setupData();        
    }
}