/**
 * Class to run migration batch job 
 * Added in version  : 9.1.1
 * Used for versions : less than 9.1.1
 */
public with sharing class SQX_9_1_1_Post_Record_Migration {
    public static void startMigration(){
        Database.executeBatch(new SQX_9_1_1_CQ_Task_Question_Migration());
        Database.executeBatch(new SQX_9_1_1_Complaint_Migration());
        Database.executeBatch(new SQX_9_1_1_SF_Task_Migration());
    }
}