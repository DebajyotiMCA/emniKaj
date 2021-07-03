/** ========================================================================================
* Trigger Name             : PrivateContactUpdate
* Class Name               : PrivateContactUpdateHandler
* TestClass Name           : PrivateContactUpdateHandlerTest
* Description              : Auto updation of Primary Contact on selecting an Account.  
* Created Date             : [06-04-2020]
* Created By               : Srinivas C [Salesforce Developer]
* Organization             : coServe Software Solutions
*
* Date Modified                Modified By                  Description of the update
*    ----                         ----                              ----  ----
============================================================================================ */
@isTest
public class PrimaryContactUpdateHandlerTest
{
    static testmethod void UpdateContact()
    {
        Id RecordTypeId = [select id, Name from recordtype where SObjectType = 'Account' AND DeveloperName = 'Customer_Account'].id;
        
        Account LinkedAcc = new Account(RecordTypeId = RecordTypeId, Name='ComplaintRecord');
        insert LinkedAcc;
        
        Contact LinkedCon = new Contact(LastName='ComplaintContact', AccountId=LinkedAcc.id, Primary_Contact__c=true);
        insert LinkedCon;
        
        compliancequest__SQX_Complaint__c comp = new compliancequest__SQX_Complaint__c();
        comp.compliancequest__SQX_Account__c = LinkedAcc.Id;
        insert comp;
        comp.compliancequest__SQX_External_Contact__c = LinkedCon.id;
        
        test.startTest();
        PrimaryContactUpdateHandler op = new PrimaryContactUpdateHandler();
        update comp;
        test.stopTest();
    }
}