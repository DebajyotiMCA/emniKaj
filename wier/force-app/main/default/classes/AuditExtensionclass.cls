public class AuditExtensionclass {
    public compliancequest__SQX_Audit__c aud    { get; set; }
    public List<compliancequest__SQX_Audit_Team__c> aud_team{get;set;}
    public string team{get;set;}
     public integer Major {get;set;}
     public integer Minor {get;set;}
     public integer Observations{get;set;}
        public List<compliancequest__SQX_Finding__c> fin_list{get;set;}

    public AuditExtensionclass (ApexPages.StandardController ctd) 
    {
        team='';
        integer count=1;
        Major=0;
    Minor =0;
    Observations=0;
        String Aud_ID= ApexPages.currentPage().getParameters().get('id');
        aud=new compliancequest__SQX_Audit__c();
         system.debug('aud'+Aud_ID);
        try{
            aud=[select id,name from compliancequest__SQX_Audit__c where id=:aud_id limit 1];
           
            aud_team=[select id from compliancequest__SQX_Audit_Team__c where compliancequest__SQX_Audit__c=:aud.id];
            for(compliancequest__SQX_Audit_Team__c aud_team:[select id,compliancequest__SQX_User__r.name 
                                                             from compliancequest__SQX_Audit_Team__c 
                                                             where compliancequest__SQX_Audit__c=:aud.id])
            {
                
                team+=count+'.'+aud_team.compliancequest__SQX_User__r.name+'\n\n';
                count++;
            }
               for(compliancequest__SQX_Finding__c fin:[select id,compliancequest__Finding_Type__c,
                                                        compliancequest__Criterion_Section__c,
                                                        compliancequest__Criterion_Sub_Section__c,
                                                        compliancequest__Description__c
                                                             from compliancequest__SQX_Finding__c 
                                                             where compliancequest__SQX_Audit__c=:aud.id])
               {
                   if(fin.compliancequest__Finding_Type__c=='Major')
                   {
                       Major++;
                   }
                   else if(fin.compliancequest__Finding_Type__c=='Minor')
                   {
                       Minor++;
                   }
                   else if(fin.compliancequest__Finding_Type__c=='Observation')
                   {
                       Observations++;
                   }
               }
            fin_list=[select id,compliancequest__Finding_Type__c,
                                                        compliancequest__Criterion_Section__c,
                                                        compliancequest__Criterion_Sub_Section__c,
                                                        compliancequest__Description__c,compliancequest__Title__c
                                                             from compliancequest__SQX_Finding__c 
                                                             where compliancequest__SQX_Audit__c=:aud.id];
 
        }
        catch(exception e)
        {
            system.debug('e'+e);
        }
        
        
    }
    
}