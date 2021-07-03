trigger triggerParentContact on Contact (after insert, after update, after delete, after undelete) {
 Map<Id,Account> parents = new Map<Id,Account>();
    
  if(Trigger.new<>null)
  {
    for(Contact c:Trigger.new)
    {
      if(c.AccountId<>null)
      {
      parents.put(c.AccountId,new Account(id=c.AccountId));
      }
    }
  }
  if(Trigger.old<>null)
    {    
        
        for(Contact c:Trigger.old)
        {
          if(c.AccountId <>null)     
            {
            parents.put(c.AccountId,new Account(id=c.AccountId));
            }
        }
        
    }
  
 // update parents.values();
 
}