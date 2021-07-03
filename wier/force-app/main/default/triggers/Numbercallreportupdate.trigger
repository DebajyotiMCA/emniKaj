trigger Numbercallreportupdate on Task (after insert,after update) 
{
  public String lid ;
  public String noncrmemail ;
  Task[] t= Trigger.new;
  for(Task ta :t)
  {
     lid = ta.WhatID;
     noncrmemail =ta.Assigned_To_CRM_User__c;
  }
  
  if(lid !=null)
  {
   if(lid.startsWith('a02')==TRUE )
   {
      Call_Report__c l =[select ID, Number_Open_Task__c from Call_Report__c where id=:lid];
      Integer c  = [select count() from Task where WhatId=:lid and Task.status='Open'];
      l.Number_Open_Task__c= c ;
      l.id =lid;
      update l;    
   }
  }
  
  if(noncrmemail !=null)
  {
      SendemailController con = new SendemailController();
      con.sendEmailFunction(t);
  }
  
}