public class Utility {
 
        //Member variables
        static User adminUserOne,adminUserTwo,adminUserThree;
        static List<User> users;
        static Id adminId;
        public static string suffix;
        public static string alias;
        
        /**************************************************************************************
        Purpose: Test method for testUserDataSetUp 
        Parameters: - 
        Returns: - 
        **************************************************************************************/ 
          
        public static List<User> testUserDataSetUp() {
            SetUniqueValues();
            List<user> UserCreated = new List<user>();

            // Getting the profile id
            Id sysAdminProfileId = [select Id from Profile where Name='System Administrator'].Id; 
            // create a test role
            UserRole adminAsstRole = new UserRole(Name='Business Admin'); 
            insert adminAsstRole;
            //creating user
            adminUserOne = new User(TimeZoneSidKey='America/Chicago',firstname='User', Username='Mike' + suffix + '@mike.com',Alias='K_'+alias,
            Email='testAdminone' + suffix + '@usaa.com',EmailEncodingKey='UTF-8',LastName='SA'+suffix,ProfileId=sysAdminProfileId,
            UserRoleId =adminAsstRole.Id,
            LanguageLocaleKey='en_US',LocaleSidKey='en_US',EmployeeNumber='123456789',Department='94444');
            //creating user 2
            adminUserTwo = new User(TimeZoneSidKey='America/Chicago',firstname='User', Username='shr' + suffix + '@shr.com',Alias='s_'+alias,
            Email='testAdmintwo' + suffix + '@usaa.com',EmailEncodingKey='UTF-8',LastName='AA'+suffix,ProfileId=sysAdminProfileId,
            UserRoleId =adminAsstRole.Id,
            LanguageLocaleKey='en_US',LocaleSidKey='en_US',EmployeeNumber='2345671',Department='94444');
            
            //Creating user3
            adminUserThree = new User(TimeZoneSidKey='America/Chicago',firstname='User', Username='john' + suffix + '@john.com',Alias='j_'+alias,
            Email='testAdminthree' + suffix + '@usaa.com',EmailEncodingKey='UTF-8',LastName='BA'+suffix,ProfileId=sysAdminProfileId,
            UserRoleId =adminAsstRole.Id,
            LanguageLocaleKey='en_US',LocaleSidKey='en_US',EmployeeNumber='198765432',Department='94444');


            UserCreated.add(adminUserOne);
            UserCreated.add(adminUserTwo);
            UserCreated.add(adminuserThree);
            insert userCreated;
            // Select users for the test.
            string l1= 'SA' + suffix;
            string l2= 'AA' + suffix;
            string l3='BA' +suffix;
            users = [SELECT Id,Name,EmployeeNumber FROM User WHERE IsActive = true and LastName in (:l1,:l2,:l3) order by 
            LastName desc LIMIT 3];         
            return users;


        } 
        
        /**************************************************************************************
        Purpose: Generate unique suffixes for UserName 
        Parameters: - 
        Returns: - 
        **************************************************************************************/    
        public static void SetUniqueValues() {
            DateTime dateAndTime = DateTime.now();
            string dateTest = string.valueof(dateAndTime.date());
            string hh = string.valueof(dateAndTime.hour());
            string mm = string.valueof(dateAndTime.minute());
            string ss = string.valueof(dateAndTime.second());
            string mil = string.valueof(dateAndTime.millisecond());
            suffix = dateTest + hh + mm + ss + mil;
            string tm = mm+ss+hh+mil;
            alias = tm.substring(0,3);
        }   
        
        
             
    
    }