/**
 * This migration test case for to update complaint and its primary investigation fields (SQX_9_1_1_Complaint_Migration)
 */
@isTest
public class SQX_Test_11068_Migration {    
   /**
    * Given: Complaint in open status with part but without part family
    * When: Migrated
    * Then: Part family is set in complaint and defect code, part, part family is also linked to its primary investigation, linked investigation created.
    */
    public static testmethod void givenComplaintInOpenStatusWithPartButWithoutPartFamily_WhenMigrated_ThenPartFamilyIsLinkedAndPrimaryInvestigationIsUpdated(){
        User adminUser = createUser();
        System.runAs(adminUser){
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            //Arrange: Create complaint record
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
            complaint.compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id;
            insert complaint;
            
            //Arrange: Create Investigation
            compliancequest__SQX_Investigation__c inv = new compliancequest__SQX_Investigation__c(
                compliancequest__SQX_Complaint__c = complaint.Id, 
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT
            );
            insert inv;
            
            //initiate complaint
            complaint.compliancequest__Activity_Code__c = 'initiate';
            complaint.compliancequest__Activity_Comment__c = 'Taking Ownership and Initiating Record';
            update complaint;
            
            //Act: execute migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            //Assert: Ensure defect code, part family, part are linked in Primary Investigation
            compliancequest__SQX_Investigation__c updatedInv = [SELECT Id, compliancequest__SQX_Defect_Code__c, compliancequest__SQX_Part_Family__c, compliancequest__SQX_Part__c FROM compliancequest__SQX_Investigation__c WHERE compliancequest__SQX_Complaint__c =: complaint.Id];
            System.assertEquals(complaintConclusion.Id, updatedInv.compliancequest__SQX_Defect_Code__c, 'Defect code is not migrated.');
            System.assertEquals(newPart.compliancequest__Part_Family__c, updatedInv.compliancequest__SQX_Part_Family__c, 'Part Family is not migrated.');
            System.assertEquals(complaint.compliancequest__SQX_Part__c, updatedInv.compliancequest__SQX_Part__c, 'Part is not migrated.');
            
            //Assert: Ensure Linked investigation is created and Primary investigation is linked in Complaint.
            List<compliancequest__SQX_Linked_Investigation__c> linkedInv = [SELECT Id FROM compliancequest__SQX_Linked_Investigation__c WHERE compliancequest__SQX_Complaint__c =: complaint.Id AND compliancequest__SQX_Investigation__c =: updatedInv.Id];
            System.assertEquals(1, linkedInv.size(), 'Linked investigations should be created.');
            List<compliancequest__SQX_Complaint__c> updatedComplaints = [SELECT Id FROM compliancequest__SQX_Complaint__c WHERE Id =: complaint.Id AND compliancequest__SQX_Primary_Investigation__c =: inv.Id];
            System.assertEquals(1, updatedComplaints.size(), 'Primary Investigation should be set in Complaint record.');
            
            //Assert: Ensure Part Family is linked in Complaint.
            System.assertEquals(newPart.compliancequest__Part_Family__c, [SELECT compliancequest__SQX_Part_Family__c FROM compliancequest__SQX_Complaint__c WHERE Id =: complaint.Id].compliancequest__SQX_Part_Family__c, 'Part family is not linked in Complaint.');
            
        }
    }
    
