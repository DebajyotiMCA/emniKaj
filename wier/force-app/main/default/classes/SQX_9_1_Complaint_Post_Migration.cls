public with sharing class SQX_9_1_Complaint_Post_Migration implements Database.Batchable<SObject> {
    
    public SQX_9_1_Complaint_Post_Migration(){
        
    }
    
    /**
    * Gets invoked when the batch job starts and selects all complaints record
    * @param bc reference to the Database.BatchableContext object
    */
    public Database.QueryLocator start(Database.BatchableContext bc){
        Database.QueryLocator sobjecRecordList= Database.getQueryLocator(
            [SELECT Id, compliancequest__Status__c, OwnerId, compliancequest__SQX_Regulatory_Owner__c, compliancequest__Is_Locked__c,
            (SELECT Id, compliancequest__SQX_User__c, compliancequest__Due_Date__c, Name, compliancequest__SQX_Task__c, compliancequest__Task_Type__c, compliancequest__Status__c, compliancequest__SQX_Investigation__c, compliancequest__SQX_Product_History_Review__c, compliancequest__Step__c FROM compliancequest__SQX_Complaint_Tasks__r),
            (SELECT Id, CreatedById, compliancequest__Status__c, compliancequest__Task_Id__c FROM compliancequest__SQX_Regulatory_Reports__r ORDER BY CreatedDate, Id ASC NULLS LAST),
            (SELECT Id, compliancequest__SQX_Task__c FROM compliancequest__SQX_Investigations__r  WHERE compliancequest__SQX_Task__c != null),
            (SELECT Id, compliancequest__SQX_Task__c FROM compliancequest__SQX_Product_History_Reviews__r WHERE compliancequest__SQX_Task__c != null),
            (SELECT Id, Subject, WhatId, compliancequest__Child_What_Id__c, compliancequest__CQ_Task_Code__c FROM Tasks WHERE Status != 'Completed')
            FROM compliancequest__SQX_Complaint__c]);
        return sobjecRecordList;
    }
    
    /** 
    * Execute the method to set status and stage
    * @param bc reference to the Database.BatchableContext object
    * @param lstsObject list of sObjects containing complaints
    */ 
    public void execute(Database.BatchableContext bc, List<compliancequest__SQX_Complaint__c> lstsObject) {
        
        if (lstsObject.size() > 0) {
            
            List<compliancequest__SQX_Complaint__c> complaintList = (List<compliancequest__SQX_Complaint__c>) lstsObject;
            List<compliancequest__SQX_Complaint_Task__c> complaintStepList = new List<compliancequest__SQX_Complaint_Task__c>();
            List<Task> sfTaskList = new List<Task>();
            Map<Id, Task> sfTasksToUpdate = new Map<Id, Task>();
            List<compliancequest__SQX_Complaint__c> complaintsToUpdate = new List<compliancequest__SQX_Complaint__c>();

            Map<Id, Id> complaintWithRegReportCreatorMap = new Map<Id, Id>();
            Map<Id, List<compliancequest__SQX_Regulatory_Report__c>> complaintWithPendingRegReports = new Map<Id, List<compliancequest__SQX_Regulatory_Report__c>>();
            Map<Id, List<compliancequest__SQX_Regulatory_Report__c>> complaintWithVoidRegReports = new Map<Id, List<compliancequest__SQX_Regulatory_Report__c>>();
            Map<String, compliancequest__SQX_Investigation__c> cqTaskWithInvestigationMap = new Map<String, compliancequest__SQX_Investigation__c>();
            Map<String, compliancequest__SQX_Product_History_Review__c> cqTaskWithPhrMap = new Map<String, compliancequest__SQX_Product_History_Review__c>();
            Map<String, compliancequest__SQX_Complaint_Task__c> complaintStepMap = new Map<String, compliancequest__SQX_Complaint_Task__c>();

            Id cqTaskRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Task' AND DeveloperName = 'CQ_Task' LIMIT 1].Id;

            Map<Id, Boolean> complaintWIthSignOffMap = new Map<Id, Boolean>();
            for(compliancequest__SQX_Complaint__c complaint : complaintList){
                complaintWIthSignOffMap.put(complaint.Id, false);
                for(Task sfTask : complaint.Tasks){
                    if(sfTask.Subject == 'Regulatory Activity Sign Off'){
                        complaintWIthSignOffMap.put(complaint.Id, true);
                        continue;
                    }
                }

                if(complaint.compliancequest__SQX_Regulatory_Reports__r.size() > 0){
                    complaintWithRegReportCreatorMap.put(complaint.Id , complaint.compliancequest__SQX_Regulatory_Reports__r.get(0).CreatedById);
                    complaintWithPendingRegReports.put(complaint.Id, new List<compliancequest__SQX_Regulatory_Report__c>{});
                    complaintWithVoidRegReports.put(complaint.Id, new List<compliancequest__SQX_Regulatory_Report__c>{});
                    
                    for(compliancequest__SQX_Regulatory_Report__c regReport : complaint.compliancequest__SQX_Regulatory_Reports__r){
                        if(regReport.compliancequest__Status__c == 'Pending'){
                            complaintWithPendingRegReports.get(complaint.Id).add(regReport);
                        } else if (regReport.compliancequest__Status__c == 'Void'){
                            complaintWithVoidRegReports.get(complaint.Id).add(regReport);
                        }
                    }
                }

                for(compliancequest__SQX_Investigation__c inv : complaint.compliancequest__SQX_Investigations__r){
                    cqTaskWithInvestigationMap.put(complaint.Id + '_' + inv.compliancequest__SQX_Task__c, inv);
                }

                for(compliancequest__SQX_Product_History_Review__c phr : complaint.compliancequest__SQX_Product_History_Reviews__r){
                    cqTaskWithPhrMap.put(complaint.Id + '_' + phr.compliancequest__SQX_Task__c, phr);
                }

                for(compliancequest__SQX_Complaint_Task__c complaintStep : complaint.compliancequest__SQX_Complaint_Tasks__r){
                    complaintStepMap.put(complaint.Id + '_' + complaintStep.Id, complaintStep);
                }
            }

            for(compliancequest__SQX_Complaint__c complaint : complaintList){

                if(complaint.compliancequest__Status__c == 'Complete' && complaint.compliancequest__Is_Locked__c){
                    compliancequest__SQX_Complaint__c newComplaint = new compliancequest__SQX_Complaint__c();
                    newComplaint.compliancequest__Is_Locked__c = false;
                    newComplaint.Id = complaint.Id;
                    complaintsToUpdate.add(newComplaint);
                }

                for(compliancequest__SQX_Complaint_Task__c complaintStep : complaint.compliancequest__SQX_Complaint_Tasks__r){
                    if(complaintStep.Name == 'Regulatory Activity Sign Off'){
                        
						Id regStepOwnerId = complaint.OwnerId;
                        if(complaint.compliancequest__SQX_Regulatory_Owner__c == null){
                            if(complaintWithRegReportCreatorMap.containsKey(complaint.Id)){
                                regStepOwnerId = complaintWithRegReportCreatorMap.get(complaint.Id);
                            }
                        } else {
                            regStepOwnerId = complaint.compliancequest__SQX_Regulatory_Owner__c;
                        }
                        
                        complaintStep.compliancequest__SQX_User__c = regStepOwnerId;

                        if(complaint.compliancequest__Status__c == 'Open'){
                            complaintStep.compliancequest__Status__c = 'Open';
                        }
                        
                        if(complaintWithPendingRegReports.get(complaint.Id).size() == 0){
                            complaintStep.compliancequest__Status__c = 'Complete';
                        } else {
                            if(complaintWIthSignOffMap.containsKey(complaint.Id) && !complaintWIthSignOffMap.get(complaint.Id)){
                                Task sfTask= new Task(
                                    compliancequest__Child_What_Id__c = complaintStep.Id,
                                    ActivityDate = complaintStep.compliancequest__Due_Date__c,
                                    Priority = 'Normal',
                                    Status = 'Not Started',
                                    Subject = complaintStep.Name,
                                    compliancequest__CQ_Task_Code__c = '',
                                    WhatId = complaint.Id,
                                    RecordTypeId = cqTaskRecordTypeId,
                                    OwnerId = regStepOwnerId
                                );
                                sfTaskList.add(sfTask);
                            }
                        }

                    }

                    if(complaintStep.compliancequest__Status__c == 'Open'){
                        if(complaintStep.compliancequest__Task_Type__c == 'Investigation' && String.isNotBlank(complaintStep.compliancequest__SQX_Investigation__c)){
                            if(cqTaskWithInvestigationMap.containsKey(complaint.Id + '_' + complaintStep.compliancequest__SQX_Task__c)){
                                complaintStep.compliancequest__SQX_Investigation__c = cqTaskWithInvestigationMap.get(complaint.Id + '_' + complaintStep.compliancequest__SQX_Task__c).Id;
                            }
                            
                        } else if(complaintStep.compliancequest__Task_Type__c == 'PHR' && String.isNotBlank(complaintStep.compliancequest__SQX_Product_History_Review__c)){
                            if(cqTaskWithPhrMap.containsKey(complaint.Id + '_' + complaintStep.compliancequest__SQX_Task__c)){
                                complaintStep.compliancequest__SQX_Product_History_Review__c = cqTaskWithPhrMap.get(complaint.Id + '_' + complaintStep.compliancequest__SQX_Task__c).Id;
                            }
                        }
                    }
                    
                    complaintStepList.add(complaintStep); 
                }

                for(Task sfTask : complaint.Tasks){
                    if(complaintStepMap.containsKey(sfTask.WhatId + '_' + sfTask.compliancequest__Child_What_Id__c)){
                        String taskType = complaintStepMap.get(sfTask.WhatId + '_' + sfTask.compliancequest__Child_What_Id__c).compliancequest__Task_Type__c;
                        if(String.isNotBlank(taskType)){
                            taskType = taskType.replace(' ', '_');
                            if(taskType != sfTask.compliancequest__CQ_Task_Code__c){
                                Task newSFTask = new Task();
                                newSFTask.Id = sfTask.Id;
                                newSFTask.compliancequest__CQ_Task_Code__c = taskType;
                                sfTasksToUpdate.put(sfTask.Id, newSFTask);
                            }
                        }
                    }
                }

                if(complaintWithVoidRegReports.get(complaint.Id) != null){

                    for(compliancequest__SQX_Regulatory_Report__c regReport : complaintWithVoidRegReports.get(complaint.Id)){

                        if(String.isNotBlank(regReport.compliancequest__Task_Id__c)){
                            if(!sfTasksToUpdate.containsKey(regReport.compliancequest__Task_Id__c)){
                                
                                Task sfTask = new Task();
                                sfTask.Id = regReport.compliancequest__Task_Id__c;
                                sfTasksToUpdate.put(regReport.compliancequest__Task_Id__c,sfTask);
                            }
                            sfTasksToUpdate.get(regReport.compliancequest__Task_Id__c).Status = 'Completed';
                        }
                    }
                }
            }

            if(sfTaskList.size() > 0){
                insert sfTaskList;
            }

            if(sfTasksToUpdate.size() > 0){
                update sfTasksToUpdate.values();
            }

            if(complaintStepList.size() > 0){
                update complaintStepList;
            }

            if(complaintsToUpdate.size() > 0){
                update complaintsToUpdate;
            }
        }
    }
    
    /** 
    * Used to execute post-processing operations and is called once after all batches are processed
    * @param bc reference to the Database.BatchableContext object
    */
    public void finish(Database.BatchableContext bc){
    }
    
}