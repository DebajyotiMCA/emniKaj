public with sharing class wr_CheckList {
    
    public String message {get;set;}
    public List<Check_List__c>  checklistresult{get;set;}
    public List<Check_List__c>  checklistAddList {get;set;}
    public List<Check_List__c> checklistAddListnew {get;set;}
    public boolean yes;
    public String p;
    private final Check_List__c contCheck;
    public string oppid= ApexPages.currentPage().getParameters().get('oid');
    public wr_CheckList(ApexPages.StandardController controller) 
    {
        this.contCheck = (Check_List__c)controller.getRecord();
        checklistAddList= new List<Check_List__c>();
        String qry = 'SELECT Name,S_No__c,Opportunity__c,Due_date__c,Assignee_status__c,Assignee_Comments__c,Assigned_Status__c,Wheather_Applicable__c From Check_List__c WHERE Check_List__c.Opportunity__c= : oppid ORDER BY S_No__c ASC'; 
        checklistresult= Database.query(qry);
        checklistAddList.add(new Check_List__c());
        
    }
   Public  PageReference csave()
   {
     try 
       {
          update checklistresult;
          Integer existinglistsize = checklistresult.size();
          Integer totalnewrecord =checklistAddList.size();
          checklistAddListnew = new List<Check_List__c>();
          for(Integer i=0;i< totalnewrecord ;i++)
          {
              if(checklistAddList.get(i).Name!='')
              {
               Check_List__c chnew = new  Check_List__c();
               chnew.Name = checklistAddList.get(i).Name;
               chnew.Assignee_status__c =checklistAddList.get(i).Assignee_status__c;
               chnew.Assignee_Comments__c= checklistAddList.get(i).Assignee_Comments__c;
               //chnew.Wheather_Applicable__c = checklistAddList.get(i).Wheather_Applicable__c;
               chnew.Wheather_Applicable__c = true;
               if(chnew.S_No__c == 21 && chnew.Wheather_Applicable__c == false)
               {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please check the whether applicable for record 21');
                   ApexPages.addMessage(myMsg);
                  // message = 'Please check the whether applicable for record 21';
           
               } 
               if(i==0)
               {
                   chnew.S_No__c = existinglistsize + 1;
               }
               else
               {
                   chnew.S_No__c = existinglistsize +i+1;
               }
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
          return null;
        }
        return new PageReference('javascript:self.close()');
   }
   
   public void AddRow()
   {
        checklistAddList.add(new Check_List__c());
   }  
   
  public PageReference cancel() 
  {
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('oid'));
  }

}