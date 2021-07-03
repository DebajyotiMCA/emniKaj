/**
 * test calss for sf task record type and task code migration
 */
public class SQX_9_1_1_SF_Task_Migration  implements Database.Batchable<SObject>{
    /**
     * Gets invoked when the batch job starts and selects all  cq sf tasks 
     * @param bc reference to the Database.BatchableContext object
     */
    public Database.QueryLocator start(Database.BatchableContext bc){
        Database.QueryLocator sobjecRecordList = Database.getQueryLocator([SELECT Id, WhatId, compliancequest__Child_What_Id__c, compliancequest__CQ_Task_Code__c FROM Task WHERE compliancequest__CQ_Task_Code__c = null and compliancequest__Child_What_Id__c != null]);
        return sobjecRecordList;
    }
    
    /** 
     * Execute the method to set task code and record type of sf task
     * @param bc reference to the Database.BatchableContext object
     * @param listsObject list of sObjects containing Regulatory Reports
     */ 
    public void execute(Database.BatchableContext bc, List<SObject> listsObject) {
        if (listsObject.size() > 0) {
            Map<Id, Task> sfTasksToUpdate = new Map<Id, Task>();
            Map<String, Set<Id>> sobjectToRecordMap = new Map<String, Set<Id>>();
            Map<String, Map<String,Schema.SObjectField>> sobjectFieldMap = new Map<String, Map<String,Schema.SObjectField>>();
            Map<Id, Id> stepWithSFTaskMap = new Map<Id, Id>();
            
            Map<String, SObjectType> objType = Schema.getGlobalDescribe();
            Map<String, RecordTypeInfo> infos  = objType.get('Task').getDescribe().getRecordTypeInfosByDeveloperName();
            Id cqTaskRecordTypeId = infos.get('CQ_Task').getRecordTypeID();
            
            for(Task sfTask : (List<Task>)listsObject) {
                Id childWhatId = (Id) sfTask.compliancequest__Child_What_Id__c;
                stepWithSFTaskMap.put(childWhatId, sfTask.Id);
                sfTask.RecordTypeId = cqTaskRecordTypeId;
                sfTasksToUpdate.put(sfTask.Id, sfTask);
                Schema.DescribeSObjectResult describeResult = childWhatId.getSobjectType().getDescribe();
                String objectName = describeResult.getName();
                
                if(!sobjectToRecordMap.containsKey(objectName)){
                    sobjectToRecordMap.put(objectName, new Set<Id>{});
                    sobjectFieldMap.put(objectName, describeResult.fields.getMap());
                }
                 sobjectToRecordMap.get(objectName).add(childWhatId);
            }
            
            Map<String, List<SObject>> objMap = new Map<String, List<SObject>>();
            

            /**
             * SOQL IS ADDED IN FOR LOOP BECAUSE WE DO NOT KNOW THE EXACT NUMBER OF SOBJECT IT WILL RETURN
             * BUT OUR EXPECTION IS TILL 9.1.1 IT WILL NOT RETURN MORE THAN 6 SOBJECT TYPES SUCH AS COMPLAINT STEP, ONBOARDING STEP, ETC
             */
            for(String objName : sobjectToRecordMap.keySet()){
                if(sobjectFieldMap.get(objName).containskey('compliancequest__task_type__c')){
                    Set<Id> recordIds = sobjectToRecordMap.get(objName);
                    String query = 'SELECT Id, compliancequest__Task_Type__c FROM ' + objName + ' WHERE Id =: recordIds and compliancequest__Task_Type__c != null';
            
                    List<SObject> objList = Database.query(query);
                    objMap.put(objName, objList);
                }
            }
            
            for(String objName : objMap.keySet()){
                if(objMap.get(objName).size() > 0){
                    for(SObject obj : objMap.get(objName)){
                        Id objId = (Id) obj.get('id');
                        Id sfId = stepWithSFTaskMap.get(objId);
                        String taskType = String.valueOf(obj.get('compliancequest__task_type__c'));
						sfTasksToUpdate.get(sfId).compliancequest__CQ_Task_Code__c = taskType.replace(' ', '_');             
                    }
                }
            }
            
            Database.update(sfTasksToUpdate.values(), true);
        }
    }
    
    /** 
     * Used to execute post-processing operations and is called once after all batches are processed
     * @param bc reference to the Database.BatchableContext object
     */
    public void finish(Database.BatchableContext bc){
    }
}