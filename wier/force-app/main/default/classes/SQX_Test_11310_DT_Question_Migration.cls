/**
 * test class for dt question number
 */
@isTest
public class SQX_Test_11310_DT_Question_Migration {
    public static testMethod void givenSigleDigitDTQuestionNumber_WhenMigrated_QuestionNumberIsMigratedToTwoDigit(){
        
        // ARRANGE : Task question are created
        compliancequest__SQX_Task__c cqTask = new compliancequest__SQX_Task__c();
        cqTask.Name = 'DT Task';
        cqTask.compliancequest__Record_Type__c = 'Complaint';
        cqTask.compliancequest__Task_Type__c = 'Decision Tree';
        cqTask.compliancequest__Allowed_Days__c = 10;
        cqTask.compliancequest__Active__c = true;
        cqTask.compliancequest__Step__c = 1;
        
        insert cqTask;
        
        List<compliancequest__SQX_Task_Question__c> taskQuestions = new List<compliancequest__SQX_Task_Question__c>();
        for(Integer i = 1; i < 10; i++){
            compliancequest__SQX_Task_Question__c question = new compliancequest__SQX_Task_Question__c(
                compliancequest__SQX_Task__c = cqTask.Id,
                compliancequest__QuestionText__c = 'Test Question' + i,
                Name = String.valueOf(i)
            );
            taskQuestions.add(question);
        }
        
        insert taskQuestions;

        // ACT : Migration is ran        
        Test.startTest();
        SQX_9_1_1_Post_Record_Migration.startMigration();
        Test.stopTest();
        
        taskQuestions = [SELECT Id, Name FROM compliancequest__SQX_Task_Question__c];
        
        // ASSERT : Question Number are migrated correctly
        Integer count = 0;
        for(Integer i = 1; i < 10; i++){
            System.assertEquals('0' + i, taskQuestions[count].Name);
            count++;
        }
        
    }
}