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


public class ComplaintsExtensionClass {
    public compliancequest__SQX_Complaint__c ncr {get;set;}
    public compliancequest__SQX_Containment__c Contment {get;set;}
    public compliancequest__SQX_Investigation_Tool__c Invtool {get;set;}
    public List<compliancequest__SQX_Root_Cause__c> lstrootcause {get;set;}
    public List<compliancequest__SQX_Action_Plan__c > lstactionplans {get;set;}
    public List<Attachment> attachments {get;set;}
    public Map<String, Map<String, String>> mapForAttachmentsAndNames {get;set;} // Investigation = images, names
    public ComplaintsExtensionClass (ApexPages.StandardController ctd) 
    {
        try {
            // this.ncr = (compliancequest__SQX_Complaint__c ) ctd.getRecord();
            Id RecordId = apexpages.currentpage().getparameters().get('id');
            compliancequest__SQX_Complaint__c ncr= [SELECT id,Name,compliancequest__Actual_Return_Quantity__c,compliancequest__SQX_Account__c,Country_Of_Originate__c,
                                                    Customer_Account__r.Name,compliancequest__SQX_Account__r.Name,compliancequest__SQX_External_Contact__r.Name,compliancequest__Description__c,compliancequest__Expiration_Date__c,compliancequest__Is_Approved__c,
                                                    compliancequest__Lot_Number__c,
                                                    compliancequest__Model_Name__c,compliancequest__Occurrence_Date__c,
                                                    compliancequest__Org_Site__c,Penality_Cost__c,WEIR_Complaint_Department__c,
                                                    compliancequest__RMA_Number__c,compliancequest__SQX_External_Contact__c,
                                                    Serial_Number__c,Product_Description__c,OwnerId,
                                                    Warranty_Cost__c
                                                    FROM compliancequest__SQX_Complaint__c 
                                                    where id=:RecordId];
            // From Contaiment Object
            Contment = [Select id,Name,Complaint__c, compliancequest__Containment_Summary__c from compliancequest__SQX_Containment__c where Complaint__c =:RecordId LIMIT 1];
            
            // From Investigation Tool Object
            Invtool = [Select id,Name,compliancequest__Investigation_Tool_Method_Used__r.name,compliancequest__Description__c, compliancequest__SQX_Investigation__r.compliancequest__SQX_Complaint__c from compliancequest__SQX_Investigation_Tool__c where compliancequest__SQX_Investigation__r.compliancequest__SQX_Complaint__c =:RecordId LIMIT 1];
            
            //From Root Cause Object
            lstrootcause = [Select id,Name,compliancequest__Category__c, compliancequest__Description__c,compliancequest__SQX_Investigation__r.compliancequest__SQX_Complaint__c from compliancequest__SQX_Root_Cause__c where compliancequest__SQX_Investigation__r.compliancequest__SQX_Complaint__c =:RecordId ]; 
            
            //From Action Plan Object
            lstactionplans = [Select id,Name,compliancequest__Plan_Type__c, compliancequest__Description__c,compliancequest__SQX_Investigation__r.compliancequest__SQX_Complaint__c from compliancequest__SQX_Action_Plan__c where compliancequest__SQX_Investigation__r.compliancequest__SQX_Complaint__c =:RecordId ];
            
            //Attachements
            attachments = [SELECT Id,Name FROM Attachment WHERE ParentId = :RecordId];
            List<compliancequest__SQX_Investigation__c> investigationList = [Select id from compliancequest__SQX_Investigation__c where compliancequest__SQX_Complaint__c =:RecordId];
            mapForAttachmentsAndNames 	= new Map<String, Map<String, String>>();
            if(investigationList.size() > 0){
                
                List<Id> 			attachmentListId 	= new 	List<Id>();
                Map<Id, String> 	mapForObj 			= new 	Map<Id, String>();
                Map<Id, String> 	mapForNames 	 	= new 	Map<Id, String>();
                Map<String, String> mapForAttachs 		= new 	Map<String, String>();
                Map<Id, Set<Id>> 	mapForObj1 			= new 	Map<Id, set<Id>>();
                List<String> 		ids 				= new 	List<String>();
                List<Id> 			docId 				= new 	List<Id>();
                String 				documentId 			= null;
                
                for(compliancequest__SQX_Investigation__c obj: investigationList){
                    attachmentListId.add(obj.id);
                    mapForObj.put(obj.Id, 'Investigation');
                }
                List<compliancequest__SQX_Investigation_Tool__c> investigationToolList 	= [Select id from compliancequest__SQX_Investigation_Tool__c where compliancequest__SQX_Investigation__c in : attachmentListId];
                List<compliancequest__SQX_Action_Plan__c> actionPlanList 				= [Select id from compliancequest__SQX_Action_Plan__c where compliancequest__SQX_Investigation__c in : attachmentListId];
                List<compliancequest__SQX_Root_Cause__c> rootCauseList 					= [Select id from compliancequest__SQX_Root_Cause__c where compliancequest__SQX_Investigation__c in : attachmentListId];
                
                if(investigationToolList.size() > 0){
                    for(compliancequest__SQX_Investigation_Tool__c obj: investigationToolList){
                        attachmentListId.add(obj.id);
                        mapForObj.put(obj.Id, 'Investigation Tool');
                    }
                }
                
                if(actionPlanList.size() > 0){
                    for(compliancequest__SQX_Action_Plan__c obj: actionPlanList){
                        attachmentListId.add(obj.id);
                        mapForObj.put(obj.Id, 'Action Plan');
                    }
                }
                
                if(rootCauseList.size() > 0){
                    for(compliancequest__SQX_Root_Cause__c obj: rootCauseList){
                        attachmentListId.add(obj.id);
                        mapForObj.put(obj.Id, 'Root Cause');
                    }
                }
                
                List<ContentDocumentLink> links = [select ContentDocumentId,LinkedEntityId,Id,Visibility from ContentDocumentLink where LinkedEntityId in : attachmentListId];
                
                for(ContentDocumentLink link: links) {
                    ids.add(link.ContentDocumentId); 
                    if(mapForObj1.containsKey(link.LinkedEntityId))
                    {
                        Set<Id> idSet = mapForObj1.get(link.LinkedEntityId);
                        idSet.add(link.ContentDocumentId);
                    } else {
                        
                        mapForObj1.put(link.LinkedEntityId, new Set<Id>{link.ContentDocumentId});
                    }
                }
                List<ContentDocument> documents = [select Id, Description, Title from ContentDocument where Id IN: ids];
                
                for(ContentDocument document: documents) {
                    docId.add(document.Id);
                    mapForNames.put(document.Id, document.Title);
                }
                
                List<ContentVersion> ContentVersionList = [select Id,ContentDocumentId from ContentVersion where ContentDocumentId IN: docId];
                
                for(ContentVersion version : ContentVersionList){
                    String str = Site.getPathPrefix() + '/sfc/servlet.shepherd/version/download/'+version.Id;
                    for(Id objId : mapForObj.keySet()){
                        for(Id docuId : mapForObj1.keySet()){
                            if(objId == docuId && mapForObj1.get(docuId).contains(version.ContentDocumentId)){
                                if(mapForAttachmentsAndNames.containsKey(mapForObj.get(objId)))
                                {
                                    Map<String, String> mapString = mapForAttachmentsAndNames.get(mapForObj.get(objId));
                                    for(String st : mapForNames.keySet()){
                                        if(version.ContentDocumentId == st){
                                            mapString.put(str, mapForNames.get(st));
                                        }
                                    }
                                } else {
                                    for(String st : mapForNames.keySet()){
                                        if(version.ContentDocumentId == st){
                                            mapForAttachmentsAndNames.put(mapForObj.get(objId), new Map<String, String>{str => mapForNames.get(st)});
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        catch(Exception e) {
            
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    private void attachmentsWithNames(Map<Id, Set<Id>> mapForObj1, Map<Id, String> mapForObj){
        
    }
}