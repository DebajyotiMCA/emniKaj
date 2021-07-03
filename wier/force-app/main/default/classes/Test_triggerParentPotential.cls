@isTest(SeeALLData = true)
private class  Test_triggerParentPotential{
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
        
        Potential_revenue_for_the_year__c pry = new Potential_revenue_for_the_year__c(
        Customer__c = Acc.Id
        );
        
        insert pry;
        pry.Year__c = '2015';
        update pry;
        
    }
    
    static testMethod void UnitTest() {      
        setupData();        
    }
}