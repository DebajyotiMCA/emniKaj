@isTest(seeAllData=true)
public class InvoiceLineItem_TriggerTest {
    static testMethod void testActiveMethod(){
        Account acc = new Account();
        acc.Name = 'teset';
        insert acc;
        
        Invoice__c invoice = new Invoice__c();
        invoice.Name = 'test';
        invoice.Customer__c = acc.Id;
        insert invoice;
        
        Invoice_Line_Items__c lineitem = new Invoice_Line_Items__c();
        lineitem.Invoice__c = invoice.Id;
        lineitem.Product_Code__c = 'P01017';
        insert lineitem;
        
        Invoice_Line_Items__c lineitem2 = new Invoice_Line_Items__c();
        lineitem2.Invoice__c = invoice.Id;
        lineitem2.Product_Code__c = 'P01002';
        insert lineitem2;
        
        Invoice_Line_Items__c lineitem3 = new Invoice_Line_Items__c();
        lineitem3.Invoice__c = invoice.Id;
        lineitem3.Product_Code__c = 'P01401';
        insert lineitem3;
        
        Invoice_Line_Items__c lineitem4 = new Invoice_Line_Items__c();
        lineitem4.Invoice__c = invoice.Id;
        lineitem4.Product_Code__c = 'PP329';
        insert lineitem4;
        
        Invoice_Line_Items__c lineitem5 = new Invoice_Line_Items__c();
        lineitem5.Invoice__c = invoice.Id;
        lineitem5.Product_Code__c = 'P02440';
        insert lineitem5;
        
        Invoice_Line_Items__c lineitem6 = new Invoice_Line_Items__c();
        lineitem6.Invoice__c = invoice.Id;
        lineitem6.Product_Code__c = 'P01423';
        insert lineitem6;
        
        Invoice_Line_Items__c lineitem7 = new Invoice_Line_Items__c();
        lineitem7.Invoice__c = invoice.Id;
        lineitem7.Product_Code__c = 'P01451';
        insert lineitem7;
        
        Invoice_Line_Items__c lineitem8 = new Invoice_Line_Items__c();
        lineitem8.Invoice__c = invoice.Id;
        lineitem8.Product_Code__c = 'P01433';
        insert lineitem8;
        
        Invoice_Line_Items__c lineitem9 = new Invoice_Line_Items__c();
        lineitem9.Invoice__c = invoice.Id;
        lineitem9.Product_Code__c = 'P01437';
        insert lineitem9;
        
        Invoice_Line_Items__c lineitem10 = new Invoice_Line_Items__c();
        lineitem10.Invoice__c = invoice.Id;
        lineitem10.Product_Code__c = 'P02760';
        insert lineitem10;
        
        Invoice_Line_Items__c lineitem11 = new Invoice_Line_Items__c();
        lineitem11.Invoice__c = invoice.Id;
        lineitem11.Product_Code__c = 'PP211';
        insert lineitem11;
        
        Invoice_Line_Items__c lineitem12 = new Invoice_Line_Items__c();
        lineitem12.Invoice__c = invoice.Id;
        lineitem12.Product_Code__c = 'PP250';
        insert lineitem12;
        
        Invoice_Line_Items__c lineitem13 = new Invoice_Line_Items__c();
        lineitem13.Invoice__c = invoice.Id;
        lineitem13.Product_Code__c = 'P01083';
        insert lineitem13;
        
        Invoice_Line_Items__c lineitem14 = new Invoice_Line_Items__c();
        lineitem14.Invoice__c = invoice.Id;
        lineitem14.Product_Code__c = 'PP222';
        insert lineitem14;
        
        Invoice_Line_Items__c lineitem15 = new Invoice_Line_Items__c();
        lineitem15.Invoice__c = invoice.Id;
        lineitem15.Product_Code__c = 'PP282';
        insert lineitem15;
        
        Invoice_Line_Items__c lineitem16 = new Invoice_Line_Items__c();
        lineitem16.Invoice__c = invoice.Id;
        lineitem16.Product_Code__c = 'PP249';
        insert lineitem16;
        
        Invoice_Line_Items__c lineitem17 = new Invoice_Line_Items__c();
        lineitem17.Invoice__c = invoice.Id;
        lineitem17.Product_Code__c = 'PP468';
        insert lineitem17;
        
        Invoice_Line_Items__c lineitem18 = new Invoice_Line_Items__c();
        lineitem18.Invoice__c = invoice.Id;
        lineitem18.Product_Code__c = 'P02200';
        insert lineitem18;
        
        Invoice_Line_Items__c lineitem19 = new Invoice_Line_Items__c();
        lineitem19.Invoice__c = invoice.Id;
        lineitem19.Product_Code__c = 'P01200';
        insert lineitem19;
        
        Invoice_Line_Items__c lineitem20 = new Invoice_Line_Items__c();
        lineitem20.Invoice__c = invoice.Id;
        lineitem20.Product_Code__c = 'P01201';
        insert lineitem20;
        
        Invoice_Line_Items__c lineitem21 = new Invoice_Line_Items__c();
        lineitem21.Invoice__c = invoice.Id;
        lineitem21.Product_Code__c = 'P02840';
        insert lineitem21;
        
        Invoice_Line_Items__c lineitem22 = new Invoice_Line_Items__c();
        lineitem22.Invoice__c = invoice.Id;
        lineitem22.Product_Code__c = 'P02650';
        insert lineitem22;
        
        Invoice_Line_Items__c lineitem23 = new Invoice_Line_Items__c();
        lineitem23.Invoice__c = invoice.Id;
        lineitem23.Product_Code__c = 'PP375';
        insert lineitem23;
        
        Invoice_Line_Items__c lineitem24 = new Invoice_Line_Items__c();
        lineitem24.Invoice__c = invoice.Id;
        lineitem24.Product_Code__c = 'P01422';
        insert lineitem24;
        
        Invoice_Line_Items__c lineitem25 = new Invoice_Line_Items__c();
        lineitem25.Invoice__c = invoice.Id;
        lineitem25.Product_Code__c = 'PP395';
        insert lineitem25;
        
        Invoice_Line_Items__c lineitem1 = new Invoice_Line_Items__c();
        lineitem1.Id = lineitem.Id;
        lineitem1.Product_Code__c = 'PP395';
        update lineitem1;
        
        Invoice_Line_Items__c lineitem26 = new Invoice_Line_Items__c();
        lineitem26.Id = lineitem2.Id;
        lineitem26.Product_Code__c = 'P01422';
        update lineitem26;
        
        Invoice_Line_Items__c lineitem27 = new Invoice_Line_Items__c();
        lineitem27.Id = lineitem3.Id;
        lineitem27.Product_Code__c = 'PP375';
        update lineitem27;
        
        Invoice_Line_Items__c lineitem28 = new Invoice_Line_Items__c();
        lineitem28.Id = lineitem4.Id;
        lineitem28.Product_Code__c = 'P02650';
        update lineitem28;
        
        Invoice_Line_Items__c lineitem29 = new Invoice_Line_Items__c();
        lineitem29.Id = lineitem5.Id;
        lineitem29.Product_Code__c = 'P02840';
        update lineitem29;
        
        Invoice_Line_Items__c lineitem30 = new Invoice_Line_Items__c();
        lineitem30.Id = lineitem6.Id;
        lineitem30.Product_Code__c = 'P01201';
        update lineitem30;
        
        Invoice_Line_Items__c lineitem31 = new Invoice_Line_Items__c();
        lineitem31.Id = lineitem7.Id;
        lineitem31.Product_Code__c = 'P01200';
        update lineitem31;
        
        Invoice_Line_Items__c lineitem32 = new Invoice_Line_Items__c();
        lineitem32.Id = lineitem8.Id;
        lineitem32.Product_Code__c = 'P02200';
        update lineitem32;
        
        Invoice_Line_Items__c lineitem33 = new Invoice_Line_Items__c();
        lineitem33.Id = lineitem9.Id;
        lineitem33.Product_Code__c = 'PP468';
        update lineitem33;
        
        Invoice_Line_Items__c lineitem34 = new Invoice_Line_Items__c();
        lineitem34.Id = lineitem10.Id;
        lineitem34.Product_Code__c = 'PP249';
        update lineitem34;
        
        Invoice_Line_Items__c lineitem35 = new Invoice_Line_Items__c();
        lineitem35.Id = lineitem11.Id;
        update lineitem35;
        
        Invoice_Line_Items__c lineitem36 = new Invoice_Line_Items__c();
        lineitem36.Id = lineitem12.Id;
        update lineitem36;
        
        Invoice_Line_Items__c lineitem37 = new Invoice_Line_Items__c();
        lineitem37.Id = lineitem13.Id;
        update lineitem37;
        
        Invoice_Line_Items__c lineitem38 = new Invoice_Line_Items__c();
        lineitem38.Id = lineitem14.Id;
        update lineitem38;
        
        Invoice_Line_Items__c lineitem39 = new Invoice_Line_Items__c();
        lineitem39.Id = lineitem15.Id;
        update lineitem39;
        
        Invoice_Line_Items__c lineitem40 = new Invoice_Line_Items__c();
        lineitem40.Id = lineitem16.Id;
        update lineitem40;
        
        Invoice_Line_Items__c lineitem41 = new Invoice_Line_Items__c();
        lineitem41.Id = lineitem17.Id;
        update lineitem41;
        
        Invoice_Line_Items__c lineitem42 = new Invoice_Line_Items__c();
        lineitem42.Id = lineitem18.Id;
        update lineitem42;
        
        Invoice_Line_Items__c lineitem43 = new Invoice_Line_Items__c();
        lineitem43.Id = lineitem19.Id;
        update lineitem43;
        
        Invoice_Line_Items__c lineitem44 = new Invoice_Line_Items__c();
        lineitem44.Id = lineitem20.Id;
        update lineitem44;
        
        Invoice_Line_Items__c lineitem45 = new Invoice_Line_Items__c();
        lineitem45.Id = lineitem21.Id;
        update lineitem45;
        
        
    }
}