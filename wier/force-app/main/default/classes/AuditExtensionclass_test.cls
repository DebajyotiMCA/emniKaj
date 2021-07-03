@isTest//(SeeAllData=true)
public class AuditExtensionclass_test {
    static testmethod void aud_method()
    {
        
        user con=[select id from user limit 1];
               compliancequest__SQX_Audit__c aud=new compliancequest__SQX_Audit__c();
        aud.compliancequest__Audit_Category__c='QMS';
        aud.compliancequest__Org_Division__c='ALL';
            aud.compliancequest__Audit_Type__c='internal';
        aud.compliancequest__SQX_Auditee_Contact__c=con.id;
        aud.compliancequest__Location__c='test';
        aud.compliancequest__Title__c='test';
        insert aud;
        
        compliancequest__SQX_Finding__c fin=new compliancequest__SQX_Finding__c();
fin.compliancequest__Finding_Type__c='Major';
        fin.compliancequest__Criterion_Section__c='test';
         fin.compliancequest__Criterion_Sub_Section__c='test';
        fin.compliancequest__Description__c='test';
        fin.compliancequest__Title__c='test';
        fin.compliancequest__SQX_Audit__c=aud.id;
        fin.compliancequest__Due_Date_Containment__c=date.today();
        fin.compliancequest__Due_Date_Investigation__c=date.today();
        fin.compliancequest__Due_Date_Response__c=date.today();
        insert fin;
        
        compliancequest__SQX_Finding__c fin1=new compliancequest__SQX_Finding__c();
fin1.compliancequest__Finding_Type__c='Observation';
        fin1.compliancequest__Criterion_Section__c='test';
         fin1.compliancequest__Criterion_Sub_Section__c='test';
        fin1.compliancequest__Description__c='test';
        fin1.compliancequest__Title__c='test';
        fin1.compliancequest__SQX_Audit__c=aud.id;
                fin1.compliancequest__Due_Date_Containment__c=date.today();
        fin1.compliancequest__Due_Date_Investigation__c=date.today();
        fin1.compliancequest__Due_Date_Response__c=date.today();
        insert fin1;
        
        compliancequest__SQX_Finding__c fin2=new compliancequest__SQX_Finding__c();
fin2.compliancequest__Finding_Type__c='Minor';
        fin2.compliancequest__Criterion_Section__c='test';
         fin2.compliancequest__Criterion_Sub_Section__c='test';
        fin2.compliancequest__Description__c='test';
        fin2.compliancequest__Title__c='test';
        fin2.compliancequest__SQX_Audit__c=aud.id;
                fin2.compliancequest__Due_Date_Containment__c=date.today();
        fin2.compliancequest__Due_Date_Investigation__c=date.today();
                fin2.compliancequest__Due_Date_Response__c=date.today();
        insert fin2;
        
         Test.StartTest(); 
         PageReference pageRef 			= Page.SQX_Audit;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', aud.Id);
        AuditExtensionclass audClass = new AuditExtensionclass(new ApexPages.StandardController(aud));
       
        

        
        Test.StopTest();
    }
    
}