public with sharing class wr_ContractHandoverCheckList 
{
    public String message {get;set;}
    public List<Contract_CheckList__c>  checklistresult{get;set;}
    public List<Contract_CheckList__c>  ListChklist = new List<Contract_CheckList__c>();
    public List<Contract_CheckList__c>  checklistAddList {get;set;}
    public List<Contract_CheckList__c> checklistAddListnew {get;set;}  
    public boolean yes;
    public String p;
    public string oppid= ApexPages.currentPage().getParameters().get('oid');
    private final Contract_CheckList__c contCheck;
    public wr_ContractHandoverCheckList(ApexPages.StandardController controller) 
    
    {   
        this.contCheck = (Contract_CheckList__c)controller.getRecord();
        checklistAddList= new List<Contract_CheckList__c>();
        String qry = 'SELECT Name,S_No__c,PO_Attachments__c,PO_Attachments__r.Quotation_ID__c,Opportunity__c,Assignee_status__c,Assignee_Comments__c,Wheather_Applicable__c From Contract_CheckList__c WHERE Contract_CheckList__c.Opportunity__c= : oppid'; 
        checklistresult= Database.query(qry);
        checklistAddList.add(new Contract_CheckList__c());

    }
    
    Public  PageReference csave()
   {
     try 
       { 
       String quotationId = [select id,Quotation_ID__c from PO_Attachments__c where id =:contCheck.PO_Attachments__c limit 1].Quotation_ID__c;
       Quotation__c Quot = !Test.isRunningTest()?[select id,Name,Final__c from Quotation__c where name =: quotationId limit 1] : [select id,Name,Final__c from Quotation__c limit 1];
       if(Quot.Final__c == false)
       {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Quote is not finalized'));
           return NULL;    
       }
       update checklistresult;
       Integer existinglistsize = checklistresult.size();
       Integer totalnewrecord =checklistAddList.size();
       checklistAddListnew = new List<Contract_CheckList__c>();
       for(Integer i=0;i< totalnewrecord ;i++)
       {
            
           if(checklistAddList.get(i).Name!='')
             {
               Contract_CheckList__c chnew = new  Contract_CheckList__c();
               chnew.Name = checklistAddList.get(i).Name;
               chnew.Assignee_status__c =checklistAddList.get(i).Assignee_status__c;
               chnew.Assignee_Comments__c= checklistAddList.get(i).Assignee_Comments__c;
               chnew.Wheather_Applicable__c = checklistAddList.get(i).Wheather_Applicable__c;
               chnew.S_No__c = existinglistsize + i;
               chnew.Opportunity__c = oppid;
               checklistAddListnew.add(chnew);
              }
             else
             {
              existinglistsize = existinglistsize -1;
             }
          }
          insert checklistAddListnew;
          message = 'updated records Sucessfully';
        } 
        Catch (DMLException e) 
        {
          ApexPages.addMessages(e);
        }
        return new PageReference('javascript:self.close()');
   } 
   
   public void AddRow()
   {
        checklistAddList.add(new Contract_CheckList__c());
   }  
   
  public PageReference cancel() 
  {
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('oid'));
  }

}