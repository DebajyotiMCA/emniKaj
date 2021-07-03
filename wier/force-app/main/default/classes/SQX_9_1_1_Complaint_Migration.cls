/**
 * Batch processor to migrate complaint fields (Part family) and Primary Investigation fields (Defect Code, Part, Part Family) 
 * Added in version  : 9.1
 * Used for versions : less than 9.1.1
 */
public with sharing class SQX_9_1_1_Complaint_Migration implements Database.Batchable<SObject> {
    public static string STATUS_DRAFT = 'Draft';
    public static string STATUS_OPEN = 'Open';
    public static string STATUS_COMPLETE = 'Complete';
    public static string STATUS_CLOSED = 'Closed';
    
    public SQX_9_1_1_Complaint_Migration(){
    }
    
    /**
     * Gets invoked when the batch job starts and selects all complaints record
     * @param bc reference to the Database.BatchableContext object
     */
    public Database.QueryLocator start(Database.BatchableContext bc){
        Database.QueryLocator sobjecRecordList= Database.getQueryLocator([SELECT Id, compliancequest__Status__c, compliancequest__SQX_Part__c, compliancequest__SQX_Part_Family__c, compliancequest__SQX_Part__r.compliancequest__Part_Family__c,
                                                                          compliancequest__SQX_Complaint_Code__c, compliancequest__SQX_Primary_Investigation__c, compliancequest__SQX_Primary_Associated_Item__c, compliancequest__SQX_Conclusion_Code__c, compliancequest__Evaluate_Workflow__c,
                                                                          (SELECT Id, compliancequest__SQX_Complaint__c, compliancequest__SQX_Complaint__r.compliancequest__Status__c, compliancequest__Type_Of_Investigation__c,
                                                                               compliancequest__SQX_Primary_Diagnostic__c, compliancequest__Status__c, compliancequest__SQX_Part__c, compliancequest__SQX_Part_Family__c, compliancequest__SQX_Defect_Code__c,
                                                                               compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c
                                                                            FROM compliancequest__SQX_Investigations__r),
                                                                          (SELECT Id, compliancequest__SQX_Complaint__r.compliancequest__SQX_Complaint_Code__c, compliancequest__SQX_Complaint__r.compliancequest__Status__c, 
                                                                                compliancequest__SQX_Investigation__r.compliancequest__Status__c, compliancequest__SQX_Investigation__r.compliancequest__SQX_Part__c,
                                                                                compliancequest__SQX_Investigation__r.compliancequest__SQX_Part_Family__c, 
                                                                                compliancequest__SQX_Investigation__r.compliancequest__SQX_Defect_Code__c,
                                                                                compliancequest__Unique_Investigation__c, 
                                                                                compliancequest__Is_Primary__c, compliancequest__SQX_Associated_Item__c, 
                                                                                compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c, 
                                                                                compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Investigation__c,
                                                                                compliancequest__SQX_Investigation__r.compliancequest__SQX_Primary_Diagnostic__c
                                                                            FROM compliancequest__SQX_Linked_Investigations__r),
                                                                          (SELECT Id FROM compliancequest__SQX_Complaint_Contacts__r WHERE compliancequest__SQX_Type__c = null AND compliancequest__Type__c = 'Initial Reporter'),
                                                                          (SELECT Id, compliancequest__SQX_Part__c, compliancequest__SQX_Part_Family__c, compliancequest__SQX_Complaint__r.compliancequest__SQX_Complaint_Code__c, compliancequest__SQX_Primary_Investigation__c FROM compliancequest__SQX_Associated_Items__r),
                                                                          (SELECT Id, compliancequest__Step__c, compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Investigation__c, compliancequest__Status__c
                                                                           FROM compliancequest__SQX_Complaint_Tasks__r)
                                                                          FROM compliancequest__SQX_Complaint__c]);
        return sobjecRecordList;
    }
    
    /** 
     * Execute the method to set status and stage
     * @param bc reference to the Database.BatchableContext object
     * @param listsObject list of sObjects containing complaints
     */ 
    public void execute(Database.BatchableContext bc, List<SObject> listsObject) {
        List<compliancequest__SQX_Linked_Investigation__c> linkedInvestigationsToInsert = new List<compliancequest__SQX_Linked_Investigation__c>();
        List<compliancequest__SQX_Investigation__c> invToUpdate = new List<compliancequest__SQX_Investigation__c>();
        Map<Id, compliancequest__SQX_Complaint_Associated_Item__c> aiToUpdateMap = new Map<Id, compliancequest__SQX_Complaint_Associated_Item__c>();
        List<compliancequest__SQX_Linked_Investigation__c> liToUpdate = new List<compliancequest__SQX_Linked_Investigation__c>();
        List<compliancequest__SQX_Complaint_task__c> complaintStepsToUpdate = new List<compliancequest__SQX_Complaint_task__c>();
        Map<Id, Set<String>> mapCompToLinkedInv = new Map<Id, Set<String>>();
        Map<Id, Set<Id>> complaintToStepInvestigationsMap = new Map<Id, Set<Id>>();
        Map<Id, Integer> mapIdToHighestComplaintStep = new Map<Id, Integer>();
        Map<Id, String> mapIdToRegReportStep = new Map<Id, String>();
        Map<Id, List<compliancequest__SQX_Linked_Investigation__c>> associatedItemToLinkedInvestigationMap = new Map<Id, List<compliancequest__SQX_Linked_Investigation__c>>();
        Set<Id> associatedItemIds = new Set<Id>();
        List<compliancequest__SQX_Complaint_Contact__c> contactsToUpdate = new List<compliancequest__SQX_Complaint_Contact__c>();
        List<compliancequest__SQX_Picklist_Value__c> pv = [SELECT Id FROM compliancequest__SQX_Picklist_Value__c WHERE compliancequest__Category__c = 'Complaint Contact Type' AND Name  = 'Initial Reporter' LIMIT 1];
        Id pickListId = pv.size() > 0 ? pv[0].Id : null;
        Map<Id, compliancequest__SQX_Complaint__c> complaintMap = new Map<Id, compliancequest__SQX_Complaint__c>((List<compliancequest__SQX_Complaint__c>)listsObject);
        for(compliancequest__SQX_Complaint__c complaint : (List<compliancequest__SQX_Complaint__c>)listsObject){
            
            for(compliancequest__SQX_Linked_Investigation__c linkedInv : complaint.compliancequest__SQX_Linked_Investigations__r){
                if(!mapCompToLinkedInv.containsKey(complaint.Id)){
                    mapCompToLinkedInv.put(complaint.Id, new Set<String>{});
                }
                
                mapCompToLinkedInv.get(complaint.Id).add(linkedInv.compliancequest__Unique_Investigation__c);
            }

            for(compliancequest__SQX_Complaint_Associated_Item__c associatedItem : complaint.compliancequest__SQX_Associated_Items__r){
                associatedItemIds.add(associatedItem.Id);
            }
            
            for(compliancequest__SQX_Complaint_task__c complaintStep : complaint.compliancequest__SQX_Complaint_Tasks__r){
                if (complaintStep.compliancequest__SQX_Investigation__c != null) {
                    Set<Id> stepInvestigationIds = complaintToStepInvestigationsMap.get(complaint.Id);
                    if (stepInvestigationIds == null) {
                        stepInvestigationIds = new Set<Id>();
                        complaintToStepInvestigationsMap.put(complaint.Id, stepInvestigationIds);
                    }
                    stepInvestigationIds.add(complaintStep.compliancequest__SQX_Investigation__c);
                }

                // process for only non complete steps
                if (complaintStep.compliancequest__Status__c != STATUS_COMPLETE) {
                    if(!mapIdToHighestComplaintStep.containsKey(complaint.Id)){
                        mapIdToHighestComplaintStep.put(complaint.Id, Integer.valueOf(complaintStep.compliancequest__Step__c));
                    }
                    
                    
                    
                    if(mapIdToHighestComplaintStep.get(complaint.Id) < complaintStep.compliancequest__Step__c){
                        mapIdToHighestComplaintStep.put(complaint.Id, Integer.valueOf(complaintStep.compliancequest__Step__c));
                    }
                    if(complaintStep.compliancequest__Is_Regulatory_Report_Task__c){
                        if(!mapIdToRegReportStep.containsKey(complaint.Id)){
                            mapIdToRegReportStep.put(complaint.Id, complaintStep.Id);
                        }
                    }
                }
            }

            // update linked investigation with compliancequest__SQX_Associated_Item__c if 
            // 1. complaint has primary ai, complaint has primary investigation, and li does not have ai
            // also update primary ai with primary investigation.
            // Note : this type of record is possible in 9.1.0 where investigation is created from step and thus investigation does not have ai
            for(compliancequest__SQX_Linked_Investigation__c linkedInv : complaint.compliancequest__SQX_Linked_Investigations__r){
                Set<Id> invIds = complaintToStepInvestigationsMap.get(linkedInv.compliancequest__SQX_Complaint__c);
                // this type of data is created when investigation is created from step in 9.1.0
                if (invIds != null && invIds.contains(linkedInv.compliancequest__SQX_Investigation__c) 
                    && linkedInv.compliancequest__SQX_Associated_Item__c == null 
                    && linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c != null
                    && linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Investigation__c != null) {
                    String uniqueKey = '' + linkedInv.compliancequest__SQX_Complaint__c + linkedInv.compliancequest__SQX_Investigation__c + linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c;
                    // if no li already exists for the unique key then update li with putting ai and unique key too
                    if (mapCompToLinkedInv.get(linkedInv.compliancequest__SQX_Complaint__c).contains(uniqueKey) == false) {
                        // if primary ai does not have primary investigation and complaint has then transfer from complaint to ai too
                        linkedInvestigationsToInsert.add(new compliancequest__SQX_Linked_Investigation__c(Id = linkedInv.Id, 
                                   compliancequest__SQX_Associated_Item__c = linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c,
                                   compliancequest__Unique_Investigation__c = uniqueKey));

                        aiToUpdateMap.put(linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c, new compliancequest__SQX_Complaint_Associated_Item__c(
                            Id = linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c,
                            compliancequest__SQX_Primary_Investigation__c = linkedInv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Investigation__c
                        ));
                    }
                }
            }
        }
        
        Map<Id, compliancequest__SQX_Complaint_Associated_Item__c> associatedItemMap = new Map<Id, compliancequest__SQX_Complaint_Associated_Item__c>([SELECT Id, 
                                                                            (SELECT Id, compliancequest__SQX_Complaint__r.compliancequest__SQX_Complaint_Code__c,
                                                                            compliancequest__SQX_Complaint__r.compliancequest__Status__c, 
                                                                            compliancequest__SQX_Investigation__r.compliancequest__Status__c, compliancequest__SQX_Investigation__r.compliancequest__SQX_Part__c,
                                                                            compliancequest__SQX_Investigation__r.compliancequest__SQX_Part_Family__c, compliancequest__SQX_Investigation__r.compliancequest__SQX_Defect_Code__c,
                                                                            compliancequest__SQX_Investigation__c,
                                                                            compliancequest__SQX_Associated_Item__c,
                                                                            compliancequest__Unique_Investigation__c, compliancequest__Is_Primary__c FROM compliancequest__SQX_Linked_Investigations__r) FROM compliancequest__SQX_Complaint_Associated_Item__c WHERE Id = : associatedItemIds] );
        for(compliancequest__SQX_Complaint__c complaint : (List<compliancequest__SQX_Complaint__c>)listsObject){
            
            //set part family in complaint
            if(complaint.compliancequest__SQX_Part__c != null && complaint.compliancequest__SQX_Part_Family__c == null){
                complaint.compliancequest__SQX_Part_Family__c = complaint.compliancequest__SQX_Part__r.compliancequest__Part_Family__c;
            }
            
            //set complaint contact sqx type
            for(compliancequest__SQX_Complaint_Contact__c complaintContact : complaint.compliancequest__SQX_Complaint_Contacts__r){
                complaintContact.compliancequest__SQX_Type__c = pickListId;
                contactsToUpdate.add(complaintContact);
            }

            if(complaint.compliancequest__Status__c != 'Draft' && !complaint.compliancequest__Evaluate_Workflow__c){
                complaint.compliancequest__Evaluate_Workflow__c = true;
            }
            
            for(compliancequest__SQX_Complaint_Associated_Item__c associatedItem : complaint.compliancequest__SQX_Associated_Items__r) {
                if(associatedItemMap.containsKey(associatedItem.Id)) {
                    for(compliancequest__SQX_Linked_Investigation__c linkedInv : associatedItemMap.get(associatedItem.Id).compliancequest__SQX_Linked_Investigations__r){
                        
                        if(linkedInv.compliancequest__SQX_Complaint__r.compliancequest__Status__c == STATUS_OPEN || linkedInv.compliancequest__SQX_Complaint__r.compliancequest__Status__c == STATUS_COMPLETE || linkedInv.compliancequest__SQX_Complaint__r.compliancequest__Status__c == STATUS_CLOSED){
                            if(!mapCompToLinkedInv.containsKey(complaint.Id)){
                                mapCompToLinkedInv.put(complaint.Id, new Set<String>{});
                            }
                            
                            String complaintInvestigationCombination = complaint.Id +''+linkedInv.compliancequest__SQX_Investigation__c + '' + associatedItem.Id;
                            
                            // if linked investigation already exist, do not create linked investigation
                            if(!mapCompToLinkedInv.get(complaint.Id).contains(complaintInvestigationCombination)){
                                compliancequest__SQX_Linked_Investigation__c linkedInvestigation = new compliancequest__SQX_Linked_Investigation__c(
                                    compliancequest__SQX_Investigation__c = linkedInv.compliancequest__SQX_Investigation__c,
                                    compliancequest__SQX_Complaint__c = complaint.Id,
                                    compliancequest__SQX_Associated_Item__c = associatedItem.Id,
                                    compliancequest__Unique_Investigation__c = '' + complaint.Id + linkedInv.compliancequest__SQX_Investigation__c + associatedItem.Id
                                );
                                mapCompToLinkedInv.get(complaint.Id).add(complaintInvestigationCombination);
                                linkedInvestigationsToInsert.add(linkedInvestigation);
                            }
                            if(associatedItem.compliancequest__SQX_Primary_Investigation__c == null){
                                    
                                if(associatedItem.compliancequest__SQX_Complaint__r.compliancequest__SQX_Complaint_Code__c == linkedInv.compliancequest__SQX_Investigation__r.compliancequest__SQX_Defect_Code__c && 
                                   associatedItem.compliancequest__SQX_Part_Family__c != null && associatedItem.compliancequest__SQX_Part_Family__c == linkedInv.compliancequest__SQX_Investigation__r.compliancequest__SQX_Part_Family__c && 
                                   (linkedInv.compliancequest__SQX_Investigation__r.compliancequest__SQX_Part__c == null || (associatedItem.compliancequest__SQX_Part__c == linkedInv.compliancequest__SQX_Investigation__r.compliancequest__SQX_Part__c)
                                   )
                                  ){
                                    // if this ai is not processed already then only process
                                    if (!aiToUpdateMap.containsKey(associatedItem.Id)) {
                                        associatedItem.compliancequest__SQX_Primary_Investigation__c =  linkedInv.compliancequest__SQX_Investigation__c;
                                        aiToUpdateMap.put(associatedItem.Id, associatedItem);
                                    }
                                    if(linkedInv.compliancequest__SQX_Investigation__r.compliancequest__Status__c == 'Completed'){
                                        complaint.compliancequest__SQX_Conclusion_Code__c = complaint.compliancequest__SQX_Conclusion_Code__c == null ? linkedInv.compliancequest__SQX_Investigation__r.compliancequest__SQX_Primary_Diagnostic__c : complaint.compliancequest__SQX_Conclusion_Code__c; 
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //create linked investigation and set primary investigation in complaint
            for(compliancequest__SQX_Investigation__c inv : complaint.compliancequest__SQX_Investigations__r){
                inv.compliancequest__SQX_Defect_Code__c = complaint.compliancequest__SQX_Complaint_Code__c;
                inv.compliancequest__SQX_Part_Family__c = complaint.compliancequest__SQX_Part__r.compliancequest__Part_Family__c;
                inv.compliancequest__SQX_Part__c = complaint.compliancequest__SQX_Part__c;
                if(String.isBlank(inv.compliancequest__Type_Of_Investigation__c)){
                    inv.compliancequest__Type_Of_Investigation__c = 'Complaint Investigation';
                }
                // assumption is that there won't be primary ai with complaint here as ai part is already processed above
                if(inv.compliancequest__SQX_Complaint__r.compliancequest__SQX_Primary_Associated_Item__c == null && (inv.compliancequest__SQX_Complaint__r.compliancequest__Status__c == STATUS_OPEN || inv.compliancequest__SQX_Complaint__r.compliancequest__Status__c == STATUS_COMPLETE || inv.compliancequest__SQX_Complaint__r.compliancequest__Status__c == STATUS_CLOSED)) {
                    
                    if(!mapCompToLinkedInv.containsKey(complaint.Id)){
                        mapCompToLinkedInv.put(complaint.Id, new Set<String>{});
                    }
                    
                    String complaintInvestigationCombination = complaint.Id +''+inv.Id + 'null';
                    
                    // if linked investigation already exist, do not create linked investigation
                    if(!mapCompToLinkedInv.get(complaint.Id).contains(complaintInvestigationCombination)){
                        compliancequest__SQX_Linked_Investigation__c linkedInvestigation = new compliancequest__SQX_Linked_Investigation__c(
                            compliancequest__SQX_Investigation__c = inv.Id,
                            compliancequest__SQX_Complaint__c = inv.compliancequest__SQX_Complaint__c,
                            compliancequest__Unique_Investigation__c = '' + inv.compliancequest__SQX_Complaint__c + inv.Id
                        );
                        mapCompToLinkedInv.get(complaint.Id).add(complaintInvestigationCombination);
                        linkedInvestigationsToInsert.add(linkedInvestigation);
                    }

                    if(complaint.compliancequest__SQX_Primary_Investigation__c == null){
                        if(complaint.compliancequest__SQX_Complaint_Code__c == inv.compliancequest__SQX_Defect_Code__c && 
                           complaint.compliancequest__SQX_Part_Family__c != null && complaint.compliancequest__SQX_Part_Family__c == inv.compliancequest__SQX_Part_Family__c && 
                           (inv.compliancequest__SQX_Part__c == null || (complaint.compliancequest__SQX_Part__c == inv.compliancequest__SQX_Part__c)
                           )
                          ){
                            complaint.compliancequest__SQX_Primary_Investigation__c = inv.Id;
                            if(inv.compliancequest__Status__c == 'Completed'){
                                complaint.compliancequest__SQX_Conclusion_Code__c = complaint.compliancequest__SQX_Conclusion_Code__c == null ? inv.compliancequest__SQX_Primary_Diagnostic__c : complaint.compliancequest__SQX_Conclusion_Code__c; 
                            }
                        }
                    }
                }
                invToUpdate.add(inv);
            }
            
            //update regulatory report complaint task's step to highest step
            if(mapIdToRegReportStep.containsKey(complaint.Id) && mapIdToHighestComplaintStep.containsKey(complaint.Id)){
                compliancequest__SQX_Complaint_Task__c cStep = new compliancequest__SQX_Complaint_Task__c();
                cStep.Id = mapIdToRegReportStep.get(complaint.Id);
                cStep.compliancequest__Step__c = mapIdToHighestComplaintStep.get(complaint.Id);
                complaintStepsToUpdate.add(cStep);
            }
            
            
        }
        //update investigations
        
        if(invToUpdate.size() > 0){
            Database.update(invToUpdate, true);}
        
        //update regulatory reports complaint step
        if(complaintStepsToUpdate.size() > 0){
            Database.update(complaintStepsToUpdate, true);
        }
        
        //update complaints
        Database.update(listsObject, true);

        // Update AI
        Database.update(aiToUpdateMap.values(), true);
        
        //insert linked investigations
        if(linkedInvestigationsToInsert.size() > 0){
            Database.upsert(linkedInvestigationsToInsert, true);
        }
        
        //update complaint contacts
        if(contactsToUpdate.size() > 0){
            Database.update(contactsToUpdate, true);
        }
    }
    
    /** 
     * Used to execute post-processing operations and is called once after all batches are processed
     * @param bc reference to the Database.BatchableContext object
     */
    public void finish(Database.BatchableContext bc){
        
    }
}