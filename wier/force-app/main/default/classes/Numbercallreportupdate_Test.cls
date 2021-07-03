@isTest(SeeALLData = true)
private class  Numbercallreportupdate_Test{
    static Task setupData(){ 
    
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
        
        Call_Report__c cr = new Call_Report__c(Lead__c = l.Id,Contacted_Spoken__c = true, Call_Visit_date__c = system.now(), Customer__c = Acc.Id, Communication_type__c = 'Telephone', Attendee1__c = con.Id,
        Participant1__c = u.Id,Comment__c = 'Test Call');
        
        insert cr;
        
        Task task = new Task();
        task.WhatId = cr.Id;
        task.Subject = 'Email: test email';
        task.Status = 'Completed';
        insert task;
        return task;
    }
    
    static testMethod void UnitTest() {      
        Task t = setupData();        
    }
}