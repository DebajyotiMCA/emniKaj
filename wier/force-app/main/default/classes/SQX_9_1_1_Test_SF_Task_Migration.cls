/**
 * test class for SQX_9_1_1_SF_Task_Migration batch job
 */
@isTest
public class SQX_9_1_1_Test_SF_Task_Migration {
    
    /**
     * GIVEN : SF Task without record type and task code
     * WHEN : Migration is ran
     * THEN : Propoer record type and task code is set
     */
    public static testMethod void givenSFTask_WhenMigrated_TaskCodeAndRecordActivityAreUpdated(){
        
        // ARRANGE : Setup SF Task without record type and task code
        Map<String, SObjectType> objType = Schema.getGlobalDescribe();
        Map<String, RecordTypeInfo> infos  = objType.get('Task').getDescribe().getRecordTypeInfosByDeveloperName();
        Id cqTaskRecordTypeId = infos.get('CQ_Task').getRecordTypeID();

        infos  = objType.get('compliancequest__SQX_Task__c').getDescribe().getRecordTypeInfosByDeveloperName();
        Id supplierMgmtRecordTypeId = infos.get('Supplier_Management_Step').getRecordTypeID();     
        Id complaintMgmtRecordTypeId = infos.get('Complaint_Management_Step').getRecordTypeID();   

        infos  = objType.get('compliancequest__SQX_Complaint_Task__c').getDescribe().getRecordTypeInfosByDeveloperName(); 
        Id sampleRequestRecordTypeId = infos.get('General').getRecordTypeID(); 

        infos  = objType.get('compliancequest__SQX_Onboarding_Step__c').getDescribe().getRecordTypeInfosByDeveloperName(); 
        Id approvalRecordTypeId = infos.get('Approval').getRecordTypeID();

        infos  = objType.get('compliancequest__SQX_Deviation_Process__c').getDescribe().getRecordTypeInfosByDeveloperName(); 
        Id auditRecordTypeId = infos.get('Perform_Audit').getRecordTypeID();
        
        compliancequest__SQX_Complaint__c complaint = new compliancequest__SQX_Complaint__c();
        complaint.compliancequest__Country_of_Origin__c = 'US';
        complaint.compliancequest__Description_As_Reported__c = 'Random Description';
        complaint.compliancequest__Aware_Date__c = Date.today();
        complaint.compliancequest__Complaint_Title__c = 'Random Title';
        complaint.compliancequest__Reported_Date__c = Date.today();
        complaint.compliancequest__Occurrence_Date__c = Date.today();
        complaint.compliancequest__Outcome__c = 'Concern';
        complaint.compliancequest__Description__c = 'New Random Description';
        
        insert complaint;
        
        
        // ARRANGE : Create CQ task
        compliancequest__SQX_Task__c task = new compliancequest__SQX_Task__c(compliancequest__Allowed_Days__c = 30, 
                                           compliancequest__SQX_User__c = UserInfo.getUserId(), 
                                           compliancequest__Description__c = 'Test_DESP', 
                                           compliancequest__Record_Type__c = 'Complaint',
                                           Name = 'Complaint',
                               				compliancequest__Step__c = 1,
                                           RecordTypeId = complaintMgmtRecordTypeId,
                                           compliancequest__Task_Type__c = 'Sample Request');
        
        // ACT : CQ Task is saved without step
        Database.SaveResult result = Database.insert(task, true);
        Date dueDate = Date.today() + 2;
        // ARRANGE : Create complaint task
        compliancequest__SQX_Complaint_Task__c complaintTask = new compliancequest__SQX_Complaint_Task__c();
        complaintTask.compliancequest__SQX_Task__c = task.Id;
        complaintTask.Name = 'Task Test';
        complaintTask.compliancequest__SQX_Complaint__c = complaint.Id;
        complaintTask.compliancequest__Due_Date__c = dueDate;
        complaintTask.compliancequest__Step__c = 1;
        complaintTask.compliancequest__Applicable__c = false;
        complaintTask.RecordTypeId = sampleRequestRecordTypeId;
        complaintTask.compliancequest__SQX_User__c = UserInfo.getUserId();
        
        Database.insert(complaintTask, false);
        
        Task sfTask = new Task();
        sfTask.Subject = 'Complaint Task';
        sfTask.Status = 'Not Started';
        sfTask.WhatId = complaint.Id;
        sfTask.compliancequest__Child_What_Id__c = complaintTask.Id;
        sfTask.compliancequest__CQ_Task_Code__c = '';
        
        insert sfTask;
        
        
        sfTask.RecordTypeId = null;
        update sfTask;
        
        task = new compliancequest__SQX_Task__c(compliancequest__Allowed_Days__c = 30, 
                                           compliancequest__SQX_User__c = UserInfo.getUserId(), 
                                           compliancequest__Description__c = 'Test_DESP', 
                                           compliancequest__Record_Type__c = 'Supplier Introduction',
                                           Name = 'Supplier Introduction',
                               				compliancequest__Step__c = 1,
                                           RecordTypeId = supplierMgmtRecordTypeId,
                                           compliancequest__Task_Type__c = 'Approval');
        
        // ACT : CQ Task is saved without step
        result = Database.insert(task, true);
        
        compliancequest__SQX_New_Supplier_Introduction__c nsi = new compliancequest__SQX_New_Supplier_Introduction__c(Name = 'AUTO', 
                                                                                    compliancequest__Company_Name__c = 'TEST_ACCOUNT', 
                                                                                    compliancequest__Supplier_Number__c = 'SUP_0001', 
                                                                                    compliancequest__First_Name__c = 'Test', 
                                                                                    compliancequest__Last_Name__c = 'User', 
                                                                                    compliancequest__Phone__c = '1234567890',
                                                                                    compliancequest__Part_Name__c = 'PART 1',
                                                                                    compliancequest__Result__c  = 'Approved');
        
        insert nsi;
        
        // ARRANGE : Create Onboarding step
        compliancequest__SQX_Onboarding_Step__c onboardingStep = new compliancequest__SQX_Onboarding_Step__c();
        onboardingStep.compliancequest__SQX_Task__c = task.Id;
        onboardingStep.Name = 'Task Test';
        onboardingStep.compliancequest__SQX_Parent__c = nsi.Id;
        onboardingStep.compliancequest__Due_Date__c = dueDate;
        onboardingStep.compliancequest__Step__c = 1;
        onboardingStep.compliancequest__Applicable__c = false;
        onboardingStep.RecordTypeId = approvalRecordTypeId;
        onboardingStep.compliancequest__SQX_User__c = UserInfo.getUserId();
        
        Database.insert(onboardingStep, true);
        
        sfTask = new Task();
        sfTask.Subject = 'Introduction Task';
        sfTask.Status = 'Not Started';
        sfTask.WhatId = nsi.Id;
        sfTask.compliancequest__Child_What_Id__c = onboardingStep.Id;
        sfTask.compliancequest__CQ_Task_Code__c = '';
        
        insert sfTask;
        
        
        sfTask.RecordTypeId = null;
        update sfTask;
        
        
        task = new compliancequest__SQX_Task__c(compliancequest__Allowed_Days__c = 30, 
                                           compliancequest__SQX_User__c = UserInfo.getUserId(), 
                                           compliancequest__Description__c = 'Test_DESP', 
                                           compliancequest__Record_Type__c = 'Supplier Deviation',
                                           Name = 'Supplier Deviation',
                               				compliancequest__Step__c = 1,
                                           RecordTypeId = supplierMgmtRecordTypeId,
                                           compliancequest__Task_Type__c = 'Perform Audit');
        
        // ACT : CQ Task is saved without step
        result = Database.insert(task, true);
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'test';
        insert con;
        
        compliancequest__SQX_Supplier_Deviation__c sd = new compliancequest__SQX_Supplier_Deviation__c(Name = 'TestName', 
                                                                     compliancequest__Phone__c = '1234567890',
                                                                     compliancequest__SQX_Account__c = acc.Id, 
                                                                     compliancequest__SQX_External_Contact__c = con.Id,
                                                                     compliancequest__Part_Name__c = 'Test Part',
                                                                     compliancequest__Result__c = 'Approved');
        
        insert sd;
                
        // ARRANGE : Create deviation process step
        compliancequest__SQX_Deviation_Process__c deviationProcess = new compliancequest__SQX_Deviation_Process__c();
        deviationProcess.compliancequest__SQX_Task__c = task.Id;
        deviationProcess.Name = 'Task Test';
        deviationProcess.compliancequest__SQX_Parent__c = sd.Id;
        deviationProcess.compliancequest__Due_Date__c = dueDate;
        deviationProcess.compliancequest__Step__c = 1;
        deviationProcess.compliancequest__Applicable__c = false;
        deviationProcess.RecordTypeId = auditRecordTypeId;
        deviationProcess.compliancequest__SQX_User__c = UserInfo.getUserId();
        
        Database.insert(deviationProcess, true);
        
        sfTask = new Task();
        sfTask.Subject = 'Deviation Task';
        sfTask.Status = 'Not Started';
        sfTask.WhatId = sd.Id;
        sfTask.compliancequest__Child_What_Id__c = deviationProcess.Id;
        sfTask.compliancequest__CQ_Task_Code__c = '';
        
        insert sfTask;
        
        
        sfTask.RecordTypeId = null;
        update sfTask;
        
        // ACT : Run migration
        Test.startTest();
        Database.executeBatch(new SQX_9_1_1_SF_Task_Migration());
        Test.stopTest();
        
        // ASSERT : Proper task code and record type is saved
		sfTask = [SELECT Id, compliancequest__CQ_Task_Code__c, RecordTypeId FROM Task WHERE WhatId = :complaint.Id];
		System.assertEquals('Sample_Request', sfTask.compliancequest__CQ_Task_Code__c);
		System.assertEquals(cqTaskRecordTypeId, sfTask.RecordTypeId);   
        
		sfTask = [SELECT Id, compliancequest__CQ_Task_Code__c, RecordTypeId FROM Task WHERE WhatId = :nsi.Id];
		System.assertEquals('Approval', sfTask.compliancequest__CQ_Task_Code__c);
		System.assertEquals(cqTaskRecordTypeId, sfTask.RecordTypeId);    
        
		sfTask = [SELECT Id, compliancequest__CQ_Task_Code__c, RecordTypeId FROM Task WHERE WhatId = :sd.Id];
		System.assertEquals('Perform_Audit', sfTask.compliancequest__CQ_Task_Code__c);
		System.assertEquals(cqTaskRecordTypeId, sfTask.RecordTypeId);         
    }
}