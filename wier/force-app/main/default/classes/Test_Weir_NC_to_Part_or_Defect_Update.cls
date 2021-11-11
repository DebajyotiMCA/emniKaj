@isTest(seeAllData=true)
private class Test_Weir_NC_to_Part_or_Defect_Update {

    static testMethod void validatePartRelatedData() {
       compliancequest__SQX_Department__c dept=new compliancequest__SQX_Department__c();
        dept.Name='test';
        insert dept;
        compliancequest__SQX_Nonconformance__c NC=new compliancequest__SQX_Nonconformance__c();
        nc.compliancequest__Type__c	='Product';
        nc.compliancequest__Type_Of_Issue__c = 'Minor';
       nc.compliancequest__Occurrence_Date__c=date.ValueOf('2019-09-26');
          nc.compliancequest__SQX_Department__c=dept.id;
        nc.Weir_Impacted_Part_Number__c	= 'SC1234';
        nc.Impacted_Part__c = 'SCREW';
        nc.Quantity__c = '20';
        
       // nc.CEAT_Business_stopped__c=true;
        insert NC;	
        
    }
    
}