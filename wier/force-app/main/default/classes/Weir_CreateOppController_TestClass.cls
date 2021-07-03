@isTest
private class Weir_CreateOppController_TestClass
{
    
    static testMethod void WRCreateOppContr() 
    {   
        test.startTest();
        List<RFQ__c> rfq = new List<RFQ__c>();
        //User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        //LocaleSidKey='en_US', Role = 'Customer Service Representative', 
        //TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        //UserRole p = [SELECT Id FROM UserRole WHERE Name='Customer Service Representative']; 
        Profile prof = [Select id from Profile where  Name ='CSR'];
        User u = new User(Alias = 'sampath', Email='standarduser@testorg.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', 
        TimeZoneSidKey='America/Los_Angeles', UserName='sampath@testorg.com');
        
        //UserRoleId = p.Id, ProfileId = prof.id, 
        
        
        //System.runAs(u) {
        Account acc = new Account(Name='TestingAccount');
        acc.Customer_Service_Representative__c = u.id;
        //insert acc;
        
          COpportunity__c oppty = new COpportunity__c();
            //oppty.Win_Probability__c = 90;
            oppty.OwnerId = acc.Customer_Service_Representative__c;
            oppty.Quotation_submittal_date__c = System.today();
            //insert oppty;
            List<RFQ__c> listRfq = new List<RFQ__c>();
        for(integer i=0; i<200; i++) {
            listRfq.add( new RFQ__c(Send_an_Acknowledgement__c = false,Opportunity__c =oppty.id,  Customer_Acknowledgement_Name__c='alikhan',Customer_s_reference_in_RFQ__c = 'Testing', Date_on_Enquiry__c=Date.today()) );
        }
        System.debug('listrfq####' + listRfq);
        //insert listRfq;
        
        Weir_CreateOppController  Oppcon = new Weir_CreateOppController ();
        Weir_CreateOppController.CreateOpportunity(rfq); 
        
        test.stopTest();
       // }
        
       /* Test.startTest();
        
        User u=new User();
        //insert u;
        
        Account acc=new Account();
        acc.Name='Test889';
        insert acc;
        
        List<RFQ__c> rfq=new List<RFQ__c>();
        RFQ__c rf =new RFQ__c();
       
        rf.Received_From__c='Test363';
        rf.Date_on_Enquiry__c=System.today();
        rf.Time_of_Email_Receipt__c=System.today();
        rf.Account__c=acc.Id;
        rf.Email_Content__c='Test34';
        rf.Path__c='TextArea';
        rf.Tendering_Manager__c=u.Id;
        rf.Support_Engineer_Email__c='Test@gm.com';
        rf.Customer_Acknowledgement_Name__c='Test778';
        rf.Customer_Email__c='Test@gn.com';
        rfq.add(rf);    
        
        //insert rf;
        
        
        
        COpportunity__c op=new COpportunity__c();
        Datetime t=System.today();
        op.Status__c='Initial Review';
        op.Status__c='PO received';
        op.Customer__c=rf.Account__c;
        op.OwnerId=acc.Customer_Service_Representative__c;
        op.Opportunity_Name__c='Test'+''+t;
        op.Tendering_Manager__c=rf.Tendering_Manager__c;
        op.Path__c=rf.Path__c;
        op.Customer_Support_Engineer_Email__c=rf.Support_Engineer_Email__c;
        op.Ref_if_any_in_customer_communication__c=rf.Customer_s_reference_in_RFQ__c;
        op.Contents_of_customer_communication__c=rf.Email_Content__c;
        op.RecordTypeId=rf.RecordTypeId;
        //update op;
        
        CostSheet__c cs=new CostSheet__c();
        cs.COpportunity__c=op.Id;
        //insert cs;
        
        
        Quotation__c qo=new Quotation__c();
        qo.COpportunity__c=op.Id;
        qo.CostSheet__c=cs.Id;
        //insert qo;*/
        
        
       /* Check_List__c ch=new Check_List__c(Name='Is a kick-off tendering meeting required',Opportunity__c=op.id,S_No__c=1);
         Check_List__c  ch1= new Check_List__c(Name='Do we have complete clarity on Tender Requirements and Job Scope',Opportunity__c=op.id,S_No__c=2);
          Check_List__c  ch2= new Check_List__c(Name='Is the job scope within the approved business scope mandate',Opportunity__c=op.id,S_No__c=3);
          Check_List__c  ch3= new Check_List__c(Name='Is there any registration / pre-qualification requirement for us',Opportunity__c=op.id,S_No__c=4);
          Check_List__c  ch4= new Check_List__c(Name='Country Embargoes-Is the customer/job destination subject to any restrictions',Opportunity__c=op.id,S_No__c=5);
          Check_List__c  ch5= new Check_List__c(Name='Terms and Conditions reviewed and lawyers comments obtained as required',Opportunity__c=op.id,S_No__c=6);
          Check_List__c  ch6= new Check_List__c(Name='Bond Requirement - reviewed and costed',Opportunity__c=op.id,S_No__c=7);
          Check_List__c  ch7= new Check_List__c(Name='Duties and taxes - reviewed and costed',Opportunity__c=op.id,S_No__c=8);
          Check_List__c  ch8= new Check_List__c(Name='Insurance - reviewed and costed',Opportunity__c=op.id,S_No__c=9);
          Check_List__c  ch9= new Check_List__c(Name='Commercial Review - warranty',Opportunity__c=op.id,S_No__c=10);
          Check_List__c  ch10= new Check_List__c(Name='Commercial Review - LD',Opportunity__c=op.id,S_No__c=11);
          Check_List__c  ch11= new Check_List__c(Name='Commercial Review - Limit of liability',Opportunity__c=op.id,S_No__c=12);
          Check_List__c  ch12= new Check_List__c(Name='Logistics costs',Opportunity__c=op.id,S_No__c=13);
          Check_List__c  ch13= new Check_List__c(Name='Storage costs',Opportunity__c=op.id,S_No__c=14);
          Check_List__c  ch14= new Check_List__c(Name='Agents commission or royalty fees or licensing costs',Opportunity__c=op.id,S_No__c=15);
          Check_List__c  ch15= new Check_List__c(Name='3rd Party Testing (such as DNV, CE, API and so forth)',Opportunity__c=op.id,S_No__c=16);
          Check_List__c  ch16= new Check_List__c(Name='QA/QC/HSE documents  - certification - attestation',Opportunity__c=op.id,S_No__c=17);
          Check_List__c  ch17= new Check_List__c(Name='Mobilisation and demobilisation costs',Opportunity__c=op.id,S_No__c=18);
          Check_List__c  ch18= new Check_List__c(Name='Field Service costs or costs from operational constraint at customer site',Opportunity__c=op.id,S_No__c=19);
          Check_List__c  ch19= new Check_List__c(Name='Inflation factored in the costs for extended bid validity',Opportunity__c=op.id,S_No__c=20);
          Check_List__c  ch20= new Check_List__c(Name='Comparison of costing for similar bids in the past ',Opportunity__c=op.id,S_No__c=21);
          Check_List__c  ch21= new Check_List__c(Name='Is delivery lead time backed up by supplier quotes ',Opportunity__c=op.id,S_No__c=22);
          Check_List__c  ch22= new Check_List__c(Name='Is delivery lead time backed up by Procurement',Opportunity__c=op.id,S_No__c=23);
          Check_List__c  ch23= new Check_List__c(Name='Is costing backed up by supplier quotes ',Opportunity__c=op.id,S_No__c=24);
          Check_List__c  ch24= new Check_List__c(Name='Is job delivery date backed up by Planning ',Opportunity__c=op.id,S_No__c=25);
          Check_List__c  ch25= new Check_List__c(Name='If the nature of job requires an advance payment from the customer',Opportunity__c=op.id,S_No__c=26);
          Check_List__c  ch26= new Check_List__c(Name='Project Risk Assessment',Opportunity__c=op.id,S_No__c=27);
          Check_List__c  ch27= new Check_List__c(Name='Project Tender Document - for bid value exceeding GBP 3 million',Opportunity__c=op.id,S_No__c=28);
          Check_List__c  ch28= new Check_List__c(Name='Pre-tender approval sheet - for bid value exceeding GBP 8 million',Opportunity__c=op.id,S_No__c=29);
          Check_List__c  ch29= new Check_List__c(Name='Tendering Milestone Plan compiled',Opportunity__c=op.id,S_No__c=30);*/
       /* insert ch;
        insert ch1;
        insert ch2;
        insert ch3;
        insert ch4;
        insert ch5;
        insert ch6;
        insert ch7;
        insert ch8;
        insert ch9;
        insert ch10;
        insert ch11;
        insert ch12;
        insert ch13;
        insert ch14;
        insert ch15;
        insert ch16;
        insert ch17;
        insert ch18;
        insert ch19;
        insert ch20;
        insert ch21;
        insert ch22;
        insert ch23;
        insert ch24;
        insert ch25;
        insert ch26;
        insert ch28;
        insert ch29;*/
        
       /*Contract_Checklst__c conch=new Contract_Checklst__c(Name='Quantity',Opportunity__c=op.id,S_No__c=1);
       Contract_CheckList__c  conch1= new Contract_CheckList__c(Name='Prices ',Opportunity__c=op.id,S_No__c=2);
       Contract_CheckList__c  conch2= new Contract_CheckList__c(Name='Delivery terms and destination',Opportunity__c=op.id,S_No__c=3);
       Contract_CheckList__c  conch3= new Contract_CheckList__c(Name='Delivery Date',Opportunity__c=op.id,S_No__c=4);
       Contract_CheckList__c  conch4= new Contract_CheckList__c(Name='Payment terms',Opportunity__c=op.id,S_No__c=5);
       Contract_CheckList__c  conch5= new Contract_CheckList__c(Name='Currency',Opportunity__c=op.id,S_No__c=6);
       Contract_CheckList__c  conch6= new Contract_CheckList__c(Name='Weir Terms & Conditions',Opportunity__c=op.id,S_No__c=7);
       Contract_CheckList__c  conch7= new Contract_CheckList__c(Name='Terms of Master Purchase Agreement / Agency Agreement',Opportunity__c=op.id,S_No__c=8);
       Contract_CheckList__c  conch8= new Contract_CheckList__c(Name='Technical specifications and work scope defined',Opportunity__c=op.id,S_No__c=9);
       Contract_CheckList__c  conch9= new Contract_CheckList__c(Name='Supplier quotes revalidated',Opportunity__c=op.id,S_No__c=10);
       Contract_CheckList__c  conch10= new Contract_CheckList__c(Name='Inspection and testing requirements in PO - as per our quotation',Opportunity__c=op.id,S_No__c=11);
       Contract_CheckList__c  conch11= new Contract_CheckList__c(Name='3rd Party Testing (such as DNV, CE, API and so forth)',Opportunity__c=op.id,S_No__c=12);
       Contract_CheckList__c  conch12= new Contract_CheckList__c(Name='Bond requirement and review',Opportunity__c=op.id,S_No__c=13);
       Contract_CheckList__c  conch13= new Contract_CheckList__c(Name='LD Penalty',Opportunity__c=op.id,S_No__c=14);
       Contract_CheckList__c  conch14= new Contract_CheckList__c(Name='Agent commission',Opportunity__c=op.id,S_No__c=15);
       Contract_CheckList__c  conch15= new Contract_CheckList__c(Name='Risk Assessment',Opportunity__c=op.id,S_No__c=16);
       Contract_CheckList__c  conch16= new Contract_CheckList__c(Name='Has the customer confirmed access to Drawings & Samples',Opportunity__c=op.id,S_No__c=17);
       Contract_CheckList__c  conch17= new Contract_CheckList__c(Name='Is the delivery date dependent on receiving drawings and samples from customer',Opportunity__c=op.id,S_No__c=18);
       Contract_CheckList__c  conch18= new Contract_CheckList__c(Name='Country Embargoes - any restrictions on customer/job destination',Opportunity__c=op.id,S_No__c=19);
       Contract_CheckList__c  conch19= new Contract_CheckList__c(Name='Is the job scope with in the approved business scope mandate',Opportunity__c=op.id,S_No__c=20);
       Contract_CheckList__c  conch20= new Contract_CheckList__c(Name='Is costing/ T&C/ cash flow backed up by supplier quotes',Opportunity__c=op.id,S_No__c=21);*/
      /* insert conch;
       insert conch1;
       insert conch2;
       insert conch3;
       insert conch4;
       insert conch5;
       insert conch6;
       insert conch7;
       insert conch8;
       insert conch9;
       insert conch10;
       insert conch11;
       insert conch12;
       insert conch13;
       insert conch14;
       insert conch15;
       insert conch16;
       insert conch17;
       insert conch18;
       insert conch19;
       insert conch20;*/
       
      /* Contract_Checklst__c chcon= new Contract_Checklst__c(Name__c='Work Scope Defined',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=1);
       Contract_Checklst__c chcon1= new Contract_Checklst__c(Name__c='Suppliers Proposals Validated',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=2);
       Contract_Checklst__c chcon2= new Contract_Checklst__c(Name__c='Customer PO Matches Quotation',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=3);
       Contract_Checklst__c chcon3= new Contract_Checklst__c(Name__c='Costing Sheet',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=4);
       Contract_Checklst__c chcon4= new Contract_Checklst__c(Name__c='Currency',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=5);
       Contract_Checklst__c chcon5= new Contract_Checklst__c(Name__c='Delivery Terms',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=6);
       Contract_Checklst__c chcon6= new Contract_Checklst__c(Name__c='LD Penalty',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=7);
       Contract_Checklst__c chcon7= new Contract_Checklst__c(Name__c='Purchase Order Attached ',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=8);
       Contract_Checklst__c chcon8= new Contract_Checklst__c(Name__c='Subcontractors Quotations',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=9);
       Contract_Checklst__c chcon9= new Contract_Checklst__c(Name__c='Need for CE DIR 97/23/EC',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=10);
       Contract_Checklst__c chcon10= new Contract_Checklst__c(Name__c='Terms & Conditions Checked',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=11);
       Contract_Checklst__c chcon11= new Contract_Checklst__c(Name__c='APS - Drawings & Samples',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=12);
       Contract_Checklst__c chcon12= new Contract_Checklst__c(Name__c='Commission',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=13);
       Contract_Checklst__c chcon13= new Contract_Checklst__c(Name__c='Bond Requirements',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=14);
       Contract_Checklst__c chcon14= new Contract_Checklst__c(Name__c='Risk Assessment',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=15);
       Contract_Checklst__c chcon15= new Contract_Checklst__c(Name__c='Hand-over checked',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=16);
       Contract_Checklst__c chcon16= new Contract_Checklst__c(Name__c='Invoice for advance payement submitted',Name='Contract Checklist',Opportunity__c=op.id,S_No__c=17); */
       /*insert chcon;
       insert chcon1;
       insert chcon2;
       insert chcon3;
       insert chcon4;
       insert chcon5;
       insert chcon6;
       insert chcon7;
       insert chcon8;
       insert chcon9;
       insert chcon10;
       insert chcon11;
       insert chcon12;
       insert chcon13;
       insert chcon14;
       insert chcon15;
       insert chcon16; */
       
       /* Abu_Dhabi_Contract_Checklist__c abu1= new Abu_Dhabi_Contract_Checklist__c(Name__c='Does the PO have the correct Quote number including any revision?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=1);
        Abu_Dhabi_Contract_Checklist__c abu2= new Abu_Dhabi_Contract_Checklist__c(Name__c='Does the price and currency mentioned on the PO match that of the quotation?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=2);
        Abu_Dhabi_Contract_Checklist__c abu3= new Abu_Dhabi_Contract_Checklist__c(Name__c='Do the delivery terms match that of the quotation?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=3);
        Abu_Dhabi_Contract_Checklist__c abu4= new Abu_Dhabi_Contract_Checklist__c(Name__c='Have all penalties, guarantees, bonds, insurances, etc. been read understood and communicated to the concerned department?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=4);
        Abu_Dhabi_Contract_Checklist__c abu5= new Abu_Dhabi_Contract_Checklist__c(Name__c='Does the PO have the correct scope of work as per the quote?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=5);
        Abu_Dhabi_Contract_Checklist__c abu6= new Abu_Dhabi_Contract_Checklist__c(Name__c='Any Change  in Technical Speciafication ?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=6);
        Abu_Dhabi_Contract_Checklist__c abu7= new Abu_Dhabi_Contract_Checklist__c(Name__c='Do the payment terms match that of the quotation?',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=7);
        Abu_Dhabi_Contract_Checklist__c abu8= new Abu_Dhabi_Contract_Checklist__c(Name__c='Do the LD terms are matching that of Quotation ? ',Name='Abu Dhabi Contract Checklist',Opportunity__c=op.id,S_No__c=8);*/
        /*insert abu1;
        insert abu2;
        insert abu3;
        insert abu4;
        insert abu5;
        insert abu6;
        insert abu7;
        insert abu8;*/
        
      /*List<Check_List__c>  chk = new List<Check_List__c>();
      Check_List__c chq1=new Check_List__c(Name='Is a kick-off tendering meeting required',Opportunity__c=op.id,S_No__c=1);
      chk.add(chq1);
      //insert chq1;
      List<Contract_CheckList__c>  cchk1 = new List<Contract_CheckList__c>();
      List<Contract_CheckLst__c>  ccchk1 = new List<Contract_CheckLst__c>();
      List<Abu_Dhabi_Contract_Checklist__c>  abuhk1 = new List<Abu_Dhabi_Contract_Checklist__c>();
      List<Account> acc1= new List<Account>();
        
        Weir_CreateOppController.CreateOpportunity(rfq);
        
        
       Test.stopTest();*/
    }
}