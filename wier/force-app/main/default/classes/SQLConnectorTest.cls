@isTest(seeAllData=true)
global class SQLConnectorTest {
	@isTest
    global static void testPublishToSlack(){
        test.startTest();
        SQlSchduler sh1 = new SQlSchduler();

		String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
        
        SQLConnector.convertToDate('20200112');
        SQLConnector.testconvert();
    }
}