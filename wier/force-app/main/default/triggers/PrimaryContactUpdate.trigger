/** ========================================================================================
* Trigger Name             : PrivateContactUpdate-Trigger
* Description              : Auto updation of Primary Contact on selecting an Account.  
* Created Date             : [22-03-2020]
* Created By               : Srinivas C [Salesforce Developer]
* Organization             : coServe Software Solutions
*
* Date Modified                Modified By                  Description of the update
*    ----                         ----                              ----  ----
============================================================================================ */

trigger PrimaryContactUpdate on compliancequest__SQX_Complaint__c (after insert, after update) 
{
    if(trigger.isInsert || trigger.isUpdate){
        if(PrimaryContactUpdateHandler.isFirstTime)
        {
            PrimaryContactUpdateHandler.isFirstTime = false;
            for(compliancequest__SQX_Complaint__c c : trigger.new)
            {
                PrimaryContactUpdateHandler.ContactUpdate(c.Id,c.compliancequest__SQX_Account__c);
            }
        }
    }
}