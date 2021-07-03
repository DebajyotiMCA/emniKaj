global class SQlSchdulerForProducts2 implements Schedulable{
    
    global void execute(SchedulableContext sc) 
    {    
        System.debug('test');
  		SQLConnectorForProducts.connect();
    }    
    
   
}