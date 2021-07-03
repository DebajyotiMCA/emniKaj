@isTest
public class wr_AbudhabiContractChecklist_TestClass {
    
     static testMethod void wr_ContractCheckList_TestClassmethod()
    {
     COpportunity__c oppty = new COpportunity__c();
     oppty.Quotation_submittal_date__c = Date.today(); 
     //oppty.Win_Probability__c = 90;
     insert oppty;
        
      CostSheet__c  cost = new CostSheet__c ();
           cost.COpportunity__c = oppty.id;
          // insert cost;
             
            Quotation__c quot = new Quotation__c();
            quot.CostSheet__c = cost.id;
            quot.COpportunity__c = oppty.id;
            quot.Final__c = TRUE;
           //insert quot;     
            oppty.Quotation_ID__c = quot.name;
            update oppty;
              
            PO_Attachments__c PO = new PO_Attachments__c();
            PO.Opportunity__c   =oppty.id;
            //insert PO;
            List<Abu_Dhabi_Contract_Checklist__c> listchklist = new List<Abu_Dhabi_Contract_Checklist__c>();
            for(integer i=0; i<1; i++) 
            {
                listchklist.add( new Abu_Dhabi_Contract_Checklist__c(PO_Attachments__c = PO.id,Opportunity__c= oppty.id,Assignee_Comments__c = 'TestingData',Require_Changes__c = TRUE));
            }
            insert listchklist;
     
     
     Abu_Dhabi_Contract_Checklist__c checkList1 = new Abu_Dhabi_Contract_Checklist__c();
     checkList1.Due_date__c= Date.Today();
     checkList1.Opportunity__c= oppty.id;
     checkList1.Assignee_Comments__c = 'TestingData';
     checkList1.Assigned_Status__c = 'Outstanding';
     //insert checkList1;  
     
     ApexPages.StandardController con = new ApexPages.StandardController(checklist1);
     Wr_Abudhabichecklist wrCheckList = new Wr_Abudhabichecklist(con);
     wrCheckList.csave();
     wrCheckList.AddRow();
     wrCheckList.cancel();
        
       			
    		 }

		}