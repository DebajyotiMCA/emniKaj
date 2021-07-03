public class SupplierAccountListController {
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    Public Integer index{get;set;} 
    public map<Id,List<Contact>> accIdToContacts{get;set;}
    public SupplierAccountListController(){
        accIdToContacts = new map<Id,List<Contact>>();
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        paginationSizeOptions.add(new SelectOption('200','200'));
    }
    
    public ApexPages.StandardSetController ssc {
        get {
            if(ssc == null) {
                ssc = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name, AccountNumber ,
                     BillingStreet, BillingCity, BillingState, BillingCountry,
                     (SELECT Id,Email,Phone,FirstName,LastName 
                      FROM Contacts),
                     (SELECT Id, Sub_Category__c ,Commodity_Menu__c,Broad_Scope__c ,Commodity_Details__c  
                      FROM compliancequest__New_Suppliers_Introduction__r)
                     FROM Account]));
                
            }
            List<ListView> listViewData =[SELECT Id FROM ListView WHERE DeveloperName='BATAM_ACTIVE_SUPPLIER_ACCOUNTS' AND SobjectType ='Account'];
            if(listViewData <> null && listViewData.size() > 0){
                ssc.setFilterId(listViewData[0].Id);
            }
            ssc.setPageSize(size);  
            noOfRecords = ssc.getResultSize();
            return ssc;
        }
        set;
    }
    
    public List<Account> getAccounts() 
    {
        List<Account> data = new List<Account>();
        for(Account acc:(List<Account>)ssc.getRecords()){
            accIdToContacts.put(acc.Id,new List<Contact>());
            if(acc.Contacts <> null && acc.Contacts.size() >0 ){
                Set<string> contactNames = new Set<String>();
                for(Contact con:acc.Contacts){
                    if(!contactNames.contains(con.FirstName + con.LastName)){
                        accIdToContacts.get(acc.Id).add(con);
                        contactNames.add(con.FirstName + con.LastName);
                    }
                }
            }
        }
        return (List<Account>)ssc.getRecords();
    }
    public PageReference refreshPageSize() {
        ssc.setPageSize(size);
        return null;
    }
}