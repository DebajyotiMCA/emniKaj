trigger UpdateLeadStatus on Call_Report__c (before insert) 
{
   public String lid ;
   public String oid ;
   Public Boolean check;
   Call_Report__c[] c = Trigger.new;
   for(Call_Report__c ta :c)
   {
       lid = ta.Lead__c;
       oid  = ta.Opportunity__c;
       check=ta.Contacted_Spoken__c;  
   }
 if(lid!=null && check==TRUE)
  {
      Lead l =[select ID, status from Lead where id=:lid];
      if(l.Status=='Open')
      {
         l.status='Contacted';
         l.id =lid;
         update l;    
      } 
  }
  if(oid!=null && check==TRUE)
  {
      COpportunity__c o =[select ID, Status__c from COpportunity__c where id=:oid];
      if(o.Status__c=='Quote Submitted to Customer')
      {
         o.Status__c ='Customer Contacted for Submitted quote';
         o.id =oid;
         update o;    
      } 
  }
   
}