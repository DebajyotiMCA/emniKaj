trigger triggerParentOpty on COpportunity__c(after insert, after update, after delete, after undelete) {
    Map<Id,Account> parents = new Map<Id,Account>();
    
    if(Trigger.new<>null){
        for(COpportunity__c c:Trigger.new){
            if(c.Customer__c<>null)
                parents.put(c.Customer__c,new Account(id=c.Customer__c));
        }
    }
  
    if(Trigger.old<>null){    
        for(COpportunity__c c:Trigger.old){
            if(c.Customer__c <>null){
                parents.put(c.Customer__c,new Account(id=c.Customer__c));
            }
        }
    }
  //update parents.values();
  
    if(Trigger.isUpdate && Trigger.isAfter){
        
        for(COpportunity__c opp : trigger.new){
            if(opp.Tendering_Manager__c != null && opp.Is_this_opp_a_project__c == true && trigger.oldMap.get(opp.Id).Is_this_opp_a_project__c == false){
                System.debug('test');
                COpportunity__Share jobShr1 = new COpportunity__Share();
                jobShr1.AccessLevel= 'Read';
                jobShr1.ParentId = opp.id;
                jobShr1.UserOrGroupId = opp.Tendering_Manager__c;
                
                jobShr1.RowCause = Schema.COpportunity__Share.RowCause.Manual;
                Database.SaveResult sr = Database.insert(jobShr1,false);
                
                if(sr.isSuccess()){
                    System.debug('success');
                } else {
                    // Get first save result error.
                    Database.Error err = sr.getErrors()[0];
             
                    if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                       err.getMessage().contains('AccessLevel')){
                           System.debug('eror+'+err.getMessage());
                       }
                    else{
                        System.debug('eror+'+err.getMessage());
                    }
            	} 
            }
        }
    } 
  
}