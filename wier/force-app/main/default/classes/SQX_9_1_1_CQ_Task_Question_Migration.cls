/**
 * batch class to update Decision Tree task question
 */
public class SQX_9_1_1_CQ_Task_Question_Migration implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
        List<String> dtQuestionNumbers = new List<String>{'1','2','3','4','5','6','7','8','9'};
        Database.QueryLocator sobjecRecordList= Database.getQueryLocator([SELECT Id, Name FROM compliancequest__SQX_Task_Question__c WHERE Name IN : dtQuestionNumbers]);
        return sobjecRecordList;
    }
    
    
    /** 
     * Execute the update task question
     * @param bc reference to the Database.BatchableContext object
     * @param listsObject list of sObjects containing complaints
     */ 
    public void execute(Database.BatchableContext bc, List<SObject> listsObject) {
        
        for(compliancequest__SQX_Task_Question__c taskQuestion : (List<compliancequest__SQX_Task_Question__c>)listsObject){
        	taskQuestion.Name = '0' + taskQuestion.Name;    
        }
        
        Database.update(listsObject, true);
    }
    
    /** 
     * Used to execute post-processing operations and is called once after all batches are processed
     * @param bc reference to the Database.BatchableContext object
     */
    public void finish(Database.BatchableContext bc){
        
    }
}