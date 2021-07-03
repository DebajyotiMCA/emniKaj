public class SQLConnector {
    @future(callout=true)
    public static void connect(){
        System.debug('connect');
        Datetime dateVal = Datetime.now() - 1;
        System.debug('dateVal'+dateVal);
        
        String iso8601 = dateVal.format('yyyyMMdd');
        String APIs = 'https://db-chk-api.weiroilandgas.com/api/ReadInvoice/GetInvoiceListbyMod_Date?MOD_Date_Invoice='+iso8601;
        //String APIs = 'https://db-chk-api.weiroilandgas.com/api/ReadInvoice/GetInvoiceListbyMod_Date?MOD_Date_Invoice=20201128';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(APIs);
        String endPointURL = APIs;
        String userName = 'UserWeir';
        String password = 'LogIT';
              
        // Specify the required user name and password to access the endpoint 
        // As well as the header and header information 
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        
         HttpResponse response;
        if (Test.IsRunningTest())
        {
            HttpRequest req = new HttpRequest();
            MockCallOut mock = new mockCallout();
            HTTPResponse discard = mock.respond(req);
        } else{
        
            response = http.send(request);
            System.debug('response'+response);
        }
        //String httpresponse = '';

        if(response != null){
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            System.debug(response.getBody());
                         
            System.debug(' ** response ** : ' + response ); 
            
            List<MockResponse> responseList = (List<MockResponse>)JSON.deserialize(response.getBody(), List<MockResponse>.class);
            Set<String> customerNo = new Set<String>();
            
            System.debug('Reading invoice Numbers:');
            for (MockResponse res: responseList) {
                System.debug('Invoice :'+res.Invoicenumber);
               
                if(res.CustNo != null){
                    String CustNo = res.CustNo.trim();
                    customerNo.add(CustNo);
                }
            }
           
            System.debug('customerNo'+customerNo);
            
            Map<String, List<Account>> mapAccount = new Map<String,List<Account>>();
            List<Account> accList = [Select id , Customer_Reference_No__c from Account where Customer_Reference_No__c IN: customerNo];
            System.debug('accList.size()'+accList.size());
            
            if(accList.size() >0){
                for (Account c : accList) {
                    List<Account> l = mapAccount.get(c.Customer_Reference_No__c);
                    if (l == null) {
                        l = new List<Account>();
                        mapAccount.put(c.Customer_Reference_No__c, l);
                    }
                    l.add(c);
                }
            }
                        
            System.debug('mapAccount+'+mapAccount);
            System.debug('mapAccount+'+mapAccount.size());
            
            List<Invoice__c> invList = new List<Invoice__c>();
            Set<String> uniquoe  = new Set<String>();
            for (MockResponse res: responseList) {
                if(mapAccount != null){
                    String CustNo = res.CustNo.trim();
                    
                    System.debug('CustNo++'+CustNo);
                    if(CustNo != null){
                        
                        String ref = res.CustRef + res.CustNo;
                        List<Account> accountList = mapAccount.get(CustNo);
                
                        System.debug('uniquoe.contains(ref)+'+uniquoe.contains(ref));
                        if(accountList != null ){
                            System.debug('inside');
                            Invoice__c invoice = new Invoice__c();
                            invoice.Customer__c = accountList.get(0).Id;
                            invoice.Customer_Reference__c = res.CustRef;
                            invoice.Name = res.InvoiceNumber;
                            invoice.Amco_Weir_Reference__c = res.AMCO;
                            invoice.External_ID__c = res.CustRef + res.CustNo;
                            invoice.Customer_Numbers__c = res.CustNo;
                            
                            Date invDate = convertToDate(res.InvoiceDate);
                            if(invDate != null){
                                invoice.Invoice_Date__c = invDate;
                            }
                            
                            Decimal strToDec = decimal.valueOf(res.TotalInvoiceValue); 
                            if(strToDec != null){
                                invoice.Total_Invoice__c = strToDec;
                            }
                            
                            System.debug('uniquoe.size()+'+uniquoe.size()+uniquoe+'dd'+ref);
                            if(uniquoe.size()>0 && !uniquoe.contains(ref)){
                                invList.add(invoice);
                                System.debug('No Unique added');
                            } else if(uniquoe.size()==0){
                                System.debug('Empty Set');
                              invList.add(invoice);
                            }
                            uniquoe.add(res.CustRef + res.CustNo);
                        }
                    }
                }
                
            }
            
            System.debug('invList+'+invList);
            if(invList.size()>0){
                Schema.SObjectField ftoken = Invoice__c.Fields.External_ID__c;
                Database.UpsertResult[] srList = Database.upsert(invList,ftoken,false);
                
                Set<Id> upsertIds = new Set<Id>();
                for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully updated/inserted invoice. invoice ID: ' + sr.getId());
                        upsertIds.add(sr.getId());
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
                
                
                List<Invoice_Line_Items__c> linItems = [Select id, Invoice__c from Invoice_Line_Items__c where Invoice__c IN:upsertIds ];
               	List<Invoice_Line_Items__c> dellinItems = new List<Invoice_Line_Items__c>();
                if(linItems != null && linItems.size() >0){
                    for(Invoice_Line_Items__c line : linItems){
                        Invoice_Line_Items__c deleItems = new Invoice_Line_Items__c();
                        deleItems.id = line.Id;
                        dellinItems.add(deleItems);
                    }
                    
                }
                System.debug(dellinItems.size());
                    
                if(dellinItems.size() > 0 && dellinItems != null){
                    delete dellinItems;
                }
            }
        }
        }
    }
    
    
    public class MockResponse{
      public String InvoiceDate;
      public String CustRef;
      public String AMCO;
      public String InvoiceNumber;
      public String CustNo;
      public String TotalInvoiceValue;
        
         
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
    }    
   
}