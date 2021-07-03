/**
 * test class for 9.1 complaint post migration
 */
@isTest
public class SQX_Test_9_1_Complaint_Post_Migration {

    /**
     * GIVEN : Complaint Records after migration
     * WHEN : Post Migration batch job is ran
     * THEN : Complaint details are updated with correct data
     * 
     */
    public static testMethod void givenTask_WhenMethodIsInvoked_ComplaintStepDetailsAreReturned(){
        // add custom setting to create evaluation records when related complaint task is present
        compliancequest__SQX_Custom_Settings_Public__c customSetting;
        customSetting = new compliancequest__SQX_Custom_Settings_Public__c( compliancequest__Community_URL__c = 'https://login.salesforce.com',
                                                                            compliancequest__Org_Base_URL__c = 'https://login.salesforce.com',
                                                                            compliancequest__NC_Analysis_Report__c = 'abc123def',
                                                                            compliancequest__Create_Complaint_Evaluation_Records__c = true);
        insert customSetting;

        compliancequest__SQX_Task__c investigationTask = new compliancequest__SQX_Task__c(compliancequest__Allowed_Days__c = 30, 
                                                                             compliancequest__SQX_User__c = UserInfo.getUserId(), 
                                                                             compliancequest__Description__c = 'Test_DESP', 
                                                                             compliancequest__Record_Type__c = 'Complaint', 
                                                                             compliancequest__Step__c = 1,
                                                                             compliancequest__Active__c = true,
                                                                             Name = 'Investigation_Step',
                                                                             compliancequest__Task_Type__c = 'Investigation',
                                                                             RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'compliancequest__SQX_Task__c' AND DeveloperName = 'Complaint_Management_Step'].Id
                                                                            );
        
        
        insert investigationTask;
        
        compliancequest__SQX_Task__c phrTask = new compliancequest__SQX_Task__c(compliancequest__Allowed_Days__c = 30, 
                                                                                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                                                                                compliancequest__Description__c = 'Test_DESP', 
                                                                                compliancequest__Record_Type__c = 'Complaint', 
                                                                                compliancequest__Step__c = 1,
                                                                                compliancequest__Active__c = true,
                                                                                Name = 'PHR_Step',
                                                                                compliancequest__Task_Type__c = 'PHR',
                                                                                RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'compliancequest__SQX_Task__c' AND DeveloperName = 'Complaint_Management_Step'].Id
                                                                               );
        
        
        insert phrTask;
        
        compliancequest__SQX_Part__c newPart;
        compliancequest__SQX_Part_Family__c partFamily;

        Integer randomNumber = (Integer)(Math.random() * 1000000);
        partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'dummyFamily-' + randomNumber;
        
        insert partFamily;
        
        compliancequest__SQX_Department__c department = new compliancequest__SQX_Department__c();
        department.Name = 'Complaint';
        insert department;


        newPart = new compliancequest__SQX_Part__c();
        newPart.Name = 'part' + randomNumber;
        newPart.compliancequest__Part_Number__c = 'PR-' + randomNumber;
        newPart.compliancequest__Part_Risk_Level__c = 3;
        newPart.compliancequest__Active__c = true;
        newPart.compliancequest__Part_Family__c = partFamily.Id;

        insert newPart;
        
        // ARRANGE : Complaint with complaint step
        compliancequest__SQX_Complaint__c complaint = new compliancequest__SQX_Complaint__c();
        complaint.compliancequest__Country_of_Origin__c = 'US';
        complaint.compliancequest__SQX_Department__c = department.Id;
        complaint.compliancequest__Description_As_Reported__c = 'Random Description';
        complaint.compliancequest__Aware_Date__c = Date.today();
        complaint.compliancequest__Complaint_Title__c = 'Random Title';
        complaint.compliancequest__Reported_Date__c = Date.today();
        complaint.compliancequest__Occurrence_Date__c = Date.today();
        complaint.compliancequest__Outcome__c = 'Concern';
        complaint.compliancequest__SQX_Part__c = newPart.Id;
        complaint.compliancequest__Complaint_Quantity__c = 1;
        complaint.compliancequest__Description__c = 'New Random Description';
        complaint.compliancequest__Current_Step__c = 1;
        complaint.compliancequest__SQX_Regulatory_Owner__c = UserInfo.getUserId();
        insert complaint;
        
        compliancequest__SQX_Regulatory_Report__c report = new compliancequest__SQX_Regulatory_Report__c(
            compliancequest__SQX_Decision_Tree__c = null,
            compliancequest__SQX_Complaint__c = complaint.Id,
            compliancequest__Status__c = 'Pending',
            Name = 'Regulatory Report',
            compliancequest__Due_Date__c = Date.today().addDays(10),
            compliancequest__SQX_User__c = UserInfo.getUserId()
        );

        insert report;

        compliancequest__SQX_Regulatory_Report__c report1 = new compliancequest__SQX_Regulatory_Report__c(
            compliancequest__SQX_Decision_Tree__c = null,
            compliancequest__SQX_Complaint__c = complaint.Id,
            compliancequest__Status__c = 'Pending',
            Name = 'Regulatory Report',
            compliancequest__Due_Date__c = Date.today().addDays(10),
            compliancequest__SQX_User__c = UserInfo.getUserId()
        );
        
        insert report1;    
        
        report1.compliancequest__Status__c = 'Void';
        update report1;
        
        complaint.compliancequest__Current_Step__c = 1;
        complaint.compliancequest__Activity_Code__c = 'initiate';
        update complaint;
        
        compliancequest__SQX_Complaint_Task__c investigationComplaintStep = [SELECT Id FROM compliancequest__SQX_Complaint_Task__c WHERE compliancequest__SQX_Task__c =: investigationTask.Id];
        compliancequest__SQX_Complaint_Task__c phrComplaintStep = [SELECT Id FROM compliancequest__SQX_Complaint_Task__c WHERE compliancequest__SQX_Task__c =: phrTask.Id];
        
        phrComplaintStep.compliancequest__SQX_Product_History_Review__c = null;
        update phrComplaintStep;
        
        investigationComplaintStep.compliancequest__SQX_Investigation__c = null;
        update investigationComplaintStep;
        
        List<Task> sfTaskList = [SELECT Id FROM Task];
        
        System.assertEquals(5, sfTaskList.size());
        
        for(Task sfTask : sfTaskList){
            sfTask.compliancequest__CQ_Task_Code__c = '';
            sfTask.Status =  'Not Started';
        }
        
        update sfTaskList;
        
        Test.startTest();
        Database.executeBatch(new  SQX_9_1_Complaint_Post_Migration());
        Test.stopTest();
        
        System.assertNotEquals(null, [SELECT Id FROM compliancequest__SQX_Complaint_Task__c WHERE compliancequest__Task_Type__c = 'Investigation'].Id);
        System.assertNotEquals(null, [SELECT Id FROM compliancequest__SQX_Complaint_Task__c WHERE compliancequest__Task_Type__c = 'PHR'].Id);
        
    }
}