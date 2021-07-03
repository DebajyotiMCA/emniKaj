trigger triggerParentLead on Lead (after insert, after update, after delete, after undelete) {
 Map<Id,Account> parents = new Map<Id,Account>();
    
  if(Trigger.new<>null)
  {
    for(Lead c:Trigger.new)
    {
      if(c.Account_Name__c<>null)
        
        parents.put(c.Account_Name__c,new Account(id=c.Account_Name__c));
    }
     
  }
  if(Trigger.old<>null)
    {    
        
        for(Lead c:Trigger.old)
        {
          if(c.Account_Name__c<>null)     
            {
            parents.put(c.Account_Name__c,new Account(id=c.Account_Name__c));
            }
        }
        
    }
//  update parents.values();
  
}