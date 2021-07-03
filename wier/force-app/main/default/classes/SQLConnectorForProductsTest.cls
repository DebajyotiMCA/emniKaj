@isTest(seeAllData=true)
global class SQLConnectorForProductsTest {
	@isTest
    global static void testPublishToSlack(){
        test.startTest();
        SQlSchdulerForProducts sh1 = new SQlSchdulerForProducts();

		String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
        
        SQLConnectorForProducts.convertToDate('20200112');
        SQLConnectorForProducts.testconvert();
    }
}