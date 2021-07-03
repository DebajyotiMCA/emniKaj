@isTest
public class NCExtensionclass_Test {
    
    static testMethod void insertNc(){
        Account acc = new Account();
        acc.Name   = 'test account';
        insert acc;
        
        Contact con 				= new Contact();
        con.LastName 				= 'con';
        con.AccountId 				= acc.Id;
        con.City__c 				= 'hyd';
        insert con;
        
        compliancequest__SQX_Department__c	 dep = new compliancequest__SQX_Department__c	();
        dep.name ='depName';
        insert dep;
        
        User userToCreate = new User();
        userToCreate.FirstName 				= 'rakesh';
        userToCreate.LastName  				= 'roy';
        userToCreate.Email     				= 'csvas95@gmail.com';
        userToCreate.Username  				= 'rakesh.roy@gmail.com';
        userToCreate.Alias     				= 'fatty';
        userToCreate.ProfileId 				= '00eb0000000s2JyAAI';
        userToCreate.TimeZoneSidKey    		= 'America/Denver';
        userToCreate.LocaleSidKey      		= 'en_US';
        userToCreate.EmailEncodingKey  		= 'UTF-8';
        userToCreate.LanguageLocaleKey 		= 'en_US';
        
        insert userToCreate;
        
        System.Test.startTest();
        
        compliancequest__SQX_Complaint__c complaint = new compliancequest__SQX_Complaint__c();
        complaint.compliancequest__Country__c 		= 'Canada';
        insert complaint;
        
        compliancequest__SQX_Nonconformance__c nc=new compliancequest__SQX_Nonconformance__c(compliancequest_MRR_Number__c='1234',
                                                                                             CQ_Weir_Item_Form__c='Weir Manufactured',
                                                                                             compliancequest__Description__c='this is test',
                                                                                             compliancequest__SQX_Account__c=acc.Id,
                                                                                             compliancequest__SQX_External_Contact__c=con.Id,
                                                                                             compliancequest__SQX_Department__c = dep.Id,
                                                                                             compliancequest__Type__c='supplier',
                                                                                             compliancequest_Department__c='Finance',
                                                                                             compliancequest__Department__c=dep.Id,
                                                                                             compliancequest__Occurrence_Date__c=Date.Today(),
                                                                                             compliancequest__Type_Of_Issue__c='Major',
                                                                                             //          compliancequest__SQX_Department__c='Manufacturing',
                                                                                             compliancequest__Due_Date_Disposition__c=Date.today(),
                                                                                             compliancequest_MRR_Revision__c='Tested',
                                                                                             compliancequest_Ref_Type__c='stage',
                                                                                             compliancequest_Job__c='It',
                                                                                             compliancequest__Org_Division__c='Weir Oil & Gas',
                                                                                             //        Weir_Quantity__c='10',
                                                                                             compliancequest_RCVR_Number__c='10',
                                                                                             Defect_Description__c='THis is getting worst',
                                                                                             Weir_Defect_Category__c='CASTING DEFECT',
                                                                                             Description_of_ITEM__c='Ok',
                                                                                             //Impacted_Part__c='Bone',
                                                                                             //      compliancequest__SQX_Inspection__c='Test',
                                                                                             Work_Order_Number__c='10',
                                                                                             Assign_To__c=userToCreate.id,
                                                                                             Serial_Number__c='10',
                                                                                             compliancequest_Heat_Code__c='10',
                                                                                             compliancequest_Machine__c='Machine',
                                                                                             compliancequest__Close_Date__c=Date.today(),
                                                                                             Shift__c='First',
                                                                                             Quantity__c = '1');
        insert nc;
        
        compliancequest__SQX_Containment__c contain 				= new compliancequest__SQX_Containment__c();
        contain.compliancequest__Containment_Summary__c 			= 'test';
        contain.compliancequest__SQX_Nonconformance__c				= nc.Id;
        contain.compliancequest__Completion_Date__c 				= Date.today();
        insert contain;     
        
        compliancequest__SQX_Investigation__c inv					= new compliancequest__SQX_Investigation__c();
        inv.compliancequest__SQX_Complaint__c 						= complaint.Id;
        insert inv;
        
        compliancequest__SQX_Action_Plan__c action 					= new compliancequest__SQX_Action_Plan__c();
        action.compliancequest__SQX_Investigation__c 				= inv.Id;
        action.compliancequest__Due_Date__c 						= Date.today();
        insert action;
        
        try{        
            compliancequest__SQX_Disposition__c disp3				= new compliancequest__SQX_Disposition__c();
            disp3.compliancequest__SQX_Nonconformance__c			= nc.Id;
            disp3.compliancequest__Disposition_Type__c 				= 'Rework';
            //insert disp3;
        }catch(Exception e){}
        
        PageReference pageRef 			= Page.SQX_NC;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', nc.Id);
        NCExtensionclass ncClass 		= new NCExtensionclass(new ApexPages.StandardController(nc));
        ncClass.apnDes					= '';
        ncClass.dcQty					= '';
        ncClass.onHoldQty				= 'Rework';
        ncClass.rejectedQty				= 'Scrap';
        ncClass.myProperty				= null;
        
        contain.compliancequest__SQX_Nonconformance__c = null;
        update contain;
        NCExtensionclass ncClass1 		= new NCExtensionclass(new ApexPages.StandardController(nc));
        ApexPages.currentPage().getParameters().put('id', '');
        NCExtensionclass ncClass2 		= new NCExtensionclass(new ApexPages.StandardController(nc));
        
        System.Test.stopTest();
    }
}