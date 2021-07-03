public with sharing class weir_poattachments 
{
    Public PO_Attachments__c  poa {get; set;}
    public Attachment tAttachment{get;set;}
    public ID poaid {get; set;}
    public weir_poattachments(ApexPages.StandardController controller) 
    {
       poa = new  PO_Attachments__c ();
       poa.Opportunity__c = ApexPages.currentPage().getParameters().get('CF00Ng0000000boAK_lkid');
       this.tAttachment = new Attachment();
    }
    public pagereference csave()
    {
      try
      {
        
         PO_Attachments__c  c = new PO_Attachments__c();
         c.Opportunity__c = poa.Opportunity__c;
         c.CurrencyIsoCode = poa.CurrencyIsoCode;
         c.PO_Amount__c =poa.PO_Amount__c;
         c.Customer_document_reference__c =poa.Customer_document_reference__c;
         c.Info_clarification_reqd_from_customer__c =poa.Info_clarification_reqd_from_customer__c;
         c.PO_handed_over_to_contract__c =poa.PO_handed_over_to_contract__c;
         c.comments_if_any__c = poa.comments_if_any__c;
         c.Delivery_due_date_as_per_Customer_Order__c = poa.Delivery_due_date_as_per_Customer_Order__c;
         if(tAttachment.Name!=null)
         {
                 insert c;
                 poaid= c.id;
                 doUploadFile(c.ID);
                 PageReference pg = new PageReference('/'+poaid);
                 return pg;
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
      }
      return null;
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
       try
       {
           Database.Insert(att);
       }
       catch(exception ex)
       {
       
       }
   }
}