    /**
     * Given: Complaint in Draft status with part but without part family
     * When: Migrated
     * Then: Part family is set in complaint and defect code, part, part family is also linked to its primary investigation
     */
    public static testmethod void givenComplaintInDraftStatusWithPartButWithoutPartFamily_WhenMigrated_ThenPartFamilyIsLinkedAndPrimaryInvestigationIsUpdated(){
        User adminUser = createUser();
        System.runAs(adminUser){
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            //Arrange: Create complaint record
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
            complaint.compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id;
            insert complaint;
            
            //Arrange: Create Investigation
            compliancequest__SQX_Investigation__c inv = new compliancequest__SQX_Investigation__c(
                compliancequest__SQX_Complaint__c = complaint.Id, 
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT
            );
            insert inv;
            
            //Act: execute migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            //Assert: Ensure defect code, part family, part are linked in Primary Investigation
            compliancequest__SQX_Investigation__c updatedInv = [SELECT Id, compliancequest__SQX_Defect_Code__c, compliancequest__SQX_Part_Family__c, compliancequest__SQX_Part__c FROM compliancequest__SQX_Investigation__c WHERE compliancequest__SQX_Complaint__c =: complaint.Id];
            System.assertEquals(complaintConclusion.Id, updatedInv.compliancequest__SQX_Defect_Code__c, 'Defect code is not migrated.');
            System.assertEquals(newPart.compliancequest__Part_Family__c, updatedInv.compliancequest__SQX_Part_Family__c, 'Part Family is not migrated.');
            System.assertEquals(complaint.compliancequest__SQX_Part__c, updatedInv.compliancequest__SQX_Part__c, 'Part is not migrated.');
            
            //Assert: Ensure Linked investigation is not created and Primary investigation is not linked in Complaint.
            List<compliancequest__SQX_Linked_Investigation__c> linkedInv = [SELECT Id FROM compliancequest__SQX_Linked_Investigation__c WHERE compliancequest__SQX_Complaint__c =: complaint.Id AND compliancequest__SQX_Investigation__c =: updatedInv.Id];
            System.assertEquals(0, linkedInv.size(), 'Linked investigations should not be created in Draft status.');
            List<compliancequest__SQX_Complaint__c> updatedComplaints = [SELECT Id FROM compliancequest__SQX_Complaint__c WHERE Id =: complaint.Id AND compliancequest__SQX_Primary_Investigation__c =: inv.Id];
            System.assertEquals(0, updatedComplaints.size(), 'Primary Investigation should not be set in Complaint record in Draft status.');
            
            //Assert: Ensure Part Family is linked in Complaint.
            System.assertEquals(newPart.compliancequest__Part_Family__c, [SELECT compliancequest__SQX_Part_Family__c FROM compliancequest__SQX_Complaint__c WHERE Id =: complaint.Id].compliancequest__SQX_Part_Family__c, 'Part family is not linked in Complaint.');
            
        }
    }
    
