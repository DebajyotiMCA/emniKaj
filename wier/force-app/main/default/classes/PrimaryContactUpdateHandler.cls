/** ========================================================================================
* Class Name               : PrivateContactUpdateHandler
* Description              : Auto updation of Primary Contact on selecting an Account.  
* Created Date             : [22-03-2020]
* Created By               : Srinivas C [Salesforce Developer]
* Organization             : coServe Software Solutions
*
* Date Modified                Modified By                  Description of the update
*    ----                         ----                              ----  ----
============================================================================================ */

public class PrimaryContactUpdateHandler 
{
    public static Boolean isFirstTime = true;
    public static void ContactUpdate(Id recordId, Id AccountId)
    {
        Map<Id, compliancequest__SQX_Complaint__c> Updateall = new map<Id, compliancequest__SQX_Complaint__c>();
        Map<Id, Contact> conMap = new Map<Id, Contact>([select id,Primary_Contact__c from contact where Account.id =: AccountId]);
        for(Contact cont : conMap.values())
        {
            if(cont.Primary_Contact__c == true)
            {
                compliancequest__SQX_Complaint__c comp = new compliancequest__SQX_Complaint__c();
                comp.Id=recordId;
                comp.compliancequest__SQX_External_Contact__c = cont.id;
                Updateall.put(comp.Id, comp);
            }
        }
        update Updateall.values();
    }
}