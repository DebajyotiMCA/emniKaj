trigger Weir_NC_to_Part_or_Defect_Update on compliancequest__SQX_Nonconformance__c (after insert) 
{
    list<Id> NC_Id = new list<Id>();
    list<String> Impacted_Part = new list<String>();
    list<String> Impacted_Part_Number = new list<String>();
    list<String> Quantity = new list<String>();
    list<String> Defect_Category = new list<String>();
    list<String> Defect_Description = new list<String>();
    list<String> Part_Id = new list<String>();
    for(compliancequest__SQX_Nonconformance__c NC : trigger.new)
    {
        NC_Id.add(NC.Id);
        Impacted_Part.add(NC.Impacted_Part__c);
        Impacted_Part_Number.add(NC.Weir_Impacted_Part_Number__c);
        Quantity.add(NC.Quantity__c);
        Defect_Category.add(string.valueof(NC.Weir_Defect_Category__c));
        Defect_Description.add(NC.Defect_Description__c);
    }
    for(compliancequest__SQX_Nonconformance__c NC : trigger.new)
    {
        list<compliancequest__SQX_Part__c> count = [select id from compliancequest__SQX_Part__c];
        list<compliancequest__SQX_Nonconformance__c> Nonconformance = [select id from compliancequest__SQX_Nonconformance__c where id in: NC_Id];
        compliancequest__SQX_Part__c Part = new compliancequest__SQX_Part__c();
        Part.Name=Impacted_Part[0];
        Part.compliancequest__Active__c=True;
        Part.compliancequest__Part_Number__c= string.valueOf(count.size()+1);
        Part.compliancequest__Part_Family__c='a2N67000004TkbC';
        Part.compliancequest__Part_Risk_Level__c=5;
        insert Part;
        
        compliancequest__SQX_NC_Impacted_Product__c NC_Impacted_Part = new compliancequest__SQX_NC_Impacted_Product__c();
        NC_Impacted_Part.compliancequest__SQX_Nonconformance__c=Nonconformance[0].Id;
        NC_Impacted_Part.compliancequest__SQX_Impacted_Part__c=Part.Id;
        NC_Impacted_Part.compliancequest__Lot_Number__c='LOT-WEIR-001';
        NC_Impacted_Part.compliancequest__Sublot_Number__c='SUB-LOT-001';
        NC_Impacted_Part.compliancequest__Lot_Quantity__c=Integer.valueOf(Quantity[0]);
        Insert NC_Impacted_Part;
        
        compliancequest__SQX_NC_Defect__c Defect = new compliancequest__SQX_NC_Defect__c();
        Defect.compliancequest__SQX_Nonconformance__c=Nonconformance[0].Id;
        Defect.compliancequest__SQX_Part__c=Part.Id;
        Defect.compliancequest__Lot_Ser_Number__c='LOT-WEIR-001';
        Defect.compliancequest__SQX_Defect_Code__c='a1I6700000ZTqPg';
        Defect.compliancequest__Defect_Code__c=Defect_Description[0];
        Defect.compliancequest__Defect_Category__c=Defect_Category[0];
        Defect.compliancequest__Defect_Description__c=Defect_Description[0];
        Defect.compliancequest__Defective_Quantity__c=Integer.valueOf(Quantity[0]);
        Defect.compliancequest__Number_of_defects__c=Integer.valueOf(Quantity[0]);
        Insert Defect;
        
       
    }
}