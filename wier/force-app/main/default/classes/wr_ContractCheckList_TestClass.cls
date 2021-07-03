@isTest(seeAllData=True)
private class wr_ContractCheckList_TestClass
{  
  
   static testMethod void wr_ContractCheckList_TestClassmethod()
    {
    
      test.startTest();
       
        //User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        //LocaleSidKey='en_US', Role = 'Customer Service Representative', 
        //TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
       
        Profile prof = [Select id from Profile where  Name ='System Administrator'];
        User u = new User(Alias = 'sampath', Email='standarduser@testorg.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof.id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sampath@testorg.com');
       
      System.runAs(u) 
      {
           COpportunity__c oppty = new COpportunity__c();
           //oppty.Win_Probability__c = 90;
           oppty.Quotation_submittal_date__c = System.today();
           insert oppty;
           
           CostSheet__c  cost = new CostSheet__c ();
           cost.COpportunity__c = oppty.id;
           insert cost;
             
            Quotation__c quot = new Quotation__c();
            quot.CostSheet__c = cost.id;
            quot.COpportunity__c = oppty.id;
            quot.Final__c = TRUE;
            insert quot;     
            oppty.Quotation_ID__c = quot.name;
            update oppty;
              
            PO_Attachments__c PO = new PO_Attachments__c();
            PO.Opportunity__c   =oppty.id;
            insert PO;
            List<Contract_Checklst__c> listchklist = new List<Contract_Checklst__c>();
            for(integer i=0; i<1; i++) 
            {
                listchklist.add( new Contract_Checklst__c(PO_Attachments__c = PO.id,Opportunity__c= oppty.id,Assignee_Comments__c = 'TestingData',Require_Changes__c = TRUE));
            }
            insert listchklist;
       // checkList.Require_Changes__c = TRUE;
       // checkList.Submit_for_Contract_Manager_Approval__c =FALSE;
       // checkList.Final_Approval__c=FALSE;
       // checkList.Contract_Manager_requires_changes__c=FALSE;
       // insert checkList;
        
       
            ApexPages.StandardController con = new ApexPages.StandardController(listchklist[0]);
            ApexPages.currentPage().getParameters().put('id', oppty.id);  
            wr_ContractCheckList wrconCheckList = new wr_ContractCheckList(con); 
            
            wrconCheckList.submitforapproval=TRUE;
            wrconCheckList.cmrequirechk = TRUE;
            wrconCheckList.finlapproval=TRUE; 
            wrconCheckList.AddRow();
            wrconCheckList.cancel();
            wrconCheckList.csave();
            wrconCheckList.requirechk = TRUE;
            listchklist[0].Require_Changes__c =TRUE;
            update listchklist;
             wrconCheckList.csave();
          test.stoptest();
        
       }
     }

}