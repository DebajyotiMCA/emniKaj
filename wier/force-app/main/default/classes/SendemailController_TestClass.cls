@istest
private class SendemailController_TestClass{
 static testMethod void myUnitTest() 
    {
      
    SendemailController sendEmail = new SendemailController();
    List<Task> listTask = new List<Task>();
    Task task = new Task();
    task.ActivityDate = Date.today().addDays(7);
    task.Subject='Sample Task';
    task.OwnerId = UserInfo.getUserId();
    task.Status='In Progress';
    task.Assigned_To_CRM_User__c = 'ali@aphidas.com';
    listTask.add(task);
    insert listTask;
    sendEmail.sendEmailFunction(listTask);
    
    }
  
    }