trigger triggerParentPotential on Potential_revenue_for_the_year__c (after insert, after update, after delete, after undelete) {
 Map<Id,Account> parents = new Map<Id,Account>();
    
  if(Trigger.new<>null)
  {
    for(Potential_revenue_for_the_year__c c:Trigger.new)
    {
      if(c.Customer__c<>null)
        
        parents.put(c.Customer__c,new Account(id=c.Customer__c));
    }
     
  }
  if(Trigger.old<>null)
    {    
        
        for(Potential_revenue_for_the_year__c c:Trigger.old)
        {
          if(c.Customer__c<>null)     
            {
            parents.put(c.Customer__c,new Account(id=c.Customer__c));
            }
        }
        
    }
 // update parents.values();
  
}