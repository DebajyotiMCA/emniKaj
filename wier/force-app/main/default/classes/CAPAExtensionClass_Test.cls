@isTest
public class CAPAExtensionClass_Test {
    static testMethod void testMethod1(){
        
        compliancequest__SQX_CAPA__c capa 					= new compliancequest__SQX_CAPA__c();
        capa.compliancequest__Target_Due_Date__c 			= Date.today();
        capa.compliancequest__Due_Date__c 					= Date.today();
        insert capa;
        
        compliancequest__SQX_Investigation__c inv 			= new compliancequest__SQX_Investigation__c();
        inv.compliancequest__SQX_CAPA__c 					= capa.Id;
        insert inv;
        
        compliancequest__SQX_Action_Plan__c action 			= new compliancequest__SQX_Action_Plan__c();
        action.compliancequest__Due_Date__c 				= Date.today();
        action.compliancequest__SQX_Investigation__c 		= inv.Id;
        insert action;
        
        compliancequest__SQX_Containment__c contain 		= new compliancequest__SQX_Containment__c();
        contain.compliancequest__SQX_CAPA__c 				= capa.Id;
        contain.compliancequest__Completion_Date__c 		= Date.today();
        contain.compliancequest__Containment_Summary__c 	= 'Test Summary';
        insert contain;
        
        compliancequest__SQX_Root_Cause__c root 			= new compliancequest__SQX_Root_Cause__c();
        root.compliancequest__SQX_Investigation__c 			= inv.Id;
        insert root;
        
        compliancequest__SQX_Effectiveness_Review__c eff 	= new compliancequest__SQX_Effectiveness_Review__c();
        eff.compliancequest__SQX_CAPA__c 					= capa.Id;
        eff.compliancequest__Review_Started_On__c 			= Date.today();
        insert eff;
        
        compliancequest__SQX_Finding_Response__c find 		= new compliancequest__SQX_Finding_Response__c();
        find.compliancequest__SQX_CAPA__c 					= capa.Id;
        find.compliancequest__Response_Summary__c 			= 'Test Summary';
        insert find;
        
        compliancequest__SQX_Action__c action1 				= new compliancequest__SQX_Action__c();
        action1.compliancequest__SQX_CAPA__c				= capa.Id;
        action1.compliancequest__Plan_Type__c				= 'Preventive';
        action1.compliancequest__Due_Date__c				= Date.today();
        action1.compliancequest__Description__c				= 'TEST';
        insert action1;
        
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
        contentlink1.LinkedEntityId 		= capa.id;
        contentlink1.contentdocumentid 		= contentVersion_4.contentdocumentid;
        contentlink1.ShareType 				= 'V';
        insert contentlink1; 
        
        System.Test.startTest();
        
        PageReference pageRef 			= Page.SQX_CAPA;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', capa.Id);
        CAPAExtensionclass capaClass 	= new CAPAExtensionclass(new ApexPages.StandardController(capa));
        capaClass.ncp = null;
        
        System.Test.stopTest();
    }
}