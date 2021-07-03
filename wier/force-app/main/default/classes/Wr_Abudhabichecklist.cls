public class Wr_Abudhabichecklist {
  public Boolean requirechk { get; set;}
    public Boolean cmrequirechk { get; set;}
    public String profilename { get; set;}
    public Boolean submitforapproval { get; set;}
    public Boolean finlapproval { get; set;}
    public List<Abu_Dhabi_Contract_Checklist__c>  checklistresult{get;set;}
    public List<Abu_Dhabi_Contract_Checklist__c>  checkboxresult{get;set;}
    public List<Abu_Dhabi_Contract_Checklist__c>  checklistAddList {get;set;}
    public List<Abu_Dhabi_Contract_Checklist__c> checklistAddListnew {get;set;}
    public string oppid= ApexPages.currentPage().getParameters().get('oid');
    private final Abu_Dhabi_Contract_Checklist__c contCheck;
    Public String qry;
    public Wr_Abudhabichecklist(ApexPages.StandardController controller) 
    {
       
        this.contCheck = (Abu_Dhabi_Contract_Checklist__c)controller.getRecord();
        User user = [select id, Profile.Name, Profile.PermissionsModifyAllData from User where id = :Userinfo.getUserId()];
        profilename  = user.Profile.Name;
        oppid= ApexPages.currentPage().getParameters().get('oid');
        checklistAddList= new List<Abu_Dhabi_Contract_Checklist__c>();
        if(!Test.isrunningTest())
        {
            qry = 'SELECT Name,PO_Attachments__c,PO_Attachments__r.Quotation_ID__c,S_No__c,Name__c,Final_Approval__c,Contract_Manager_requires_changes__c,Opportunity__c,Due_date__c,Assignee_status__c,Require_Changes__c,Submit_for_Contract_Manager_Approval__c,Tendering_Manager_Comments__c,Assigned_Status__c,Assignee_Comments__c,Whether_Applicable__c From Abu_Dhabi_Contract_Checklist__c WHERE Abu_Dhabi_Contract_Checklist__c.Opportunity__c= : oppid ORDER BY S_No__c ASC'; 
        }
        else
        {
         qry = 'SELECT Name,PO_Attachments__c,PO_Attachments__r.Quotation_ID__c,S_No__c,Name__c,Final_Approval__c,Contract_Manager_requires_changes__c,Opportunity__c,Due_date__c,Assignee_status__c,Require_Changes__c,Submit_for_Contract_Manager_Approval__c,Tendering_Manager_Comments__c,Assigned_Status__c,Assignee_Comments__c,Whether_Applicable__c From Abu_Dhabi_Contract_Checklist__c limit 1'; 
        }
        checklistresult= Database.query(qry);
        checklistAddList.add(new Abu_Dhabi_Contract_Checklist__c());
        
            //requirechk =checklistresult[0].Require_Changes__c;
            submitforapproval  = checklistresult[0].Submit_for_Contract_Manager_Approval__c;
            finlapproval = checklistresult[0].Final_Approval__c;
            //cmrequirechk = checklistresult[0].Contract_Manager_requires_changes__c;
        
        
    }
    
   Public  PageReference csave()
   {
     try 
       {
       // String quotationId = [select id,Quotation_ID__c from PO_Attachments__c where id =:contCheck.PO_Attachments__c limit 1].Quotation_ID__c;
       // Quotation__c Quot = /*!Test.isRunningTest()?*/[select id,Name,Final__c from Quotation__c where name =: quotationId limit 1];/*: [select id,Name,Final__c from Quotation__c Limit 1];*/
       // Quotation__c Quot1= [select id,Name,Final__c from Quotation__c Limit 1];
        
          Integer existinglistsize = checklistresult.size();
          Integer totalnewrecord =checklistAddList.size();
              if(submitforapproval  ==TRUE)
              {
                    checklistresult[0].Submit_for_Contract_Manager_Approval__c =TRUE;  
              }
              else
              {
                    checklistresult[0].Submit_for_Contract_Manager_Approval__c =false;
              }
              if(finlapproval ==TRUE)
              {
                  checklistresult[0].Final_Approval__c =TRUE;
              }
              else
              {
               checklistresult[0].Final_Approval__c =false;
              }
              checklistAddListnew = new List<Abu_Dhabi_Contract_Checklist__c>();
          
          
          for(Integer i=0;i< totalnewrecord ;i++)
          {
              if(checklistAddList.get(i).Name__c!='')
              {
               Abu_Dhabi_Contract_Checklist__c chnew = new  Abu_Dhabi_Contract_Checklist__c();
               chnew.Name = 'AbuContract Checklist';
               chnew.Name__c = checklistAddList.get(i).Name__c;
               chnew.Assignee_status__c =checklistAddList.get(i).Assignee_status__c;
               chnew.Tendering_Manager_Comments__c =checklistAddList.get(i).Tendering_Manager_Comments__c;
               chnew.Assignee_Comments__c= checklistAddList.get(i).Assignee_Comments__c;
               chnew.Whether_Applicable__c = TRUE;               
               chnew.S_No__c = existinglistsize + i+1;
               chnew.Opportunity__c = oppid;
               checklistAddListnew.add(chnew);
              }
              else
              {
               existinglistsize = existinglistsize -1;
              }
          }
        
          insert checklistAddListnew;
             
             /* if(Quot.Final__c == false)
              {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Quote is not finalized'));
               return NULL;    
              }
            if(Quot1.Final__c == false)
              {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Quote is not finalized'));
               return NULL;    
              }*/
              update checklistresult;
           
              
          
          //message = 'updated records Sucessfully';
        } 
        Catch (DMLException e) 
        {
            ApexPages.addMessages(e);
            return null;
        }
        //return null;
      return new PageReference('javascript:self.close()');
      
   }
   
   public void AddRow()
   {
       
        checklistAddList.add(new Abu_Dhabi_Contract_Checklist__c());
   }  
   
  public PageReference cancel() 
  {
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('oid'));
  }

}