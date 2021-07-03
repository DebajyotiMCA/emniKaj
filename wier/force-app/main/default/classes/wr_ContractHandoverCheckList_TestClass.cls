@isTest(seeAllData=True)
private class wr_ContractHandoverCheckList_TestClass
{
    static testMethod void wr_ContractHandoverCheckList_TestClassmethod() 
    {
     
            COpportunity__c oppty = new COpportunity__c();
            //oppty.Win_Probability__c = 90;
            oppty.Quotation_submittal_date__c = System.today();
            //oppty.Quotation_ID__c = quot.id;
            insert oppty;
             CostSheet__c  cost = new CostSheet__c ();
            cost.COpportunity__c = oppty.id;
           insert cost;
         
          Quotation__c quot = new Quotation__c();
          quot.CostSheet__c = cost.id;
          quot.COpportunity__c = oppty.id;
          quot.Final__c = true;
          insert quot; 
          
          system.debug('quot-->'+quot);
            
          oppty.Quotation_ID__c = quot.name;
          update oppty;
          
        PO_Attachments__c PO = new PO_Attachments__c();
        PO.Opportunity__c   =oppty.id;
        insert PO;
        
     Contract_CheckList__c checkList = new Contract_CheckList__c();
     checkList.PO_Attachments__c = PO.id;
     checkList.Opportunity__c= oppty.id;
     checkList.Assignee_Comments__c = 'TestingData';
     insert checkList;
     
         
     ApexPages.StandardController con = new ApexPages.StandardController(checkList);
     wr_ContractHandoverCheckList wrCheckList = new wr_ContractHandoverCheckList(con); 
     
     wrCheckList.csave();
     wrCheckList.AddRow();
     wrCheckList.cancel();
    
    }

}