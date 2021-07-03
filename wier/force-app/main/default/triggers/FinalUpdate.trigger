trigger FinalUpdate on Quotation__c (after update) 
{
  Public ID qid;
  Public Id oppid;
  public Boolean qfinal;
  static boolean already=false;
  Quotation__c[] qc= Trigger.new;
  List<Quotation__c> quotationlistexist = new List<Quotation__c>();
  List<Quotation__c> quotationlistupdate = new List<Quotation__c>();
  for(Quotation__c q : qc)
  {
     qid = q.id;
     oppid = q.COpportunity__c; 
     qfinal= q.Final__c; 
  }
  if(qfinal==TRUE && Trigger.old[0].Final__c==false)
  {
    quotationlistexist = [select id,Final__c from Quotation__c where COpportunity__c=:oppid and final__c=true];
    
    if(quotationlistexist.size()>0)
    {
      for(Quotation__c qe:quotationlistexist)
      {
        Quotation__c qu = new Quotation__c();
        qu.id = qe.id;
        if(qe.id!=qid)
        {
            qu.Final__c = FALSE;
        }
        quotationlistupdate.add(qu);
      }
      update quotationlistupdate;
    }
  }
}