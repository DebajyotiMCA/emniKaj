/***************************CLASS DETAIL******************************
 * This is the test class for CQ extension class to configure controlled document pages
 *
 * ********************Revision History******************************
 * 
 * ******************************************************************/
@IsTest
public class CQ_CCC_Test_Ext_Controlled_Doc {
    
     testmethod static void GivenAControlledDocument_WhenRelatedAccountIsAdded_TopicIsCreated() {
        // create change order
        compliancequest__SQX_Change_Order__c co = new compliancequest__SQX_Change_Order__c(
            compliancequest__Title__c='changeorder',
            compliancequest__Description__c = 'Description',
            compliancequest__Justification__c='Justification',
            compliancequest__Change_Category__c='ECO',
            compliancequest__Priority__c='Normal',
            compliancequest__Submitted_Date__c= date.today(),
            compliancequest__Target_Completion_Date__c=date.today()
        );
        insert co;
        // create doc
        compliancequest__SQX_Controlled_Document__c doc = new compliancequest__SQX_Controlled_Document__c();
        doc.compliancequest__Title__c = 'test title';
        doc.compliancequest__Document_Category__c = 'Internal';
        doc.compliancequest__Document_Number__c = 'TestDocNumber';
        doc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Controlled_Document' AND SObjectType = 'compliancequest__SQX_Controlled_Document__c'].Id;
        doc.compliancequest__SQX_Change_Order__c = co.Id;

        apexPages.StandardController controller = new apexPages.StandardController(doc);
        CQ_CCC_Extension_Controlled_Document ext = new CQ_CCC_Extension_Controlled_Document(controller);

        insert doc;
                   
                
        compliancequest__SQX_Controlled_Document__c document = [SELECT id,
                                                                compliancequest__Draft_Vault__c,
                                                                compliancequest__Release_Vault__c
                                                                FROM compliancequest__SQX_Controlled_Document__c][0];
        
        
        CQ_CCC_Extension_Controlled_Document dc = new CQ_CCC_Extension_Controlled_Document(new ApexPages.StandardController(doc));

        dc.getCOOrCDLatestApprovalProcess();
     }
    
    
    /**
     * This test ensures that record type id of the controlled doc is set correctly
     * for a controlled doc. Upon calling the extension
     */
    static testmethod void ensureDefaultRecordTypeIsSetForTheUser() {
        //Arrange: Identify the default record type
        Id defaultRecordTypeId = null;
        for(RecordTypeInfo rInfo : compliancequest__SQX_Controlled_Document__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(rInfo.isDefaultRecordTypeMapping()) {
                defaultRecordTypeId = rInfo.getRecordTypeId();
            }
        }

        //Act: Call the extension
        compliancequest__SQX_Controlled_Document__c doc = new compliancequest__SQX_Controlled_Document__c();
        new CQ_CCC_Extension_Controlled_Document(new ApexPages.StandardController(doc));

        //Assert: Ensure that default record type is set
        System.assertEquals(defaultRecordTypeId, doc.RecordTypeId);
    }

    /**
    * This test ensures that latest 3 revision is returned for a controlled document when calling getLatestRevisions
    * from extension
    */
    static testmethod void GivenControlledDocumentWithMoreThanThreeRivisionsIsAdded_WhenGetLatestRevisionIsCalled_ThenLatestThreeRivisionIsReturned() {
        // create change order
        compliancequest__SQX_Change_Order__c co1 = new compliancequest__SQX_Change_Order__c(
            compliancequest__Title__c='changeorder1',
            compliancequest__Description__c = 'Description',
            compliancequest__Justification__c='Justification',
            compliancequest__Change_Category__c='ECO',
            compliancequest__Priority__c='Normal',
            compliancequest__Submitted_Date__c= date.today(),
            compliancequest__Target_Completion_Date__c=date.today()
               
        );
        insert co1;

        //Given: Controlled Document
        compliancequest__SQX_Controlled_Document__c doc = new compliancequest__SQX_Controlled_Document__c();
        doc.compliancequest__Title__c = 'Controlled Document Test';
        doc.compliancequest__Document_Category__c = 'Internal';
        doc.compliancequest__Document_Number__c = 'TestDocNumber';
        doc.compliancequest__Revision__c = '1';
        doc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Controlled_Document' AND SObjectType = 'compliancequest__SQX_Controlled_Document__c'].Id;
        doc.compliancequest__SQX_Change_Order__c= CO1.Id;
        insert doc;

        //Adding more than 3 revisions
        String firstRev = '2';
        compliancequest__SQX_Controlled_Document__c firstRevision = doc.clone(false, false, false, false);
        firstRevision.compliancequest__Revision__c = firstRev;
        insert firstRevision;

        String secondRev = '3';
        compliancequest__SQX_Controlled_Document__c secondRevision = firstRevision.clone(false, false, false, false);
        secondRevision.compliancequest__Revision__c = secondRev;
        insert secondRevision;

        String thirdRev = '4';
        compliancequest__SQX_Controlled_Document__c thirdRevision = secondRevision.clone(false, false, false, false);
        thirdRevision.compliancequest__Revision__c = thirdRev;
        insert thirdRevision;

        String fourthRev = '5';
        compliancequest__SQX_Controlled_Document__c fourthRevision = thirdRevision.clone(false, false, false, false);
        fourthRevision.compliancequest__Revision__c = fourthRev;
        insert fourthRevision;

        //When: Get Latest Revisions is called of extension
        CQ_CCC_Extension_Controlled_Document ext = new CQ_CCC_Extension_Controlled_Document(new ApexPages.StandardController(doc));
        List<compliancequest__SQX_Controlled_Document__c> latestRevisions = ext.getLatestRevisions();

        //Then: Latest 3 Revisions is returned
        //Assert: Size of returned revisions is not more than 3
        System.assertEquals(3, latestRevisions.size(), 'Error more than three revisions returned');

        //Assert: All revisions returned are latest ones
        for(compliancequest__SQX_Controlled_Document__c controlledDocument : latestRevisions) {
            System.assertNotEquals('1', controlledDocument.compliancequest__Revision__c, 'Latest revision not returned');
            System.assertNotEquals(firstRev, controlledDocument.compliancequest__Revision__c, 'Latest revision not returned');
        }
    }
}