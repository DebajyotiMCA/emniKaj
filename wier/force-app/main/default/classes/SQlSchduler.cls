global class SQlSchduler implements Schedulable{
    global void execute(SchedulableContext sc) 
    {    
        System.debug('execute');
        SQLConnector.connect();
    } 
}