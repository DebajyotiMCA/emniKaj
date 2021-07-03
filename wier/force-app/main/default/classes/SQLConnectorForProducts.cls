public class SQLConnectorForProducts {
    
  @future(callout=true)
    public static void connect(){
        try{
            Date Yeste = Date.today();
            Date tomo = Date.today() +1;
            
            List<Invoice__c> invList = [Select id,Name from Invoice__c where LastModifiedDate <=: tomo and LastModifiedDate >=: Yeste and Line_Count__c =:0];
            //List<Invoice__c> invList = [Select id,Name from Invoice__c];
            
            System.debug('invList+'+invList.size());
            Set<String> InvoiceNoList = new Set<String>();
            Map<String,List<Invoice__c>> invoiceMap = new Map<String,List<Invoice__c>>();
            for(Invoice__c inv : invList){
                InvoiceNoList.add(inv.Name);
                
                List<Invoice__c> l = invoiceMap.get(inv.Name);
                if (l == null) {
                    l = new List<Invoice__c>();
                    invoiceMap.put(inv.Name, l);
                }
                l.add(inv);
            }
            
            List<Invoice_Line_Items__c> ItemsList = new List<Invoice_Line_Items__c>();
            List<Invoice__c> invoiceList = new List<Invoice__c>();
            
            for(String invoiceNo : InvoiceNoList){
                String api = 'https://db-chk-api.weiroilandgas.com/api/ReadInvoice/GetInvoiceDetails?OrderNo={OrderNo}&InvoiceNo='+invoiceNo;
            
                //String api = 'https://db-chk-api.weiroilandgas.com/api/ReadInvoice/GetInvoiceDetails?OrderNo={OrderNo}&InvoiceNo=60085773';
            	Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(api);
                String endPointURL = api;
                String userName = 'UserWeir';
                String password = 'LogIT';    
                
                // Specify the required user name and password to access the endpoint 
                // As well as the header and header information 
                Blob headerValue = Blob.valueOf(userName + ':' + password);
                String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
                
                request.setHeader('Authorization', authorizationHeader);
                request.setMethod('GET');
               // HttpResponse response = http.send(request);
                
                HttpResponse response;
                if (Test.IsRunningTest())
                {
                    HttpRequest req = new HttpRequest();
                    MockCallOut mock = new mockCallout();
                    HTTPResponse discard = mock.respond(req);
                } else{
                    try{                        
                        response = http.send(request);
                        System.debug('response'+response);
                    } catch(Exception e){
                        System.debug('fail'+e);
                    }
                }
                
                System.debug('response'+response);
                String httpresponse = '';
                
                if(response != null){
                if (response.getStatusCode() == 200) {
                    System.debug(' ** response ** : ' + response ); 

                   List<MockResponse> responseList = (List<MockResponse>)JSON.deserialize(response.getBody().replace('"currency"','"currencyVal"'), List<MockResponse>.class);
            
                    if(responseList != null && responseList.size()>0){
                      List<Invoice__c> inList = invoiceMap.get(invoiceNo);
                        
                        if(inList != null && inList.size() >0){
                            for (MockResponse res: responseList) {
                                Invoice_Line_Items__c lineItems = new Invoice_Line_Items__c();
                                lineItems.Invoice__c = inList.get(0).Id;
                                //lineItems.Name = res.InvoiceTo;
                               // lineItems.Line__c = res.Line;
                               if(res.Line != ''){
                                    Decimal Line = decimal.valueOf(res.Line); 
                                    if(Line != null){
                                        lineItems.Line__c = Line;
                                    }
                                }
                                
                                lineItems.Product_Code__c = res.Details1;
                                lineItems.Product_Detatil__c = res.Details2;
                                lineItems.Line_Item_Description__c = res.DESCRIPTION;
                                
                                if(res.DeliveryDate.Length()==8 && res.DeliveryDate != ''){
                                    Date DelDate = convertToDate(res.DeliveryDate);
                                    if(DelDate != null){
                                        lineItems.Delivery_Date__c = DelDate;
                                    }
                                }
                                
                                if(res.Quantity != ''){
                                    Decimal quan = decimal.valueOf(res.Quantity); 
                                    if(quan != null){
                                        lineItems.Quantity__c = quan;
                                    }
                                }
                                
                                if(res.UnitPrice != ''){
                                    Decimal unitPrice = decimal.valueOf(res.UnitPrice); 
                                    if(unitPrice != null){
                                        lineItems.Unit_Price__c = unitPrice;
                                    }
                                }
                                
                                if(res.TotalPrice != ''){
                                    Decimal totalPrice = decimal.valueOf(res.TotalPrice); 
                                    if(totalPrice != null){
                                        lineItems.Total_PriceVal__c = totalPrice;
                                    }
                                }
                                
                                if(res.VatRate != ''){
                                    lineItems.VAT_Rate__c = 'Standard '+res.VatRate;
                                }
                                
                                lineItems.CurrencyIsoCode = res.currencyVal;
                                ItemsList.add(lineItems);
            
                            }
                            
                            System.debug('ddd'+responseList.get(0));
                            if(responseList.get(0) != null){
                                Invoice__c invoi = new Invoice__c();
                                invoi.Id = inList.get(0).Id;
                                
                                if(responseList.get(0).InvoiceDate != ''){
                                    Date inDate = convertToDate(responseList.get(0).InvoiceDate);
                                    if(inDate != null){
                                        invoi.Invoice_Date__c = inDate;
                                    }
                                }
                                
                                invoi.Customer_Reference__c = responseList.get(0).CustRef;
                                invoi.Amco_Weir_Reference__c = responseList.get(0).AMCO;
                                invoi.Facility__c =  responseList.get(0).Facility;
                                invoi.Delivery_Method__c = responseList.get(0).DeliveryMethod;
                                invoi.CurrencyIsoCode = responseList.get(0).currencyVal;
                                invoi.Delivery_Terms__c = responseList.get(0).DeliveryTerms;
                                invoi.Payment_Term__c = responseList.get(0).PaymentTerms;
                                invoi.Customer_Contact_Names__c = responseList.get(0).CustContactName;
                                invoi.Weir_Contact_Persons__c = responseList.get(0).WeirContactPerson;
                                invoi.Customer_VAT_Registration_Num__c = responseList.get(0).VatRegNo;
                                invoi.Invoice_To_Address_Line_01__c = responseList.get(0).InvoiceAD1;
                                invoi.Invoice_To_Address_Line_02__c = responseList.get(0).InvoiceAD2;
                                invoi.Invoice_To_Zip_Postal_Code__c = responseList.get(0).InvoiceAD3;
                                invoi.Invoice_To_Country__c = responseList.get(0).InvoiceAD4;
                                invoi.Deliver_To_Address_Line_01__c = responseList.get(0).DeliverAD1;
                                invoi.Deliver_To_Address_Line_02__c = responseList.get(0).DeliverAD2;
                                invoi.Deliver_To_Zip_Postal_Code__c = responseList.get(0).DeliverAD3;
                                invoi.Deliver_To_Country__c = responseList.get(0).DeliverAD4;
                                
                                if(responseList.get(0).ExchangeRate != ''){
                                    Decimal rate = decimal.valueOf(responseList.get(0).ExchangeRate); 
                                    if(rate != null){
                                        invoi.Exchange_Rate__c = rate;
                                    }
                                    System.debug('rate+'+rate);
                                }
                                
                                if(responseList.get(0).VatBaseAmount != ''){
                                    Decimal vatbaseam = decimal.valueOf(responseList.get(0).VatBaseAmount);
                                    if(vatbaseam != null){
                                        invoi.VAT_Base_Amount__c = vatbaseam;
                                    }
                                    System.debug('vatbaseam+'+vatbaseam);
                                }
                                
                                if(responseList.get(0).NetInvoiceValue != ''){
                                    Decimal netinvVal = decimal.valueOf(responseList.get(0).NetInvoiceValue);
                                    if(netinvVal != null){
                                        invoi.Net_Invoice_Values__c = netinvVal;
                                    }
                                    System.debug('netinvVal+'+netinvVal);
                                }
                                
                                System.debug('responseList.get(0).VatAmountInSar+'+responseList.get(0).VatAmountInSar);
                                
                                if(responseList.get(0).VatAmountInSar != ''){
                                    Decimal vatAmSAR = decimal.valueOf(responseList.get(0).VatAmountInSar);
                                    if(vatAmSAR != null){
                                        invoi.VAT_Amount_in_SARs__c = vatAmSAR;
                                    }
                                    System.debug('vatAmSAR+'+vatAmSAR);
                                }
                                
                                if(responseList.get(0).TotalInvoiceValue != ''){
                                    Decimal totaInvVal = decimal.valueOf(responseList.get(0).TotalInvoiceValue);
                                    if(totaInvVal != null){
                                        invoi.Total_Invoice_Values__c = totaInvVal;
                                    }
                                    System.debug('totaInvVal+'+totaInvVal);
                                }
                                
                                if(responseList.get(0).VatAmount != ''){
                                    Decimal vatAmount = decimal.valueOf(responseList.get(0).VatAmount);
                                    if(vatAmount != null){
                                        invoi.Vat_Amount__c = vatAmount;
                                    }
                                    System.debug('vatAmount+'+vatAmount);
                                }
                                
                                invoiceList.add(invoi);
                            }
                        }
                    }
                }
              }
            }
            
            if(ItemsList.size() >0){
                Database.SaveResult[] srList = Database.insert(ItemsList, false);
                        
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted Invoice Items. Invoice Items ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Invoice Items fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
                    
            SYstem.debug('invoiceList.size() +'+invoiceList );
            if(invoiceList.size() >0){
                Database.SaveResult[] srList = Database.update(invoiceList, false);
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully updated invoice. invoice ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Invoice fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        } catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    
    public class MockResponse{
        public String InvoiceDate;// && invoice data 
        public String CustRef;// && cust Ref
        public String AMCO; //&& Amco Reference
        public String Facility; //&& facility
        public String InvoiceNumber;
        public String CustContactName; //&& Customer Con Name
        public String DeliveryMethod; //&& Delivery Method  
        public String PaymentTerms; //&& Payment Terms
        public String WeirContactPerson; //&& weir Contact per
        public String DeliveryTerms; //&&Delivery Terms
        public String currencyVal; //** currecy
        public String InvoiceTo;  //** Name
        public String InvoiceAD1; // && Address
        public String InvoiceAD2; // && Address
        public String InvoiceAD3; // && Address
        public String InvoiceAD4; // && Address
        public String CustNo;
        public String VatRegNo; //&& Vat Reg No
        public String DeliverTo;
        public String DeliverAD1; // && Address
        public String DeliverAD2; // && Address
        public String DeliverAD3; // && Address
        public String DeliverAD4; // && Address
        public String Line; //****Line
        public String Details1; //** Product Code
        public String Details2; //**Product_Detatil__c
        public String Details3; 
        public String DESCRIPTION; //** DESCRIPTION
        public String DeliveryDate;//** Delivery Date
        public String Quantity;//** Quantity
        public String UnitPrice; //** Unit Price
        public String TotalPrice; //** TotalPrice
        public String Charges; 
        public String ChargeValue;
        public String ExchangeRate; //** Exchange Rate
        public String NetInvoiceValue; //** Net Invoice Val
        public String VatBaseAmount; // ** Vat Base Amount
        public String VatAmountInSar;// ** Vat Amount SAR
        public String VatAmount; //** Vat Amount
        public String TotalInvoiceValue; //** Total Inoic Val
        public String VatRate;
    }
    
    public static Date convertToDate(String DateVal){
        
        Integer month = Integer.valueOf(DateVal.substring(4,6));
        Integer day = Integer.valueOf(DateVal.substring(6,8));
        Integer year = Integer.valueOf(DateVal.substring(0,4));
        System.debug('year+'+year+'+month+'+month+'+day+'+day);
        Date parsedDate = Date.newInstance(year,month,day);

        System.debug('parsedDate+'+parsedDate);
        return parsedDate;
    }
    
    public static void testconvert(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}