public with sharing class wr_CostSheet {

    Public CostSheet__c  cs{get; set;}
    public Attachment tAttachment{get;set;}
    public ID cid {get; set;}
    public wr_CostSheet(ApexPages.StandardController controller)
    {
       cs = new  CostSheet__c();
       cs.COpportunity__c = ApexPages.currentPage().getParameters().get('oppid');
       this.tAttachment = new Attachment();  
    }
   public pagereference csave()
   {
      try
      {
             
             CostSheet__c c = new CostSheet__c();
             c.Comment_if_any__c = cs.Comment_if_any__c;
             c.COpportunity__c = cs.COpportunity__c;
             c.CurrencyIsoCode = cs.CurrencyIsoCode;
             c.Labour_Cost__c = cs.Labour_Cost__c;
             c.Material_Cost__c = cs.Material_Cost__c;
             c.Other_cost__c = cs.Other_cost__c;
             //c.Total_cost__c= cs.Total_cost__c;
             c.Discount_amount_if_any__c = cs.Discount_amount_if_any__c;
             c.Upsell_amount_if_any__c = cs.Upsell_amount_if_any__c;
             c.Cost_Sheet_Amount__c =cs.Cost_Sheet_Amount__c; // selling price
             //c.Gross_Margin__c = cs.Gross_Margin__c;
            // c.Cost_sales_ratio__c = cs.Cost_sales_ratio__c; 
              // c.Discount__c = cs.Discount__c;
              c.Cost_Sheet_Preparation_Date__c =cs.Cost_Sheet_Preparation_Date__c;
              c.Cost_Sheet_Contents__c = cs.Cost_Sheet_Contents__c;
              Integer count = [select count() from CostSheet__c where COpportunity__c=:cs.COpportunity__c];
              if(count ==0)
              {
                 c.Cost_Sheet_Version__c ='V'+1;
              }
              else
              {
                 integer n =  count +1;
                 c.Cost_Sheet_Version__c ='V'+n;
              }
              if(tAttachment.Name!=null)
              //if(attname !=null)
              {
                    insert c;
                    cid  = c.id;
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
      PageReference pg = new PageReference('/'+cid);
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