public class dashboardExt {
    
    public map<string,string> filtermap{set;get;}
    public map<string,list<object>> listofObject {set;get;}
    public dashboardExt(ApexPages.StandardController controller) {
        string Accid = apexpages.currentpage().getparameters().get('id') ;
       // list<report_filter__mdt> reportfilterlist = [select filter_string__c,Report_ID__c from report_filter__mdt];
        filtermap = new map<string,string>();
        for(report_filter__mdt rf : [select filter_string__c,Report_ID__c from report_filter__mdt]){
            string filterstring = rf.filter_string__c;
            filterstring = filterstring.replace('AccId',Accid);
            filtermap.put(rf.Report_ID__c,filterstring);
        }
        //list<Object_With_Query__mdt> objectlist = [select name,Query_String__c from Object_With_Query__mdt];
        listofObject = new map<string,list<object>>();
        for(Object_With_Query__mdt oq: [select MasterLabel,Query_String__c from Object_With_Query__mdt]){
            listofObject.put(oq.MasterLabel, new list<object>());
            listofObject.get(oq.MasterLabel).addall(database.query(oq.Query_String__c));

        }
        
    }

}