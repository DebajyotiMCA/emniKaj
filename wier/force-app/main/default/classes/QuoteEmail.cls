public with sharing class QuoteEmail 
{

    public String cemail {get; set;}
    public String oppid {get; set;}
    public String quotationname  {get; set;}
    public String semail {get; set;}
    public String subject{get; set;}
    public String body{get; set;}
    public ID Qid;
    public QuoteEmail() 
    {
      
       body ='';
       Qid= ApexPages.currentPage().getParameters().get('qid');  
       oppid = ApexPages.currentPage().getParameters().get('oppid');
       quotationname = ApexPages.currentPage().getParameters().get('qname');
       String userName = UserInfo.getUserName();
       User activeUser = [Select Email From User where Username = : userName limit 1];
       semail = activeUser.Email;
       subject = 'Quotation (Our Ref:'+oppid+'/'+quotationname+')';
    }
    public PageReference sendEmail()
    {
     try
     {
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', cemail))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please provide valid email address.'));
            return null; 
        }
        else
        {
           Quotation__c qfinal = [select id,COpportunity__r.status__c, final__c from Quotation__c where id=:Qid limit 1];
           if(qfinal.final__c ==true && qfinal.COpportunity__r.status__c=='Quote Ready for Submital')
           {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                String[] toAddresses = new String[] {cemail};  
                String[] ccAddresses = new String[] {semail};  
                mail.setToAddresses(toAddresses);  
                mail.setCcAddresses(ccAddresses);  
                mail.setReplyTo(cemail);  
                mail.setSenderDisplayName(UserInfo.getUseremail()); 
                mail.setSubject(subject);  
                mail.setBccSender(false);  
                mail.setUseSignature(true);  
                mail.setPlainTextBody(body);  
                //mail.setHtmlBody(‘<b> This is HTML body </b>’ );  
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();  
                for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :Qid])
                {  
                     Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                     efa.setFileName(a.Name);  
                     efa.setBody(a.Body);  
                     fileAttachments.add(efa);  
                    //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});  
                }  
                mail.setFileAttachments(fileAttachments);  
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                qfinal.Quote_Submitted_to_Customer__c =true;
                update qfinal;
              }
              else
              {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Quotation must be approved before sending toCustomer.'));
                return null; 
              }
           }   
         } 
     catch(DMLException e) 
     {
     }    
     return new PageReference('javascript:self.close()'); 
  }

}