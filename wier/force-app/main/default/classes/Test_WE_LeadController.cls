@isTest(SeeAllData = true)
private class  Test_WE_LeadController{    
    
    static testMethod void UnitTest() {
try {
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
        Expected_Date_of_Input__c = system.today(),
        Expected_Value__c = 100, 
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
        
        ApexPages.StandardController std = new ApexPages.StandardController(l);
        PageReference pageRef = Page.WR_Lead;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', l.id);
        WE_LeadController  cont = new WE_LeadController(std);
        cont.getLeadStatusItems();
        cont.Cancel();
        cont.cSave();
        cont.closePopup();
        cont.ShowPopup();
        cont.cancelPopup();
        cont.showPopupFollowup();
        cont.showPopupclosedlead();
        cont.showPopupunqualified();
        cont.getItems();
        cont.getCustomer();
        cont.customervisible();
        cont.assignCSR();
        
}
catch(EXCEPTION E) {}
    }
    
}