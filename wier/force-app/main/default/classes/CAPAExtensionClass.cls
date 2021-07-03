public class CAPAExtensionClass {
    public compliancequest__SQX_CAPA__c capa {get;set;}
    public compliancequest__SQX_Containment__c Contment {get;set;}
    public compliancequest__SQX_Investigation__c Inv {get;set;}
    public compliancequest__SQX_Root_Cause__c Roc {get;set;}
    public List<compliancequest__SQX_Action_Plan__c> Acp {get;set;}
    public compliancequest__SQX_NC_CAPA__c ncp {get;set;}
    public compliancequest__SQX_Effectiveness_Review__c Efr {get;set;}
    public compliancequest__SQX_Finding_Response__c Res {get;set;}
    public compliancequest__SQX_Action__c action{get;set;}
    public Map<String, String> images {get;set;}
    public Map<String, String> images1 {get;set;}
    public List<String> imagesList {get;set;}
    public Boolean mapIsEmpty {get;set;}
    public Boolean map1IsEmpty {get;set;}
    public CAPAExtensionclass (ApexPages.StandardController ctd) 
    {
        try 
        {
            //this.ncr = (compliancequest__SQX_Nonconformance__c ) ctd.getRecord();
            Id RecordId = apexpages.currentpage().getparameters().get('id');
            capa =[SELECT Id,Name,Owner.name,compliancequest__Target_Due_Date__c,compliancequest__Issued_Date__c,WEIR_Department__c,compliancequest__Org_Site__c,compliancequest__Title__c,
                  compliancequest__Rating__c,compliancequest__CAPA_Type__c,compliancequest__SQX_Account__r.name,compliancequest__Closure_Comment__c,compliancequest__SQX_CAPA_Sponsor__r.name,compliancequest__Description__c,CFT_Member_1__c,CFT_Member_2__c,CFT_Member_3__c,compliancequest__SQX_CAPA_Coordinator__r.name FROM compliancequest__SQX_CAPA__c WHERE Id=:RecordId ];
      
            Acp =[Select id,Name,compliancequest__Plan_Type__c,compliancequest__Due_Date__c,compliancequest__Completed__c,
                  compliancequest__SQX_User__r.name, compliancequest__Description__c,
                  compliancequest__SQX_Investigation__r.compliancequest__SQX_CAPA__c 
                  from compliancequest__SQX_Action_Plan__c 
                  where compliancequest__SQX_Investigation__r.compliancequest__SQX_CAPA__c =:RecordId]; 
            images = new Map<String, String>();
            images1 = new Map<String, String>();
			imagesList = new List<String>();            
            Set<Id> cddocIds = new Set<Id>();
            Set<Id> docIds = new Set<Id>();
            Map<ContentDocument, String> idAndTitle1 = new Map<ContentDocument, String>();
            
             List<Attachment> attachedFiles = [SELECT Id,Name,ParentId FROM Attachment WHERE ParentId =:capa.Id];
            System.debug('>>>***>>> '+attachedFiles);
            Map<ContentDocument, String> idAndTitle = new Map<ContentDocument, String>();
            for(ContentDocumentLink cdLink : [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,
                                              SystemModstamp,Visibility FROM ContentDocumentLink 
                                              WHERE LinkedEntityId =:capa.Id]){
                                                  cddocIds.add(cdLink.ContentDocumentId);
                                              }
            for(ContentDocument cd : [SELECT ContentAssetId,ContentSize,Description,FileExtension,FileType,Id,
                                      ParentId,Title FROM ContentDocument WHERE Id IN :cddocIds]){
                                          docIds.add(cd.Id);
                                          
                                          if(cd.FileType != 'PNG' || cd.FileType != 'JPG' || cd.FileType != 'JPEG'
                                             || cd.FileType != 'SVG'){
                                                 imagesList.add(cd.Title);
                                                 idAndTitle1.put(cd, cd.Title);
                                             } else {
                                                 idAndTitle.put(cd, cd.Title);
                                             }
                                      }
            
            List<ContentVersion> ContentVersionList = [select Id,ContentDocumentId from ContentVersion where ContentDocumentId IN: docIds];
            for(ContentVersion version : ContentVersionList){
                String image1 = Site.getPathPrefix()+'/sfc/servlet.shepherd/version/download/'+version.Id;
                
                for(ContentDocument id1 : idAndTitle.keyset()){
                    if(id1.Id == version.ContentDocumentId){
                        images1.put(image1, idAndTitle.get(id1));//docx
                        System.debug('>>>>______ '+images);
                    }
                }
                for(ContentDocument id1 : idAndTitle1.keyset()){
                    if(id1.Id == version.ContentDocumentId){
                        images.put(image1, idAndTitle1.get(id1));//images
                        System.debug('>>>>______ '+images);
                    }
                }
            }
            
            if(images1.size()>0){
                mapIsEmpty = false;
            } else {
                mapIsEmpty = true;
            }
            
            if(images.size()>0){
                mapIsEmpty = false;
            } else {
                mapIsEmpty = true;
            }
            
            System.debug('>>>>'+Acp.size());
       // Immediate Containment or Interim Action (as applicable):
            Contment = [Select id,Name,compliancequest__Containment_Summary__c from compliancequest__SQX_Containment__c where compliancequest__SQX_CAPA__c =:RecordId LIMIT 1];
         // Investigation Summary
            Inv = [Select id,name,compliancequest__Investigation_Summary__c FROM compliancequest__SQX_Investigation__c where compliancequest__SQX_CAPA__c =:RecordId LIMIT 1];
             // Root Cause Analysis:

            Roc =[Select id,Name,compliancequest__Category__c, compliancequest__Description__c,compliancequest__SQX_Investigation__r.compliancequest__SQX_CAPA__c from compliancequest__SQX_Root_Cause__c where compliancequest__SQX_Investigation__r.compliancequest__SQX_CAPA__c =:RecordId];
            //response
            Res =[Select Id,Name,compliancequest__Submitted_By__c,compliancequest__Submitted_On__c From compliancequest__SQX_Finding_Response__c where compliancequest__SQX_CAPA__c =:RecordId LIMIT 1];
            //nc and capa
          //  ncp =[Select Id,name,compliancequest__SQX_CAPA__r.name,compliancequest__SQX_Nonconformance__r.name From compliancequest__SQX_NC_CAPA__c where compliancequest__SQX_CAPA__c=:RecordId];
            //Identify & Verify Implemented Permanent Corrective Actions
		//Implementation
            action = [SELECT Id,compliancequest__Plan_Type__c,compliancequest__Description__c,compliancequest__Completion_Date__c,compliancequest__Due_Date__c,compliancequest__Status__c,compliancequest__SQX_User__r.Name FROM compliancequest__SQX_Action__c WHERE compliancequest__SQX_CAPA__c=:capa.Id LIMIT 1];
       //Attachements
            List<compliancequest__SQX_CAPA__c> CAPAList = [Select id from compliancequest__SQX_CAPA__c where id =:RecordId];
            if(CAPAList.size() > 0){
                List<Id> attachmentListId = new List<Id>();
                Map<Id, String> mapForObj = new Map<Id, String>();
                Map<Id, String> mapForNames = new Map<Id, String>();
                Map<Id, Set<Id>> mapForObj1 = new Map<Id, set<Id>>();
                for(compliancequest__SQX_CAPA__c obj: CAPAList){
                    attachmentListId.add(obj.id);
                    mapForObj.put(obj.Id, 'CAPA');
                }}
        // Effectiveness
        Efr = [Select Id,name,compliancequest__Resolution__c,compliancequest__Status__c,compliancequest__Reviewed_By__c,compliancequest__Review_Started_On__c From compliancequest__SQX_Effectiveness_Review__c where compliancequest__SQX_CAPA__c =:RecordId LIMIT 1];
            
            
        }
             catch(Exception e) 
        {
            
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        }
        
}