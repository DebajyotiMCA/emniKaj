trigger RFQToOpportunity on RFQ__c (after insert) 
{
   RFQ__c[] rfq = Trigger.new;
   Weir_CreateOppController.CreateOpportunity(rfq);
}