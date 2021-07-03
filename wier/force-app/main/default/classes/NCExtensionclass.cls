public class NCExtensionclass {
    public compliancequest__SQX_Nonconformance__c ncr{get;set;}
    public list<compliancequest__SQX_Nonconformance__c> nc;
    public List<compliancequest__SQX_Disposition__c> DcList{get;set;}
    public List<compliancequest__SQX_Action_Plan__c > lstactionplans {get;set;}
    public List<compliancequest__SQX_Containment__c> Con{get;set;}
    public String conSummary{get;set;}
    public String apnDes{get;set;}
    public String dcQty{get;set;}
    public String receivedQty{get;set;}
    public String onHoldQty{get;set;}
    public String rejectedQty{get;set;}
    public List<string> myProperty{get;set;}
    public NCExtensionclass (ApexPages.StandardController ctd) 
    {
        try 
        {
            this.ncr = (compliancequest__SQX_Nonconformance__c ) ctd.getRecord();
            Id RecordId = apexpages.currentpage().getparameters().get('id');
            list<compliancequest__SQX_Nonconformance__c> nonC= [SELECT id,Name,Disposition_Type__c,compliancequest_MRR_Number__c,CQ_Weir_Item_Form__c,
                                                                compliancequest__Description__c,compliancequest__SQX_Account__r.name,compliancequest_MRR_Revision__c,compliancequest_Ref_Type__c,
                                                                compliancequest_Job__c,compliancequest__Org_Division__c,createdDate,Weir_Quantity__c,
                                                                compliancequest_RCVR_Number__c,Defect_Description__c,Weir_Defect_Category__c,compliancequest__Has_Containment__c,
                                                                compliancequest__Corrective_Action_Required__c,Description_of_ITEM__c,
                                                                Impacted_Part__c,compliancequest__SQX_Inspection__r.name,Work_Order_Number__c,
                                                                
                                                                Assign_To__r.name,Serial_Number__c,compliancequest_Heat_Code__c,compliancequest_Machine__c,compliancequest__Close_Date__c,Shift__c
                                                                FROM compliancequest__SQX_Nonconformance__c 
                                                                where id=:RecordId];
            
            lstactionplans = [Select id,Name,compliancequest__Plan_Type__c, compliancequest__Description__c,compliancequest__SQX_Investigation__r.compliancequest__SQX_Nonconformance__c from compliancequest__SQX_Action_Plan__c where compliancequest__SQX_Investigation__r.compliancequest__SQX_Nonconformance__c =:RecordId ];
                                                                
     /*      Apn = new List<compliancequest__SQX_Action_Plan__c>();
             Apn = [Select id,compliancequest__Description__c FROM compliancequest__SQX_Action_Plan__c where SQX_Nonconformance__c =:nonC[0].id limit 1];
            if(!Apn.isEmpty()){
                apnDes=Apn[0].compliancequest__Description__c;
            }
            else{
                apnDes = '';
                
            }
system.debug('your value is:'+apnDes); */
            Decimal receivedQtyVal = 0;
            DcList = [Select id,compliancequest__Disposition_Quantity__c,compliancequest__Disposition_Type__c 
                      FROM compliancequest__SQX_Disposition__c where compliancequest__SQX_Nonconformance__c  =:nonC[0].id];
            
            for(compliancequest__SQX_Disposition__c dc : DcList){
                if(dc.compliancequest__Disposition_Type__c == 'Rework'){
                    onHoldQty=String.valueOf(dc.compliancequest__Disposition_Quantity__c);
                } else if(dc.compliancequest__Disposition_Type__c == 'Scrap'){
                    rejectedQty=String.valueOf(dc.compliancequest__Disposition_Quantity__c);
                } else if(dc.compliancequest__Disposition_Type__c == 'Return To Vendor (RTV)'){
                    receivedQtyVal+=dc.compliancequest__Disposition_Quantity__c;
                } else if(dc.compliancequest__Disposition_Type__c == 'Use As Is'){
                    receivedQtyVal+=dc.compliancequest__Disposition_Quantity__c;
                } else{
                    continue;
                }
            }
            receivedQty = String.valueOf(receivedQtyVal);
            
            //Con = new List<compliancequest__SQX_Containment__c>();
             Con = [Select id,compliancequest__Containment_Summary__c from compliancequest__SQX_Containment__c where compliancequest__SQX_Nonconformance__c  =:nonC[0].id limit 1];
            if(!Con.isEmpty()){
                conSummary=con[0].compliancequest__Containment_Summary__c;
            }
            else{
                conSummary = '';
            }
            /*
          myProperty = new list<String>();
        
        schema.DescribeFieldResult fd = compliancequest__SQX_Disposition__c.compliancequest__Disposition_Type__c.getdescribe();
        List<Schema.PicklistEntry> P  = fd.getpicklistvalues();        
        
        for(Schema.PicklistEntry f: p){        
            myProperty.add(f.getvalue());   
            system.debug('m:'+myProperty);
        }
   */
        }
        catch(Exception e) 
        {
            
            System.debug('The following exception has occurred: ' + e.getMessage());
        }}}