    /**
     * GIVEN : CQ Tasks, Complaints and Complaint steps with different step
     * WHEN : Migrated
     * THEN : Step of regulatory report complaint step in draft status is the greatest
     */
    public static testmethod void givenComplaintAndComplaintStepsInDraftStatus_WhenMigrated_ThenStepOfRegulatoryReportIsSetToHighest(){
        User adminUser = createUser();
        System.runAs(adminUser){
            RecordType rtype = [SELECT Id FROM RecordType WHERE DeveloperName = 'Complaint_Management_Step' LIMIT 1];
            //Arrange: CQ task created
            compliancequest__SQX_Task__c task1 = new compliancequest__SQX_Task__c(
                compliancequest__Allowed_Days__c = 30, 
                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                compliancequest__Description__c = 'Test_DESP', 
                compliancequest__Record_Type__c = 'Complaint',
                RecordTypeId = rtype.Id,
                compliancequest__Step__c = 1,
                Name = 'NSI_10',
                compliancequest__Task_Type__c = 'Decision Tree',
                compliancequest__Active__c = true
            );
            
            insert task1;
            compliancequest__SQX_Task__c task2 = new compliancequest__SQX_Task__c(
                compliancequest__Allowed_Days__c = 30, 
                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                compliancequest__Description__c = 'Test_DESP', 
                compliancequest__Record_Type__c = 'Complaint',
                RecordTypeId = rtype.Id,
                compliancequest__Step__c = 2,
                Name = 'NSI_11',
                compliancequest__Task_Type__c = 'PHR',
                compliancequest__Active__c = true
            );
            insert task2;
            compliancequest__SQX_Task__c task3 = new compliancequest__SQX_Task__c(
                compliancequest__Allowed_Days__c = 30, 
                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                compliancequest__Description__c = 'Test_DESP', 
                compliancequest__Record_Type__c = 'Complaint',
                RecordTypeId = rtype.Id,
                compliancequest__Step__c = 3,
                Name = 'NSI_12',
                compliancequest__Task_Type__c = 'Sample Request',
                compliancequest__Active__c = true
            );
            insert task3;
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            //Arrange: Create complaint record
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
            complaint.compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id;
            complaint.compliancequest__Status__c = 'Draft';
            complaint.compliancequest__Record_Stage__c = 'Draft';
            insert complaint;
            
            complaint.compliancequest__Status__c = 'Draft';
            complaint.compliancequest__Record_Stage__c = 'Triage';
            update complaint;
            
            
            List<compliancequest__SQX_Complaint_Task__c> complaintTasks = [SELECT Id, compliancequest__Step__c, compliancequest__Status__c, 
                                                                           compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Complaint__c FROM compliancequest__SQX_Complaint_Task__c WHERE
                                                                           compliancequest__SQX_Complaint__c =: complaint.Id];
            System.assertEquals(3, complaintTasks.size(), 'Complaint steps are not created.');
            
            //Arrange: Update stage and status of complaint
            complaint.compliancequest__Status__c = 'Open';
            complaint.compliancequest__Record_Stage__c = 'In Progress';
            complaint.OwnerId = adminUser.Id;
            update complaint;

            //Act: Decision tree is run
            compliancequest__SQX_Decision_Tree__c decisionTree = runDecisionTreeTask(task1, complaint.Id);
            compliancequest__SQX_Regulatory_Report__c report1 = addRegulatoryReport(decisionTree, 'Pending', complaint.Id);
            
            complaintTasks = [SELECT Id, compliancequest__Step__c, compliancequest__Status__c, 
                              compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Complaint__c FROM compliancequest__SQX_Complaint_Task__c WHERE
                              compliancequest__SQX_Complaint__c =: complaint.Id AND compliancequest__Is_Regulatory_Report_Task__c = true];
            
            //Assert: Complaint tasks are created
            System.assertEquals(1, complaintTasks.size(), 'Complaint steps are not created.');
            
            complaintTasks[0].compliancequest__Status__c = 'Draft';
            complaintTasks[0].compliancequest__Step__c = 1;
            update complaintTasks;
            
            //Act: Execute Migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            complaintTasks = [SELECT Id, compliancequest__Step__c, compliancequest__Status__c, compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Complaint__c FROM
                              compliancequest__SQX_Complaint_Task__c WHERE compliancequest__SQX_Complaint__c = :complaint.Id AND
                              compliancequest__Is_Regulatory_Report_Task__c = TRUE];
            
            //Assert: Complaint task is created for reg report
            System.assertEquals(1, complaintTasks.size(), 'Complaint task is not created for regulatory report.');
            
            //Assert: Step of reg report complaint task is the greatest
            System.assertEquals(3, complaintTasks.get(0).compliancequest__Step__c, 'Complaint Task of last step is not set.');
        }
        
    }
    
    /**
     * GIVEN : CQ Tasks, Complaints and Complaint steps with different step
     * WHEN : Migrated
     * THEN : Step of regulatory report complaint step in 'Open' status is the greatest
     */
    public static testmethod void givenComplaintAndComplaintStepsInOpenStatus_WhenMigrated_ThenStepOfRegulatoryReportIsSetToHighest(){
        User adminUser = createUser();
        System.runAs(adminUser){
            RecordType rtype = [SELECT Id FROM RecordType WHERE DeveloperName = 'Complaint_Management_Step' LIMIT 1];
            //Arrange: CQ Tasks are created
            compliancequest__SQX_Task__c task1 = new compliancequest__SQX_Task__c(
                compliancequest__Allowed_Days__c = 30, 
                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                compliancequest__Description__c = 'Test_DESP', 
                compliancequest__Record_Type__c = 'Complaint',
                RecordTypeId = rtype.Id,
                compliancequest__Step__c = 1,
                Name = 'NSI_10',
                compliancequest__Task_Type__c = 'Decision Tree',
                compliancequest__Active__c = true
            );
            insert task1;
            
            compliancequest__SQX_Task__c task2 = new compliancequest__SQX_Task__c(
                compliancequest__Allowed_Days__c = 30, 
                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                compliancequest__Description__c = 'Test_DESP', 
                compliancequest__Record_Type__c = 'Complaint',
                RecordTypeId = rtype.Id,
                compliancequest__Step__c = 2,
                Name = 'NSI_11',
                compliancequest__Task_Type__c = 'PHR',
                compliancequest__Active__c = true
            );
            insert task2;
            
            compliancequest__SQX_Task__c task3 = new compliancequest__SQX_Task__c(
                compliancequest__Allowed_Days__c = 30, 
                compliancequest__SQX_User__c = UserInfo.getUserId(), 
                compliancequest__Description__c = 'Test_DESP', 
                compliancequest__Record_Type__c = 'Complaint',
                RecordTypeId = rtype.Id,
                compliancequest__Step__c = 3,
                Name = 'NSI_12',
                compliancequest__Task_Type__c = 'Sample Request',
                compliancequest__Active__c = true
            );
            insert task3;
            
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            //Arrange: Create complaint record
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
            complaint.compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id;
            complaint.compliancequest__Status__c = 'Draft';
            complaint.compliancequest__Record_Stage__c = 'Draft';
            insert complaint;
            
            //submit the complaint
            complaint.compliancequest__Status__c = 'Draft';
            complaint.compliancequest__Record_Stage__c = 'Triage';
            update complaint;
            
            
            List<compliancequest__SQX_Complaint_Task__c> complaintTasks = [SELECT Id, compliancequest__Step__c, compliancequest__Status__c, 
                                                                           compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Complaint__c FROM compliancequest__SQX_Complaint_Task__c WHERE
                                                                           compliancequest__SQX_Complaint__c =: complaint.Id];
            
            System.assertEquals(3, complaintTasks.size(), '3 Complaint steps are not created.');
            
            //Arrange: Update stage and status of complaint
            complaint.compliancequest__Status__c = 'Open';
            complaint.compliancequest__Record_Stage__c = 'In Progress';
            complaint.OwnerId = adminUser.Id;
            update complaint;
            
            //Act: Decision tree is run
            compliancequest__SQX_Decision_Tree__c decisionTree = runDecisionTreeTask(task1, complaint.Id);
            compliancequest__SQX_Regulatory_Report__c report1 = addRegulatoryReport(decisionTree, 'Pending', complaint.Id);
            
            complaintTasks = [SELECT Id, compliancequest__Step__c, compliancequest__Status__c, 
                              compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Complaint__c FROM compliancequest__SQX_Complaint_Task__c WHERE
                              compliancequest__SQX_Complaint__c =: complaint.Id AND compliancequest__Is_Regulatory_Report_Task__c = true];
            
            //Assert: Complaint tasks for regulatory report is created
            System.assertEquals(1, complaintTasks.size(), 'Complaint steps are not created.');
            
            //Change its status to open
            complaintTasks[0].compliancequest__Status__c = 'Open';
            complaintTasks[0].compliancequest__Step__c = 1;
            update complaintTasks;
            
            //Act: Execute Migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            complaintTasks = [SELECT Id, compliancequest__Step__c, compliancequest__Status__c, compliancequest__Is_Regulatory_Report_Task__c, compliancequest__SQX_Complaint__c FROM
                              compliancequest__SQX_Complaint_Task__c WHERE compliancequest__SQX_Complaint__c = :complaint.Id AND
                              compliancequest__Is_Regulatory_Report_Task__c = TRUE];
            
            //Assert: Complaint task is created for reg report
            System.assertEquals(1, complaintTasks.size(), 'Complaint task is not created for regulatory report.');
            
            //Assert: Step of reg report complaint task is the greatest
            System.assertEquals(3, complaintTasks.get(0).compliancequest__Step__c, 'Complaint Task of last step is not set.');
        }
        
        
    }
    
    /**
     * Given: Complaint and Complaint contact of SQX Type = null and Type = 'Initial Reporter'
     * When: Migrated
     * Then: SQX Type is set in complaint contact
     */
    public static testmethod void givenComplaintAndComplaintContactOfTypeInitialReport_WhenMigrated_ThenSQXTypeShouldBeSet(){
        User adminUser = createUser();
        System.runAs(adminUser){
            //Arrange: Create complaint record
            compliancequest__SQX_Complaint__c complaint = new compliancequest__SQX_Complaint__c();
            complaint.compliancequest__Country_of_Origin__c = 'US';
            complaint.compliancequest__Description_As_Reported__c = 'Random Description';
            complaint.compliancequest__Aware_Date__c = Date.today();
            complaint.compliancequest__Complaint_Title__c = 'Random Title';
            complaint.compliancequest__Reported_Date__c = Date.today();
            complaint.compliancequest__Occurrence_Date__c = Date.today();
            complaint.compliancequest__Outcome__c = 'Concern';
            complaint.compliancequest__Complaint_Quantity__c = 1;
            complaint.compliancequest__Description__c = 'New Random Description';
            complaint.compliancequest__Current_Step__c = 1;
            insert complaint;
            
            //Arrange: Create complaint contact
            compliancequest__SQX_Complaint_Contact__c complaintContact = new compliancequest__SQX_Complaint_Contact__c(
                Name = 'Halep',
                compliancequest__Type__c = 'Initial Reporter',
                compliancequest__Email__c = 'test@test.com',
                compliancequest__Phone_Number__c = '1(427)123-1234',
                compliancequest__SQX_Complaint__c = complaint.Id
            );
            insert complaintContact;
            
            //Arrange: Create picklist values of category = Complaint Contact Type
            compliancequest__SQX_Picklist_Value__c pv = new compliancequest__SQX_Picklist_Value__c(
                Name ='Initial Reporter',
                compliancequest__Value__c ='abc',
                compliancequest__Category__c = 'Complaint Contact Type',
                compliancequest__Active__c = true
            );
            insert pv;
            
            //Act: Execute migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            //Assert: Ensure Type in complaint contact is migrated.
            System.assertEquals(pv.Id, [SELECT compliancequest__SQX_Type__c FROM compliancequest__SQX_Complaint_Contact__c WHERE compliancequest__SQX_Complaint__c =: complaint.Id].compliancequest__SQX_Type__c, 'Type is not migrated in complaint contact.');
        }
    }
    
    /**
    * Given: Complaint with Associated Item
    * When: Migrated
    * Then: Primary Investigation is linked in Complaint
    */
    public static testmethod void givenComplaintWithAI_WhenMigrated_ThenPrimaryInvestigationIsLinkedInComplaint(){
        User adminUser = createUser();
        System.runAs(adminUser){
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            //Arrange: Create complaint record
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
            complaint.compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id;
            insert complaint;
            
            //Arrange: Set Associated Item
            compliancequest__SQX_Complaint_Associated_Item__c complaint_associated_item = new compliancequest__SQX_Complaint_Associated_Item__c(
                compliancequest__SQX_Complaint__c = complaint.Id,
                compliancequest__Make_Primary__c = true,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id
            );
            insert complaint_associated_item;
            
            
            //Arrange: Create Investigation
            compliancequest__SQX_Investigation__c inv = new compliancequest__SQX_Investigation__c(
                compliancequest__SQX_Complaint__c = complaint.Id, 
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id,
                compliancequest__SQX_Associated_Item__c = complaint_associated_item.Id
            );
            insert inv;
            //create li manually as trigger is off li won't be created itself
            compliancequest__SQX_Linked_Investigation__c li = new compliancequest__SQX_Linked_Investigation__c();
            li.compliancequest__SQX_Associated_Item__c = complaint_associated_item.Id;
            li.compliancequest__SQX_Complaint__c = complaint.Id;
            li.compliancequest__SQX_Investigation__c = inv.Id;
            li.compliancequest__Unique_Investigation__c = ''+complaint.Id+inv.Id+complaint_associated_item.Id;
            insert li;
            
            //initiate complaint
            complaint.compliancequest__Activity_Code__c = 'initiate';
            complaint.compliancequest__Activity_Comment__c = 'Taking Ownership and Initiating Record';
            update complaint;
            
            //Act: execute migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            //Assert: Ensure primary investigation is linked in Complaint.
            System.assertEquals(inv.Id, [SELECT compliancequest__SQX_Primary_Investigation__c FROM compliancequest__SQX_Complaint__c WHERE Id =: complaint.Id].compliancequest__SQX_Primary_Investigation__c,'');
            
        }
    }
    
    /**
     * Given: Complaint without Associated Item
     * When: Migrated
     * Then: Primary Investigation is linked in Complaint
     */
    public static testmethod void givenComplaintWithOutAI_WhenMigrated_ThenPrimaryInvestigationIsLinkedInComplaint(){
        User adminUser = createUser();
        System.runAs(adminUser){
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            //Arrange: Create complaint record
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
            complaint.compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id;
            insert complaint;
            
            //Arrange: Create Investigation
            compliancequest__SQX_Investigation__c inv = new compliancequest__SQX_Investigation__c(
                compliancequest__SQX_Complaint__c = complaint.Id, 
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id
            );
            insert inv;
            
            //initiate complaint
            complaint.compliancequest__Activity_Code__c = 'initiate';
            complaint.compliancequest__Activity_Comment__c = 'Taking Ownership and Initiating Record';
            update complaint;
            
            //Act: execute migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            //Assert: Ensure Part Family is linked in Complaint.
            System.assertEquals(inv.Id, [SELECT compliancequest__SQX_Primary_Investigation__c FROM compliancequest__SQX_Complaint__c WHERE Id =: complaint.Id].compliancequest__SQX_Primary_Investigation__c,'');
        }
    }
    
    /**
     * Given: Complaint and Investigations
     * When: Migrated
     * Then: Linked investigation are created
     */
    public static testmethod void givenComplaintAndInvestigations_WhenMigrated_ThenLinkedInvestigationsAreCreated(){
        User adminUser = createUser();
        System.runAs(adminUser){
            Id devRecordTypeId = Schema.SObjectType.compliancequest__SQX_Investigation__c.getRecordTypeInfosByName().get('Complaint Investigation').getRecordTypeId();
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
            
            compliancequest__SQX_Defect_Code__c complaintConclusion = new compliancequest__SQX_Defect_Code__c(
                Name = 'Test Defect Code 1', 
                compliancequest__Active__c = true,
                compliancequest__Defect_Category__C = 'Test_Category',
                compliancequest__Description__c = 'Test Description',
                compliancequest__Type__c = 'Complaint Code'
            );
            insert complaintConclusion;
            
            
            //Arrange: Create first complaint record
            compliancequest__SQX_Complaint__c complaint1 = new compliancequest__SQX_Complaint__c(
                compliancequest__Country_of_Origin__c = 'US',
                compliancequest__SQX_Department__c = department.Id,
                compliancequest__Description_As_Reported__c = 'Random Description',
                compliancequest__Aware_Date__c = Date.today(),
                compliancequest__Complaint_Title__c = 'Random Title',
                compliancequest__Reported_Date__c = Date.today(),
                compliancequest__Occurrence_Date__c = Date.today(),
                compliancequest__Outcome__c = 'Concern',
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__Complaint_Quantity__c = 1,
                compliancequest__Description__c = 'New Random Description',
                compliancequest__Current_Step__c = 1,
                compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id
            );
            insert complaint1;
            
            //Arrange: Set Associated Item
            compliancequest__SQX_Complaint_Associated_Item__c complaint_associated_item1 = new compliancequest__SQX_Complaint_Associated_Item__c(
                compliancequest__SQX_Complaint__c = complaint1.Id,
                compliancequest__Make_Primary__c = true,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id
            );
            //insert complaint_associated_item1;
            
            //Arrange: Create second complaint record
            compliancequest__SQX_Complaint__c complaint2 = new compliancequest__SQX_Complaint__c(
                compliancequest__Country_of_Origin__c = 'US',
                compliancequest__SQX_Department__c = department.Id,
                compliancequest__Description_As_Reported__c = 'Random Description',
                compliancequest__Aware_Date__c = Date.today(),
                compliancequest__Complaint_Title__c = 'Random Title',
                compliancequest__Reported_Date__c = Date.today(),
                compliancequest__Occurrence_Date__c = Date.today(),
                compliancequest__Outcome__c = 'Concern',
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__Complaint_Quantity__c = 1,
                compliancequest__Description__c = 'New Random Description',
                compliancequest__Current_Step__c = 1,
                compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id
            );
            insert complaint2;
            
            //Arrange: Set Associated Item
            compliancequest__SQX_Complaint_Associated_Item__c complaint_associated_item2 = new compliancequest__SQX_Complaint_Associated_Item__c(
                compliancequest__SQX_Complaint__c = complaint2.Id,
                compliancequest__Make_Primary__c = true,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id
            );
            //insert complaint_associated_item2;
            
            //Arrange: Create third complaint record
            compliancequest__SQX_Complaint__c complaint3 = new compliancequest__SQX_Complaint__c(
                compliancequest__Country_of_Origin__c = 'US',
                compliancequest__SQX_Department__c = department.Id,
                compliancequest__Description_As_Reported__c = 'Random Description',
                compliancequest__Aware_Date__c = Date.today(),
                compliancequest__Complaint_Title__c = 'Random Title',
                compliancequest__Reported_Date__c = Date.today(),
                compliancequest__Occurrence_Date__c = Date.today(),
                compliancequest__Outcome__c = 'Concern',
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__Complaint_Quantity__c = 1,
                compliancequest__Description__c = 'New Random Description',
                compliancequest__Current_Step__c = 1,
                compliancequest__SQX_Complaint_Code__c = complaintConclusion.Id
            );
            insert complaint3;
            
            //Arrange: Set Associated Item
            compliancequest__SQX_Complaint_Associated_Item__c complaint_associated_item3 = new compliancequest__SQX_Complaint_Associated_Item__c(
                compliancequest__SQX_Complaint__c = complaint3.Id,
                compliancequest__Make_Primary__c = true,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id
            );
            //insert complaint_associated_item3;
            
            //Arrange: Create three Investigation
            compliancequest__SQX_Investigation__c inv1 = new compliancequest__SQX_Investigation__c(
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id,
                compliancequest__SQX_Complaint__c = complaint1.Id,
                RecordTypeId = devRecordTypeId
            );
            insert inv1;
            
            compliancequest__SQX_Investigation__c inv2 = new compliancequest__SQX_Investigation__c(
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id,
                compliancequest__SQX_Complaint__c = complaint2.Id,
                RecordTypeId = devRecordTypeId
            );
            insert inv2;
            
            compliancequest__SQX_Investigation__c inv3 = new compliancequest__SQX_Investigation__c(
                compliancequest__Investigation_Summary__c = 'Test',
                compliancequest__Status__c = SQX_9_1_1_Complaint_Migration.STATUS_DRAFT,
                compliancequest__SQX_Part__c = newPart.Id,
                compliancequest__SQX_Part_Family__c = partFamily.Id,
                compliancequest__SQX_Complaint__c = complaint3.Id,
                RecordTypeId = devRecordTypeId
            );
            insert inv3;
            
            
            List<compliancequest__SQX_Linked_Investigation__c> linkedInvs = [SELECT Id FROM compliancequest__SQX_Linked_Investigation__c WHERE compliancequest__SQX_Investigation__c IN: new List<compliancequest__SQX_Investigation__c>{inv1, inv2, inv3}];
            Database.DeleteResult[] res = Database.delete(linkedInvs);
            
            //initiate complaint1
            complaint1.compliancequest__Activity_Code__c = 'initiate';
            complaint1.compliancequest__Activity_Comment__c = 'Taking Ownership and Initiating Record';
            
            //initiate complaint2
            complaint2.compliancequest__Activity_Code__c = 'initiate';
            complaint2.compliancequest__Activity_Comment__c = 'Taking Ownership and Initiating Record';
            
            //initiate complaint3
            complaint3.compliancequest__Activity_Code__c = 'initiate';
            complaint3.compliancequest__Activity_Comment__c = 'Taking Ownership and Initiating Record';
            
            Database.update(new List<compliancequest__SQX_Complaint__c> {complaint1, complaint2, complaint3}, true);
            
            
            //Act: execute migration
            Test.startTest();
            SQX_9_1_1_Complaint_Migration job = new SQX_9_1_1_Complaint_Migration();
            Id batchProcessId = Database.executeBatch(job);
            Test.stopTest();
            
            List<compliancequest__SQX_Linked_Investigation__c> linkedInvestigations = [SELECT Id FROM compliancequest__SQX_Linked_Investigation__c WHERE compliancequest__SQX_Investigation__c IN: new List<compliancequest__SQX_Investigation__c>{inv1, inv2, inv3}];
            System.assertEquals(3, linkedInvestigations.size(), 'Linked invs are not created.');
        }
    }
    
    
    /**
     * Adds a regulatory report that is linked with the decision tree run
     * @param dtree the decision tree run that is to be associated with the regulatory report
     * @param status the status of the newly added report.
     * @return returns the newly inserted regulatory report.
     */
    public static compliancequest__SQX_Regulatory_Report__c addRegulatoryReport(compliancequest__SQX_Decision_Tree__c dtree, String status, Id compId){
        return addRegulatoryReport(dtree, status, null, null, null, compId);
    }
    
    /**
     * Adds a regulatory report that is liked with decision tree run
     * @param dtree the decision tree run that is to be associate with the regulatory report
     * @param status of the newly added report
     * @param duedate the date when the report is due
     * @param assignee the person who should be assigned the submission of the report
     * @return returns the newly inserted regulatory report object.
     */
    public static compliancequest__SQX_Regulatory_Report__c addRegulatoryReport(compliancequest__SQX_Decision_Tree__c dtree, String status, Date dueDate, User assignee,Id compId){
        return addRegulatoryReport(dtree, status, dueDate, assignee, null, compId);
    }
    
    public static compliancequest__SQX_Regulatory_Report__c addRegulatoryReport(compliancequest__SQX_Decision_Tree__c dtree, String status, Date dueDate, User assignee, compliancequest__SQX_Submission_History__c history, Id compId){
        compliancequest__SQX_Regulatory_Report__c report = new compliancequest__SQX_Regulatory_Report__c(
            compliancequest__SQX_Decision_Tree__c = dtree != null ? dtree.Id : null,
            compliancequest__SQX_Complaint__c = compId,
            compliancequest__Status__c = status,
            compliancequest__SQX_Submission_History__c = history != null ? history.Id : null,
            Name = 'Regulatory Report 1'
        );
        
        if(dueDate != null)
            report.compliancequest__Due_Date__c = dueDate;
        else
            report.compliancequest__Due_Date__c = Date.today().addDays(10);
        
        if(assignee != null)
            report.compliancequest__SQX_User__c = assignee.Id;
        
        insert report;
        return report;
    }
    
    /**
     * This method runs a decision tree for a particular task object for the complaint.
     * @param related the decision tree task that is to be run for the complaint.
     * @return returns the newly inserted decision tree for the complaint and decision tree task.
     */
    public static compliancequest__SQX_Decision_Tree__c runDecisionTreeTask(compliancequest__SQX_Task__c related, Id compId){
        compliancequest__SQX_Decision_Tree__c dtree = new compliancequest__SQX_Decision_Tree__c(
            compliancequest__SQX_Task__c = related.Id,
            compliancequest__SQX_Complaint__c = compId,
            Name = 'RUN-DTREE-' + related.Name
        );
        insert dtree;
        return dtree;
    }
    
    //Creates user
    public static User createUser() {
        integer randomNumber = (Integer)( Math.random() * 1000000 );
        List<Profile> profiles = new List<Profile>();
        
        profiles = [SELECT ID FROM Profile WHERE Name = : 'System Administrator'];
        
        User user = new User();
        user.Username =  'a' + randomNumber + '@test' + randomNumber + '.com';
        user.Email = 'a' + randomNumber + '@test' + randomNumber + '.com';
        user.FirstName =  'a' + randomNumber;
        user.LastName = 'a' + randomNumber;
        user.CommunityNickname = 's' + randomNumber;
        user.ProfileId = profiles[0].id;
        
        user.Alias =  '' + randomNumber;
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.AboutMe = 'fd';
        
        insert user;

        List<PermissionSet> permissionSets = [SELECT ID FROM PermissionSet WHERE Name ='CQ_System_Administrator' OR Name = 'CQ_Migration_User'];

        if(permissionSets.size() > 0){
            PermissionSetAssignment  assignPermissionSet =   new PermissionSetAssignment(AssigneeId=user.Id, PermissionSetId=permissionSets.get(0).Id);
            PermissionSetAssignment  assignPermissionSet1 =   new PermissionSetAssignment(AssigneeId=user.Id, PermissionSetId=permissionSets.get(1).Id);
            insert assignPermissionSet;
            insert assignPermissionSet1;

        }
        return user;
    }
}