@isTest(seeAllData=true)
public class InvoiceArabicTest {
	static testMethod void testActiveMethod(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Invoice__c invoi = new Invoice__c();
        invoi.Name = 'test';
        invoi.Customer__c = acc.id;
        insert invoi;
        
        Invoice_Line_Items__c item = new Invoice_Line_Items__c();
        item.Invoice__c = invoi.Id;
        insert item;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(invoi);
        InvoiceArabic testAccPlan = new InvoiceArabic(sc);
        testAccPlan.getItems();
        
        PageReference pageRef = Page.InvoiceArabic;
        pageRef.getParameters().put('id', String.valueOf(invoi.Id));
        Test.setCurrentPage(pageRef);
        
    }
}