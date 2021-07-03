@isTest
public class SupplierAccountListControllerTest {

    public static testMethod void test1(){
        INSERT new Account(Name='Sample');
        SupplierAccountListController a = new SupplierAccountListController();
        Test.setCurrentPage(Page.SupplierAccountList);
        ApexPages.StandardSetController stdSetController = a.ssc;
        List<Account> acc = a.getAccounts();
        PageReference p = a.refreshPageSize();
    }
}