/***************************CLASS DETAIL******************************
 * This is an extension class to configure controlled document pages
 *
 * ********************Revision History******************************
 * 
 * ******************************************************************/

public with sharing class CQ_CCC_Extension_Controlled_Document {
    private compliancequest__SQX_Controlled_Document__c doc;
    private ApexPages.StandardController mainController;
    
    /**
     * Constructor
     */
    public CQ_CCC_Extension_Controlled_Document(ApexPages.StandardController controller) {
        mainController = controller;
        doc = (compliancequest__SQX_Controlled_Document__c) controller.getRecord();

        for(RecordTypeInfo rInfo : compliancequest__SQX_Controlled_Document__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(doc.RecordTypeId == null && doc.Id == null) {
                //identify the default record type and assign it to the record
                if(rInfo.isDefaultRecordTypeMapping()) {
                    doc.RecordTypeId = rInfo.getRecordTypeId();
                }
            }

        }
    }
    
    /**
     *   This method returns the latest approval process for the current document based on the Change order reference or Controlled Doc itself.
     *   If the reference to change order is present, the priority is given to the Change order approvals.
     *   @return ProcessInstanceWithType which is a wrapper class for Process Instance and it's Type as well.
     */
    public ProcessInstanceWithType getCOOrCDLatestApprovalProcess() {
        compliancequest__SQX_Controlled_Document__c docmnt = [SELECT compliancequest__SQX_Change_Order__c,
                                                              compliancequest__SQX_Change_Order__r.compliancequest__Status__c,
                                                              compliancequest__SQX_Change_Order__r.compliancequest__Approval_Status__c
                                                              FROM compliancequest__SQX_Controlled_Document__c
                                                              WHERE Id = : doc.Id];
        boolean hasChangeOrder = docmnt.compliancequest__SQX_Change_Order__c != null;
        boolean isChangeOrderImplementationApproved = false;
        isChangeOrderImplementationApproved = hasChangeOrder &&
                                              docmnt.compliancequest__SQX_Change_Order__r.compliancequest__Approval_Status__c =='Implementation Approved';

        ProcessInstance latestInstance;
        List < ProcessInstance > latestApprovalInstances = new List < ProcessInstance > ();
        Id targetId = isChangeOrderImplementationApproved ? docmnt.compliancequest__SQX_Change_Order__c : doc.Id;

        latestApprovalInstances = [SELECT ( SELECT Id, ProcessInstanceId,ProcessNodeId,ProcessNode.Name,TargetObjectId, CreatedDate, StepStatus, IsPending,
                                                                ActorId, OriginalActorId, OriginalActor.Name, Comments, Actor.Name, Actor.UserRole.Name
                                                                FROM StepsAndWorkitems
                                                                ORDER BY IsPending DESC, CreatedDate DESC, Id DESC),
                                                        Status
                                                        FROM ProcessInstance
                                                        WHERE TargetObjectId = :targetId
                                                        ORDER BY CreatedDate DESC, Id DESC];
        if (latestApprovalInstances.size() > 0) {

            latestInstance = latestApprovalInstances.get(0);
        }

        ProcessInstanceWithType processInstanceWithType = new ProcessInstanceWithType(latestInstance, isChangeOrderImplementationApproved);
        return processInstanceWithType;
    }

    /**
    *Get processinstance items
    */
    public class ProcessInstanceWithType{
        public ProcessInstance Instance {get; private set;}
        public Boolean isChangeOrderImplementationApproved {get; private set;}
        public ProcessInstanceWithType(ProcessInstance processInstance, Boolean isChangeOrderImplementationApproved){
            this.Instance = processInstance;
            this.isChangeOrderImplementationApproved = isChangeOrderImplementationApproved;
        }
    }

    /**
    *   This method is to get latest 3 revisions of controlled document
    *   @return List<compliancequest__SQX_Controlled_Document__c> is the list of revision of controlled document
    */
    public List<compliancequest__SQX_Controlled_Document__c> getLatestRevisions() {
        String documentNumber = doc.compliancequest__Document_Number__c.toUpperCase();
        List<compliancequest__SQX_Controlled_Document__c> revisions = [SELECT Id,
                                                    Name,
                                                    compliancequest__Revision__c,
                                                    compliancequest__Title__c,
                                                    compliancequest__Effective_Date__c,
                                                    compliancequest__Document_Status__c,
                                                    compliancequest__Date_Issued__c,
                                                    compliancequest__Changes__c,
                                                    compliancequest__Change_Scope__c,
                                                    compliancequest__Document_Number__c,
                                                    RecordTypeId,
                                                    compliancequest__Duration__c,
                                                    compliancequest__Expiration_Date__c
                                                FROM compliancequest__SQX_Controlled_Document__c
                                                WHERE compliancequest__Document_Number__c = :documentNumber
                                                ORDER BY compliancequest__Document_Number__c, compliancequest__Date_Issued__c DESC NULLS FIRST, compliancequest__Revision__c DESC NULLS LAST
                                                LIMIT 3];
        List<compliancequest__SQX_Controlled_Document__c> latestRevisions = new List<compliancequest__SQX_Controlled_Document__c>();
        for(Integer i = revisions.size() -1; i>=0; i--){
            latestRevisions.add(revisions[i]);
        }
        return latestRevisions;
    }
}