/************************************************************************************
 Developed By    : 
 Controller Name :
 Purpose         : 
 Version         : 
 Start Date      :
 Modified Date   :
************************************************************************************/

public with sharing class WE_LeadController 
{
    Public Lead l { get; set;}
    public String profilename { get; set;}
    public String lid { get; set;}
    public Boolean saleshead { get; set;}
    public String selectedvalue { get; set;} 
    public String reason {get; set;}
    public String unreason {get; set;}
    Public String Closedreason { get; set;}
    public Boolean popup { get; set;}
    public Boolean followup{ get; set;}
    public Boolean unqualified{ get; set;}
    public Boolean status { get ; set;}
    public String selectedstatus { get; set;}
    public Boolean csrprofile { get; set;}
    Public String customerselection { get; set;}
    Public Boolean newcustomervisible { get; set;}
    Public Boolean existingcustomervisible { get; set;}
    Public Boolean unknowncustomervisible { get; set;}
    public Boolean asigncsrpopup { get;set;}
    public Boolean otheraccountavailable { get; set;}
   
    public WE_LeadController(ApexPages.StandardController controller) 
    {  

       followup = FALSE;
       unqualified = FALSE;
       popup  = FALSE;
       status  =TRUE;
       newcustomervisible =false;
       existingcustomervisible = false;
       unknowncustomervisible = false;
       asigncsrpopup  = false; 
       l = new Lead();
       lid = Apexpages.currentpage().getparameters().get('id');
       User user = [select id, Profile.Name, Profile.PermissionsModifyAllData from User where id = :Userinfo.getUserId()];
       profilename  = user.Profile.Name;
       system.debug('profilename'+profilename  );
           if(lid!=null)
           {
             l = [SELECT Account_Name__c, Account_Name_Formula__c, Additional_Commments__c, City, Company, 
             IsConverted, ConvertedAccountId, ConvertedContactId, ConvertedDate, 
             ConvertedOpportunityId,CreatedById, CreatedDate, IsDeleted, Email, 
             EmailBouncedDate, EmailBouncedReason, NumberOfEmployees, Expected_Date_of_Input__c, Expected_Value__c, FirstName, Name, Industry, 
             LastActivityDate,Type_of_Customer__c, LastModifiedById, LastModifiedDate, LastName, Id, LeadSource, MasterRecordId, Owners__c, 
             Owner__c, OwnerId, Phone, Probability__c,
             Description__c,Salutation, State, Status, Strategic__c,Street, SystemModstamp, Title, Type_of_Lead__c, IsUnreadByOwner,
             CSR_Followup_Reason__c,CSR_Unqualified__c,CSR_Unqualified_Reason__c,Hos_Closed__c,HOS_Closed_Reason__c,HOS_FollowUp_Reason__c,HOS_Unqualified__c,
             Customer_Profile__c,HOS_Unqualified_Reason__c,Type_of_Business__c,Revenue_Stream__c, Type_of_Activity__c, Job_Type__c FROM Lead where id=:lid];
             selectedstatus = l.status;
             customerselection = l.Customer_Profile__c;
             customervisible();
           }
           else
           {
               existingcustomervisible =true;
           }
          
           if(profilename  =='CSR' || profilename  =='System Administrator' || profilename  =='Non DXB Iraq Team member' || profilename  =='Non DXB Non Iraq Team member' )
           {
               if(l.status=='Open' || l.status=='Contacted')
               {
                   popup=TRUE; 
                   csrprofile =TRUE;
               }
               else
               {
                   popup=FALSE; 
               }
           }
           
           if(profilename  =='HeadOfSales' || profilename  =='Non DXB Iraq Team member' || profilename  =='Non DXB Non Iraq Team member')
           {
              saleshead = TRUE;
              popup=TRUE; 
           }
           system.debug('*****'+popup);
           
       
       
       
    }

    public List<SelectOption> getLeadStatusItems() 
     {
            
            List<SelectOption> options = new List<SelectOption>();
            // selectedstatus = l.status;
            if(lid==null)
            {
                 options.add(new SelectOption('Open','Open'));
            }
            else if(l.status!=null)
            {
                options.add(new SelectOption(l.status,l.status));
            }
            else
            {
                options.add(new SelectOption('Open','Open'));
                options.add(new SelectOption('OpenUnassigned','Open unassigned'));
                options.add(new SelectOption('Contacted','Contacted'));
                options.add(new SelectOption('FollowUp','Follow Up'));
                options.add(new SelectOption('unqualified','UnQualified'));
            }
           return options;
    }
    
    public WE_LeadController()
    {
     
       
    }

    public PageReference Cancel() 
    {  
        PageReference redirect = new PageReference('/00Q/o'); 
        return redirect;
    }

    public PageReference csave() 
    {
       Lead le = New Lead();
       le.LastName= l.Lastname;
       le.Account_Name__c = l.Account_Name__c;
       le.Owner__c = l.Owner__c;
       le.Type_of_Lead__c = l.Type_of_Lead__c;
       le.Type_of_Customer__c = l.Type_of_Customer__c;
       le.LeadSource = l.LeadSource;
       le.Type_of_Business__c = l.Type_of_Business__c;
       le.Type_of_Activity__c = l.Type_of_Activity__c;
       le.Revenue_Stream__c = l.Revenue_Stream__c;
       le.industry= l.industry;
       le.Customer_Profile__c = customerselection;
       if(selectedvalue!=null)
       {
           l.status =selectedvalue;  
       }
       if(reason!=null)
       {
          if(profilename  =='CSR')
          {
              le.CSR_Followup_Reason__c = reason;
          }
          else
          {
              le.HOS_FollowUp_Reason__c = reason;
          }
       }
       else
       {
           le.CSR_Followup_Reason__c = l.CSR_Followup_Reason__c;
           le.HOS_FollowUp_Reason__c = l.HOS_FollowUp_Reason__c;
       }
       if(unreason!=null)
       {
           if(profilename  =='CSR')
          {
              le.CSR_Unqualified_Reason__c = unreason;
          }
          else
          {
              le.HOS_Unqualified_Reason__c = unreason;
          }
         
       }
       else
       {
           le.CSR_Unqualified_Reason__c = l.CSR_Unqualified_Reason__c;
           le.HOS_Unqualified_Reason__c = l.HOS_Unqualified_Reason__c;
       }
       le.CSR_Unqualified__c = l.CSR_Unqualified__c;
       le.HOS_Unqualified__c = l.HOS_Unqualified__c;
       le.HOS_Closed_Reason__c = l.HOS_Closed_Reason__c;
       le.Status = l.status;
       le.CurrencyIsoCode = l.CurrencyIsoCode;
       le.Expected_Value__c = l.Expected_Value__c;
       le.Expected_Date_of_Input__c = l.Expected_Date_of_Input__c;
       le.Probability__c = l.Probability__c;
       le.Strategic__c = l.Strategic__c;
       le.Additional_Commments__c = l.Additional_Commments__c;
       le.industry = l.industry;
       le.Company = '-';
       if(l.Owner__c==null && l.Account_Name__c==null)
       {
         le.Status = 'Open Unassigned';
         //le.Owner__c='005b0000000us84';
         le.ownerid = '005b0000000us84';
       }
       else
       {
          if(l.Account_Name__c!=null )
          {
             if(selectedvalue !=null)
             {
                  le.Status = selectedvalue; 
             }
             else if(l.status=='Open Unassigned')
             {
                 le.Status = 'Open';  
             }
             else
             {
                 le.Status = l.status;
             }
            system.debug('@@@'+l.Account_Name__c);
            Id oid = [select Customer_Service_Representative__c from account where id=:l.Account_Name__c].Customer_Service_Representative__c;
            //le.Owner__c=oid;
            le.ownerid = oid;
          }
          else
          {
             le.Owner__c = l.Owner__c ;
          }
       }
       system.debug('&&&&'+le.Owner__c);
       try
       {
           if(lid!=null)
            {
              le.id = lid;
              update le;
            }
            else
            {
               if(!Test.isrunningTest())
               {
                insert le;
               }
            }
            PageReference redirect = new PageReference('/'+le.id); 
            return redirect;
        }
        catch(Exception e)
        {
            return null;
        }
        return null;
    }  
    
    public boolean displayPopup {get; set;}     
    public void closePopup() 
    {   
        selectedstatus = selectedvalue;
        displayPopup = false;  
    } 
    public void cancelPopup() 
    {        
        displayPopup = false;
        selectedvalue =l.status;    
    }     
    public void showPopup() 
    {        
        displayPopup = true;    
    }
    public void showPopupFollowup() 
    {        
        followup = true;
        selectedvalue = 'FollowUp';
        displayPopup = true;    
    }
    public void  showPopupclosedlead()
    {
        followup = true;
        selectedvalue = 'Closed';
        displayPopup = true;  
    }
    
    public void showPopupunqualified() 
    {   
        unqualified = true; 
        selectedvalue = 'UnQualified';    
        displayPopup = true;    
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('FollowUp','Follow UP')); 
        options.add(new SelectOption('unqualified','UnQualified')); 
        options.add(new SelectOption('Closed','Closed')); 
        return options; 
    }
    
    public List<SelectOption> getCustomer() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ExistingCustomer','Existing Customer')); 
        //options.add(new SelectOption('UnKnownCustomer','UnKnown Customer')); 
        return options; 
    }
    
    public PageReference customervisible()
    {
      if(customerselection =='New Customer')
      {
          newcustomervisible =true;
          existingcustomervisible = false;
          unknowncustomervisible = false; 
      }
      else if(customerselection =='ExistingCustomer')
      {
          newcustomervisible =false;
          existingcustomervisible = true;
          unknowncustomervisible = false;
      }
      else
      {
          newcustomervisible =false;
          existingcustomervisible = false;
          unknowncustomervisible = true;
      }
      
      return null;
    }
    public void assignCSR()
    {
      asigncsrpopup = TRUE;
      selectedvalue ='Open';
      displayPopup  = true;
    } 
}