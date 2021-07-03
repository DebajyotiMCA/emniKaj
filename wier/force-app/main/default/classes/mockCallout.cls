global class mockCallout implements HttpCalloutMock
{
    global HttpResponse respond(HttpRequest request)
    {
        HttpResponse res = new HttpResponse();
        res.setBody( '{        "InvoiceDate": "20200616", "CustRef": "135232 ","AMCO": "0090047535","InvoiceNumber": "60085088","CustNo": "300066 ", "TotalInvoiceValue": "11189.16"    },');
        res.setStatusCode(200);
        return res;
    }   
}