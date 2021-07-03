Public with sharing class SendemailController
{
   Public void sendEmailFunction(Task[] t)
   {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String[] toAddresses = new String[] {t[0].Assigned_To_CRM_User__c}; 
      mail.setToAddresses(toAddresses);
      //mail.setReplyTo('sampath@aphidas.com');
      mail.setSenderDisplayName('Task');
      mail.setSubject(t[0].Subject);
      mail.setBccSender(false);
      mail.setUseSignature(false);
      //mail.setPlainTextBody('This is test email body. This mail is being sent from apex code');
      mail.setHtmlBody('<table><tr><td colspan="2"><b> Please find the task information below.</b></td></tr>'+
                              '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>'+
                              '<tr><td><b>Title : &nbsp; &nbsp;</b></td><td>'+t[0].subject+'</td></tr>'+
                              '<tr><td><b>status : &nbsp; &nbsp;</b></td><td>'+t[0].Status+'</td></tr>'+
                              '<tr><td><b>Due Date: &nbsp; &nbsp;</b></td><td>'+t[0].ActivityDate+'</td></tr>'+
                              '<tr><td colspan="2"><b>Action Point: &nbsp; &nbsp;</b><br/>'+t[0].Description+'</td></tr>'+
                        '</table>');
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
  

 
}