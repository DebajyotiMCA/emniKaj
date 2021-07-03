@isTest
private class Test_ParetoChartClass {
    static testMethod void validateprepareData() {
        string JsonStr ;
        ParetoChartClass controller = new ParetoChartClass() ;
        ParetoChartClass.Nonconformance nc = new ParetoChartClass.Nonconformance();
        List<ParetoChartClass.Nonconformance> ncList = new List<ParetoChartClass.Nonconformance>();
        
        List<compliancequest__SQX_Nonconformance__c> ncObjList = new List<compliancequest__SQX_Nonconformance__c>();
        compliancequest__SQX_Nonconformance__c ncObj = new compliancequest__SQX_Nonconformance__c();
        Test.startTest();
        ParetoChartClass.Nonconformance ncc = new ParetoChartClass.Nonconformance();
        ncc.x = 'Hi';
        ncc.y = 12;
        ncList.add(ncc);
        Test.stopTest();
        /*   compliancequest__SQX_Department__c dept=new compliancequest__SQX_Department__c(name='test');
insert dept;
ncObj.compliancequest__Type__c='Customer';
ncObj.compliancequest__Type_Of_Issue__c='Major';
ncObj.compliancequest__Occurrence_Date__c=Date.today();
ncObj.compliancequest__SQX_Department__c=dept.Id;
ncObj.Quantity__c='10';
ncObj.Weir_Defect_Category__c='ASSEMBLY ERROR';
insert ncObj;

compliancequest__SQX_Part__c Part = new compliancequest__SQX_Part__c();
Part.Name='test';
Part.compliancequest__Active__c=True;
Part.compliancequest__Part_Number__c= '20';
Part.compliancequest__Part_Family__c='a1u1l000000tkks';
Part.compliancequest__Part_Risk_Level__c=5;
insert Part;
compliancequest__SQX_NC_Impacted_Product__c NC_Impacted_Part = new compliancequest__SQX_NC_Impacted_Product__c();
NC_Impacted_Part.compliancequest__SQX_Nonconformance__c=ncObj.Id;
NC_Impacted_Part.compliancequest__SQX_Impacted_Part__c=Part.Id;
NC_Impacted_Part.compliancequest__Lot_Number__c='LOT-WEIR-001';
NC_Impacted_Part.compliancequest__Sublot_Number__c='SUB-LOT-001';
NC_Impacted_Part.compliancequest__Lot_Quantity__c= Integer.valueOf(ncObj.Quantity__c);
Insert NC_Impacted_Part;*/
        
        
    }
}