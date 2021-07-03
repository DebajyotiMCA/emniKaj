public class ParetoChartClass {
    
    Public String JsonStr{get;set;}
    
    public ParetoChartClass()
    {
        prepareData();
    }
    
    private string prepareData()
    {		
        List<compliancequest__SQX_Nonconformance__c	> NCList = [Select id,Name,compliancequest__Type__c,Weir_Defect_Category__c	 from compliancequest__SQX_Nonconformance__c
                                                                where Weir_Defect_Category__c	!= null	];
        System.debug('NC List ' +NCList);
        Integer intCount = 0;
        Integer iv = 0;
        List<Nonconformance> nncList = new List<Nonconformance>();
        AggregateResult[] groupedResults  = [SELECT count(Id) iv,Weir_Defect_Category__c
                                             FROM compliancequest__SQX_Nonconformance__c
                                             GROUP BY Weir_Defect_Category__c];
        system.debug('tes:'+groupedResults);
        for (AggregateResult ar : groupedResults)  {
            System.debug('defect category name' + ar.get('Weir_Defect_Category__c'));
            System.debug('Sum count' + ar.get('iv'));
            Nonconformance nnc = new Nonconformance();
            nnc.x = String.valueof(ar.get('Weir_Defect_Category__c'));
            nnc.y = Integer.valueOf(ar.get('iv'));
            nncList.add(nnc);
        }
        //List<Nonconformance> nncList = new List<Nonconformance>();
        
        JsonStr = JSON.serialize(nncList);
        return JsonStr;
    }
   public class Nonconformance
    {
        public string x{get;set;}
        public Integer y{get;set;}
        //public string nammee{get;set;}
    }
}