@isTest
global class SQLConnectorForProductsTest2 {
    @isTest
    global static void testPublishToSlacks(){
        test.startTest();
        SQlSchdulerForProducts2 sh1 = new SQlSchdulerForProducts2();

		String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
        
        SQLConnectorForProducts.convertToDate('20200112');
        SQLConnectorForProducts.testconvert();
    }
}