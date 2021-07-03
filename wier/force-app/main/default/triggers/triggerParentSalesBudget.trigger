trigger triggerParentSalesBudget on Sales_budget_for_the_year__c (after insert, after update, after delete, after undelete) {
 Map<Id,Account> parents = new Map<Id,Account>();
    
  if(Trigger.new<>null)
  {
    for(Sales_budget_for_the_year__c c:Trigger.new)
    {
      if(c.Account__c<>null)
        
        parents.put(c.Account__c,new Account(id=c.Account__c));
    }
     
  }
  if(Trigger.old<>null)
    {    
        
        for(Sales_budget_for_the_year__c c:Trigger.old)
        {
          if(c.Account__c<>null)     
            {
            parents.put(c.Account__c,new Account(id=c.Account__c));
            }
        }
        
    }
  //update parents.values();
  
}