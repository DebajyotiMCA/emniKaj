/** ========================================================================================
* Class Name               : ComplaintsExtensionClass
* Description              : Printing the complaint record and its related list
* Created Date             : [22-03-2020]
* Created By               : Srinivas C [Salesforce Developer]
* Organization             : coServe Software Solutions
*
* Date Modified                Modified By                  Description of the update
*    ----                         ----                              ----  ----
============================================================================================ */

@isTest
public class ComplaintsExtensionClass_Test {
    static testmethod void insertComplaint(){
        System.Test.startTest();
        
        Account acc 				= new Account();
        acc.Name 					= 'test Account';
        insert acc;
        
        Contact con 				= new Contact();
        con.LastName 				= 'con';
        con.AccountId 				= acc.Id;
        con.City__c 				= 'Bnglr';
        insert con;
        
        CustomerAccount__c custAcc 	= new CustomerAccount__c();
        custAcc.Name 				= 'test customer Account';
        insert custAcc;
        
        compliancequest__SQX_Complaint__c complaint = new compliancequest__SQX_Complaint__c(compliancequest__Activity_Code__c 				= '1234',
                                                                                            compliancequest__Activity_Comment__c 			= 'This is a test Comment.  Please ignore this!',
                                                                                            compliancequest__Actual_Return_Quantity__c 		= 12,
                                                                                            compliancequest__Additional_Info__c 			= false,
                                                                                            compliancequest__Additional_Info_Alert_Date__c 	= Date.today(),
                                                                                            compliancequest__Age_Before_Reopen__c 			= 12,
                                                                                            compliancequest__Aware_Date__c 					= Date.today(),
                                                                                            compliancequest__Batch_Job_Error__c 			= 'Nothing',
                                                                                            compliancequest__Batch_Job_Status__c 			= 'Completed',
                                                                                            compliancequest__Brand_Name__c 					= 'test',
                                                                                            compliancequest__SQX_Account__c 				= acc.Id,
                                                                                            Customer_Account__c 							= custAcc.Id,
                                                                                            compliancequest__SQX_External_Contact__c 		= con.Id,
                                                                                            compliancequest__Description__c 				= 'Test description',
                                                                                            compliancequest__Expiration_Date__c 			= Date.today(),
                                                                                            compliancequest__Is_Approved__c					= true,
                                                                                            compliancequest__Lot_Number__c 					= '6541',
                                                                                            compliancequest__Model_Name__c 					= 'Test Model',
                                                                                            compliancequest__Occurrence_Date__c 			= Date.today(),
                                                                                            Penality_Cost__c 								= '987',
                                                                                            WEIR_Complaint_Department__c 					= 'IT',
                                                                                            compliancequest__RMA_Number__c 					= '4562',
                                                                                            Serial_Number__c 								= '987456321',
                                                                                            Product_Description__c 							= 'Test product description',
                                                                                            Warranty_Cost__c 								= '500');
        
        insert complaint;
        
        compliancequest__SQX_Investigation__c inv					= new compliancequest__SQX_Investigation__c();
        inv.compliancequest__SQX_Complaint__c 						= complaint.Id;
        insert inv;
        
        compliancequest__SQX_Containment__c contain 				= new compliancequest__SQX_Containment__c();
        contain.compliancequest__Containment_Summary__c 			= 'test';
        contain.Complaint__c 										= complaint.Id;
        contain.compliancequest__Completion_Date__c 				= Date.today();
        insert contain;
        
        compliancequest__SQX_Investigation_Tool_Name__c tool 		= new compliancequest__SQX_Investigation_Tool_Name__c();
        tool.Name 													= 'test';
        insert tool;
        
        compliancequest__SQX_Investigation_Tool__c invTool 			= new compliancequest__SQX_Investigation_Tool__c();
        invTool.compliancequest__SQX_Investigation__c 				= inv.Id;
        invTool.compliancequest__Investigation_Tool_Method_Used__c 	= tool.Id;
        insert invTool;
        
        compliancequest__SQX_Action_Plan__c action 					= new compliancequest__SQX_Action_Plan__c();
        action.compliancequest__SQX_Investigation__c 				= inv.Id;
        action.compliancequest__Due_Date__c 						= Date.today();
        insert action;
        
        compliancequest__SQX_Root_Cause__c root 					= new compliancequest__SQX_Root_Cause__c();
        root.compliancequest__SQX_Investigation__c 					= inv.Id;
        insert root;
        
        ContentVersion contentVersion_1 	= new ContentVersion(Title 			= 'Penguins',
                                                                 PathOnClient 	= 'Penguins.jpg',
                                                                 VersionData 	= Blob.valueOf('Test Content')
                                                                );
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 	= [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        
        ContentDocumentLink contentlink 	= new ContentDocumentLink();
        contentlink.LinkedEntityId 			= inv.id;
        contentlink.contentdocumentid 		= contentVersion_2.contentdocumentid;
        contentlink.ShareType 				= 'V';
        insert contentlink; 
        
        ContentVersion contentVersion_3 	= new ContentVersion(Title 			= 'Penguins 1',
                                                                 PathOnClient 	= 'Penguins_1.jpg',
                                                                 VersionData 	= Blob.valueOf('Test Content 1')
                                                                );
        insert contentVersion_3;
        
        ContentVersion contentVersion_4 	= [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_3.Id LIMIT 1];
        
        ContentDocumentLink contentlink1 	= new ContentDocumentLink();
        contentlink1.LinkedEntityId 		= inv.id;
        contentlink1.contentdocumentid 		= contentVersion_4.contentdocumentid;
        contentlink1.ShareType 				= 'V';
        insert contentlink1; 
        
        PageReference pageRef 				= Page.ComplaintsPrint;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc 	= new ApexPages.Standardcontroller(complaint);
        ApexPages.currentPage().getParameters().put('id',complaint.id);
        
        ComplaintsExtensionClass compClass 	= new ComplaintsExtensionClass(sc);
        
        System.Test.stopTest();
    }
}