public with sharing class wr_Quotation 
{
    Public Quotation__c  q {get; set;}
    public Attachment tAttachment{get;set;}
    public ID qid {get; set;}
    public wr_Quotation(ApexPages.StandardController controller) 
    {
       q = new   Quotation__c ();
       q.COpportunity__c = ApexPages.currentPage().getParameters().get('oppid');
       this.tAttachment = new Attachment();
    }
   public pagereference csave()
   {
      try
      {
         
        
             Quotation__c  c = new Quotation__c();
             c.CurrencyIsoCode = q.CostSheet__r.CurrencyIsoCode;
             c.COpportunity__c = q.COpportunity__c;
             c.CostSheet__c =q.CostSheet__c;
             c.Movex_Co_No__c =q.Movex_Co_No__c;
             c.Movex_quotation_docs_serial_no__c =q.Movex_quotation_docs_serial_no__c;
             c.Comment_if_any__c = q.Comment_if_any__c;
             c.Submit_for_review__c = q.Submit_for_review__c;
             
             Integer count = [select count() from Quotation__c where COpportunity__c=:q.COpportunity__c];
             if(count ==0)
             {
              c.Quotation_version__c ='V'+1;
             }
             else
             {
                  integer n =  count +1;
                  c.Quotation_version__c ='V'+n;
             }
         if(tAttachment.Name!=null)
         {
             insert c;
             qid  = c.id;
             doUploadFile(c.ID);
          }
          else
          {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please attach the file.');
            ApexPages.addMessage(myMsg);
            return null;
          }
      }
      catch(Exception e)
      {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
          ApexPages.addMessage(myMsg);
          return null;
      }
      PageReference pg = new PageReference('/'+qid);
      return pg;
   }
   public void doUploadFile(ID csqid)
   {
        List<Attachment> att = new List<Attachment >();
        Attachment a = this.tAttachment.clone(false, true, false, false);
        a.OwnerId = UserInfo.getUserId();
        //record attachment associated with
        a.ParentId = csqid;
        att.add(a);
        //clear body of uploaded file to remove from view state
        this.tAttachment.Body = null;
        //create the attachment
       try{Database.Insert(att);}
       catch(exception ex){
       
       }
 
    }

}