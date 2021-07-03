@isTest
Public Class Utility_TestClass
{
    Static testMethod void mainMethod() {
        Utility.testUserDataSetUp();
        List<User> users = [SELECT Id,Name,EmployeeNumber,Department FROM User WHERE IsActive = true];   
        System.assertEquals(true,users.size()>=1);

    }
}