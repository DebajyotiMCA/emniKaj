@isTest
private class WE_LeadControllerTest
{
    public static list<User> listOfUser{get;set;}
    public static Lead newLead {get;set;}
    static testMethod void WE_LeadControllermethod() 
    {
      
      listOfUser = new List<User>();
      listOfUser = Utility.testUserDataSetUp();
      Lead l = new Lead();
      Apexpages.standardController newController = new Apexpages.StandardController(l);
      WE_LeadController lc = new WE_LeadController(newController);
      ApexPages.currentPage().getParameters().put('id', '00Q11000000uGrf');
      lc.Cancel();
      lc.getLeadStatusItems();
      ApexPages.currentPage().getParameters().put('id', '00Q11000000uGrf');
      lc.getLeadStatusItems();
      lc.getItems() ;
      lc.getCustomer();
      lc.closePopup();
      lc.cancelPopup();
      lc.showPopup();
      lc.showPopupFollowup();
      lc.showPopupclosedlead();
      lc.showPopupunqualified();
      lc.csave();
      lc.getLeadStatusItems();
      lc.customervisible();
      lc.customerselection ='New Customer';
      lc.customervisible();
      lc.customerselection ='ExistingCustomer';
      lc.customervisible();
     // ApexPages.currentPage().getParameters().put('customerselection', 'ExistingCustomer');
      lc.assignCSR();
      
    
    }
}