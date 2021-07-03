trigger triggerParentCallVisit on Call_Report__c(after insert, after update, after delete, after undelete) {
 Map<Id,Account> parents = new Map<Id,Account>();
    
  if(Trigger.new<>null)
  {
    for(Call_Report__c c:Trigger.new)
    {
      if(c.Customer__c<>null)
        
        parents.put(c.Customer__c,new Account(id=c.Customer__c));
    }
     
  }
  if(Trigger.old<>null)
    {    
        
        for(Call_Report__c c:Trigger.old)
        {
          if(c.Customer__c <>null)     
            {
            parents.put(c.Customer__c,new Account(id=c.Customer__c));
            }
        }
        
    }
  //update parents.values();
  
}