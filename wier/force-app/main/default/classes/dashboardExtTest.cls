@isTest 
private class dashboardExtTest{
    static testMethod void testConstructure() {
        account acc = new account(name='TEst');
        insert acc;
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController accs = new ApexPages.StandardController(acc);
        dashboardExt dx = new dashboardExt(accs);
    }
}