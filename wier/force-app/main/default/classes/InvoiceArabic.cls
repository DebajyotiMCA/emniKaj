public class InvoiceArabic {
    public Id invoiceid {get;set;}
    public List<Invoice_Line_Items__c> lstCEERLines {get;set;}
    public List<Invoice_Line_Items__c> newlstCEERLines {get;set;}
    public String imageURL{get;set;}
    public String imageDeliverToURL{get;set;}
    public String imgge{get;set;}
    public boolean flag{get;set;}
    
	public InvoiceArabic(ApexPages.StandardController controller){
        //get record id
        invoiceid = controller.getId();
        
        List<Invoice__c> invoiceList = [Select id,Customer__c from Invoice__c where id =:invoiceid];
    
    	//imageURL='/servlet/servlet.FileDownload?file=00P1l0000033IO4';
    	//        imageDeliverToURL='/servlet/servlet.FileDownload?file=00P1l0000033IMX';
    	
    	imageURL='/servlet/servlet.FileDownload?file=';
        imageDeliverToURL='/servlet/servlet.FileDownload?file=';
        
    	List< Attachment  > documentList=[select Id,name from Attachment where
                                    Name='InvoiceTo.PNG' AND ParentId =: invoiceList.get(0).Customer__c LIMIT 1];
 		List< Attachment  > documentList1=[select Id,name from Attachment where
                                    Name='DeliverTo.PNG' AND ParentId =: invoiceList.get(0).Customer__c LIMIT 1];
            
        List<Document> docList = [SELECT Name,id FROM Document WHERE Name = 'Blank'];
        
    	if(documentList.size()>0){
      		imageURL=imageURL+documentList[0].id;
        } else{
            imageURL=imageURL+docList[0].id;
        }
        
        if(documentList1.size()>0){
      		imageDeliverToURL=imageDeliverToURL+documentList1[0].id;
            
        } else{
           imageDeliverToURL=imageDeliverToURL+docList[0].id;
        }
        
 	}
    
    public void getItems(){
        
        lstCEERLines = [Select name,Product_Detatil__c,Level_2_Link__c,Level_3_Link__c,Level_4_Link__c,Level_5_Link__c,
                        Level_6_Link__c,Level_7_Link__c,Level_8_Link__c,Level_9_Link__c,Level_10_Link__c,Level_11_Link__c,
                        Level_12_Link__c,Level_13_Link__c,Level_14_Link__c,Level_15_Link__c,Level_16_Link__c,Level_17_Link__c,
                        Level_18_Link__c,Level_19_Link__c,Level_20_Link__c,Level_21_Link__c,Level_22_Link__c,Level_23_Link__c,
                        Product_Code__c,Arabic_ID__c,Product_Detail_Arabic__c,Delivery_Date__c,VAT_Rate__c,Line__c,Line_Item_Description__c,
                        Quantity__c,Unit_Price__c,Total_Price__c from Invoice_Line_Items__c where Invoice__c=:invoiceid Order By Line__c];
        for(Invoice_Line_Items__c inv : lstCEERLines){
            //imgge = 
        }
    }
}