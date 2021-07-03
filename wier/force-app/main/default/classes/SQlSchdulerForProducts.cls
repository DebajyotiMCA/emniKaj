global class SQlSchdulerForProducts implements Schedulable{
    
    global void execute(SchedulableContext sc) 
    {    
        System.debug('test');
  		SQLConnectorForProducts.connect();
    }    
    
   
}