public without sharing class Weir_CreateOppController 
{ 
   public static id recordtype;
    
   public static void CreateOpportunity(RFQ__c[] rfq) 
   {
      List<Check_List__c>  chk = new List<Check_List__c>();
      List<Contract_CheckList__c>  cchk = new List<Contract_CheckList__c>();
      List<Contract_CheckLst__c>  ccchk = new List<Contract_CheckLst__c>();
      List<Abu_Dhabi_Contract_Checklist__c>  abuhk = new List<Abu_Dhabi_Contract_Checklist__c>();
      List<Account> acc= new List<Account>();
      COpportunity__c o = new COpportunity__c(); 
      Id qid;
      Id Oppid;
      for(RFQ__c r :rfq)
      {  
         
          Datetime d = system.Today();
          o.Customer__c= r.Account__c;
          o.Close_Date__c = r.Date_on_Enquiry__c;
          o.Status__c= 'Initial Review';
          acc = [SELECT Id,Customer_Service_Representative__c FROM Account where id=:r.Account__c];
          o.OwnerId = acc[0].Customer_Service_Representative__c;
          o.Opportunity_Name__c=rfq[0].Name +''+ d.format('MM/dd/yyyy'); 
          o.Tendering_Manager__c = r.Tendering_Manager__c;
          o.path__c =  r.path__c; 
          o.Customer_Support_Engineer_Email__c =  r.Support_Engineer_Email__c; 
          o.Ref_if_any_in_customer_communication__c = r.Customer_s_reference_in_RFQ__c;
          o.Contents_of_customer_communication__c = r.Email_Content__c;
          recordtype = r.RecordTypeId;
          system.debug('%%%%'+recordtype );
          qid = r.Quotation__c; 
          Oppid = r.Opportunity__c;       
      }
      if(recordtype=='012b0000000DcL4AAK')
      {
          List<Quotation__c> quotation = [select id,COpportunity__c,PO_received_from_customer__c from Quotation__c where id=:qid ];
          quotation[0].PO_received_from_customer__c =true;
          update quotation;          
          List<COpportunity__c> copp = [SELECT Id, Status__c FROM COpportunity__c where id=:quotation[0].COpportunity__c]; 
          copp[0].Status__c = 'PO received';
          update copp;
      }
      
     else  
      {
          if(recordtype=='012b0000000DcL5AAK')
          {
             o.Status__c= 'PO received';
             o.RFQ_Record_type__c ='RFQ without quotation under Contract';
          }
          else if(recordtype=='012b0000000DcL6AAK')
          {
             List<COpportunity__c> newopp = [SELECT Id, Status__c FROM COpportunity__c where id=:Oppid]; 
             o.Status__c =newopp[0].Status__c;
             o.Parent_Opportunity__c = newopp[0].id;
          }
          else
          {
             o.Status__c= 'Initial Review';
             o.RFQ_Record_type__c ='RFQ  via Email';
          }
          insert o;
          Check_List__c  c1= new Check_List__c(Name='Is a kick-off tendering meeting required',Opportunity__c=o.id,S_No__c=1);
          Check_List__c  c2= new Check_List__c(Name='Do we have complete clarity on Tender Requirements and Job Scope',Opportunity__c=o.id,S_No__c=2);
          Check_List__c  c3= new Check_List__c(Name='Is the job scope within the approved business scope mandate',Opportunity__c=o.id,S_No__c=3);
          Check_List__c  c4= new Check_List__c(Name='Is there any registration / pre-qualification requirement for us',Opportunity__c=o.id,S_No__c=4);
          Check_List__c  c5= new Check_List__c(Name='Country Embargoes-Is the customer/job destination subject to any restrictions',Opportunity__c=o.id,S_No__c=5);
          Check_List__c  c6= new Check_List__c(Name='Terms and Conditions reviewed and lawyers comments obtained as required',Opportunity__c=o.id,S_No__c=6);
          Check_List__c  c7= new Check_List__c(Name='Bond Requirement - reviewed and costed',Opportunity__c=o.id,S_No__c=7);
          Check_List__c  c8= new Check_List__c(Name='Duties and taxes - reviewed and costed',Opportunity__c=o.id,S_No__c=8);
          Check_List__c  c9= new Check_List__c(Name='Insurance - reviewed and costed',Opportunity__c=o.id,S_No__c=9);
          Check_List__c  c10= new Check_List__c(Name='Commercial Review - warranty',Opportunity__c=o.id,S_No__c=10);
          Check_List__c  c11= new Check_List__c(Name='Commercial Review - LD',Opportunity__c=o.id,S_No__c=11);
          Check_List__c  c12= new Check_List__c(Name='Commercial Review - Limit of liability',Opportunity__c=o.id,S_No__c=12);
          Check_List__c  c13= new Check_List__c(Name='Logistics costs',Opportunity__c=o.id,S_No__c=13);
          Check_List__c  c14= new Check_List__c(Name='Storage costs',Opportunity__c=o.id,S_No__c=14);
          Check_List__c  c15= new Check_List__c(Name='Agents commission or royalty fees or licensing costs',Opportunity__c=o.id,S_No__c=15);
          Check_List__c  c16= new Check_List__c(Name='3rd Party Testing (such as DNV, CE, API and so forth)',Opportunity__c=o.id,S_No__c=16);
          Check_List__c  c17= new Check_List__c(Name='QA/QC/HSE documents  - certification - attestation',Opportunity__c=o.id,S_No__c=17);
          Check_List__c  c18= new Check_List__c(Name='Mobilisation and demobilisation costs',Opportunity__c=o.id,S_No__c=18);
          Check_List__c  c19= new Check_List__c(Name='Field Service costs or costs from operational constraint at customer site',Opportunity__c=o.id,S_No__c=19);
          Check_List__c  c20= new Check_List__c(Name='Inflation factored in the costs for extended bid validity',Opportunity__c=o.id,S_No__c=20);
          Check_List__c  c21= new Check_List__c(Name='Comparison of costing for similar bids in the past ',Opportunity__c=o.id,S_No__c=21);
          Check_List__c  c22= new Check_List__c(Name='Is delivery lead time backed up by supplier quotes ',Opportunity__c=o.id,S_No__c=22);
          Check_List__c  c23= new Check_List__c(Name='Is delivery lead time backed up by Procurement',Opportunity__c=o.id,S_No__c=23);
          Check_List__c  c24= new Check_List__c(Name='Is costing backed up by supplier quotes ',Opportunity__c=o.id,S_No__c=24);
          Check_List__c  c25= new Check_List__c(Name='Is job delivery date backed up by Planning ',Opportunity__c=o.id,S_No__c=25);
          Check_List__c  c26= new Check_List__c(Name='If the nature of job requires an advance payment from the customer',Opportunity__c=o.id,S_No__c=26);
          Check_List__c  c27= new Check_List__c(Name='Project Risk Assessment',Opportunity__c=o.id,S_No__c=27);
          Check_List__c  c28= new Check_List__c(Name='Project Tender Document - for bid value exceeding GBP 3 million',Opportunity__c=o.id,S_No__c=28);
          Check_List__c  c29= new Check_List__c(Name='Pre-tender approval sheet - for bid value exceeding GBP 8 million',Opportunity__c=o.id,S_No__c=29);
          Check_List__c  c30= new Check_List__c(Name='Tendering Milestone Plan compiled',Opportunity__c=o.id,S_No__c=30);
          chk.add(c1); chk.add(c2); chk.add(c3); chk.add(c4); chk.add(c5); chk.add(c6);  chk.add(c7);
          chk.add(c8); chk.add(c9); chk.add(c10); chk.add(c11); chk.add(c12); chk.add(c13); chk.add(c14); chk.add(c15);
           chk.add(c16); chk.add(c17); chk.add(c18); chk.add(c19); chk.add(c20);chk.add(c21);
          chk.add(c22); chk.add(c23); chk.add(c24);
          chk.add(c25); chk.add(c26); chk.add(c27); chk.add(c28); chk.add(c29); chk.add(c30);
          insert chk; 
          
          Contract_CheckList__c cc1= new Contract_CheckList__c(Name='Quantity',Opportunity__c=o.id,S_No__c=1);
          Contract_CheckList__c  cc2= new Contract_CheckList__c(Name='Prices ',Opportunity__c=o.id,S_No__c=2);
          Contract_CheckList__c  cc3= new Contract_CheckList__c(Name='Delivery terms and destination',Opportunity__c=o.id,S_No__c=3);
          Contract_CheckList__c  cc4= new Contract_CheckList__c(Name='Delivery Date',Opportunity__c=o.id,S_No__c=4);
          Contract_CheckList__c  cc5= new Contract_CheckList__c(Name='Payment terms',Opportunity__c=o.id,S_No__c=5);
          Contract_CheckList__c  cc6= new Contract_CheckList__c(Name='Currency',Opportunity__c=o.id,S_No__c=6);
          Contract_CheckList__c  cc7= new Contract_CheckList__c(Name='Weir Terms & Conditions',Opportunity__c=o.id,S_No__c=7);
          Contract_CheckList__c  cc8= new Contract_CheckList__c(Name='Terms of Master Purchase Agreement / Agency Agreement',Opportunity__c=o.id,S_No__c=8);
          Contract_CheckList__c  cc9= new Contract_CheckList__c(Name='Technical specifications and work scope defined',Opportunity__c=o.id,S_No__c=9);
          Contract_CheckList__c  cc10= new Contract_CheckList__c(Name='Supplier quotes revalidated',Opportunity__c=o.id,S_No__c=10);
          Contract_CheckList__c  cc11= new Contract_CheckList__c(Name='Inspection and testing requirements in PO - as per our quotation',Opportunity__c=o.id,S_No__c=11);
          Contract_CheckList__c  cc12= new Contract_CheckList__c(Name='3rd Party Testing (such as DNV, CE, API and so forth)',Opportunity__c=o.id,S_No__c=12);
          Contract_CheckList__c  cc13= new Contract_CheckList__c(Name='Bond requirement and review',Opportunity__c=o.id,S_No__c=13);
          Contract_CheckList__c  cc14= new Contract_CheckList__c(Name='LD Penalty',Opportunity__c=o.id,S_No__c=14);
          Contract_CheckList__c  cc15= new Contract_CheckList__c(Name='Agent commission',Opportunity__c=o.id,S_No__c=15);
          Contract_CheckList__c  cc16= new Contract_CheckList__c(Name='Risk Assessment',Opportunity__c=o.id,S_No__c=16);
          Contract_CheckList__c  cc17= new Contract_CheckList__c(Name='Has the customer confirmed access to Drawings & Samples',Opportunity__c=o.id,S_No__c=17);
          Contract_CheckList__c  cc18= new Contract_CheckList__c(Name='Is the delivery date dependent on receiving drawings and samples from customer',Opportunity__c=o.id,S_No__c=18);
          Contract_CheckList__c  cc19= new Contract_CheckList__c(Name='Country Embargoes - any restrictions on customer/job destination',Opportunity__c=o.id,S_No__c=19);
          Contract_CheckList__c  cc20= new Contract_CheckList__c(Name='Is the job scope with in the approved business scope mandate',Opportunity__c=o.id,S_No__c=20);
          Contract_CheckList__c  cc21= new Contract_CheckList__c(Name='Is costing/ T&C/ cash flow backed up by supplier quotes',Opportunity__c=o.id,S_No__c=21);
          
          cchk.add(cc1);cchk.add(cc2);cchk.add(cc3);cchk.add(cc4);cchk.add(cc5);
          cchk.add(cc6);cchk.add(cc7);cchk.add(cc8);cchk.add(cc9);cchk.add(cc10);
          cchk.add(cc11);cchk.add(cc12);cchk.add(cc13);cchk.add(cc14);cchk.add(cc15);
          cchk.add(cc16);cchk.add(cc17);cchk.add(cc18);cchk.add(cc19);cchk.add(cc20);
          cchk.add(cc21);
          insert cchk ;
          
         
          Contract_Checklst__c ccc1= new Contract_Checklst__c(Name__c='Work Scope Defined',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=1);
          Contract_Checklst__c ccc2= new Contract_Checklst__c(Name__c='Suppliers Proposals Validated',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=2);
          Contract_Checklst__c ccc3= new Contract_Checklst__c(Name__c='Customer PO Matches Quotation',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=3);
          Contract_Checklst__c ccc4= new Contract_Checklst__c(Name__c='Costing Sheet',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=4);
          Contract_Checklst__c ccc5= new Contract_Checklst__c(Name__c='Currency',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=5);
          Contract_Checklst__c ccc6= new Contract_Checklst__c(Name__c='Delivery Terms',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=6);
          Contract_Checklst__c ccc7= new Contract_Checklst__c(Name__c='LD Penalty',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=7);
          Contract_Checklst__c ccc8= new Contract_Checklst__c(Name__c='Purchase Order Attached ',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=8);
          Contract_Checklst__c ccc9= new Contract_Checklst__c(Name__c='Subcontractors Quotations',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=9);
          Contract_Checklst__c ccc10= new Contract_Checklst__c(Name__c='Need for CE DIR 97/23/EC',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=10);
          Contract_Checklst__c ccc11= new Contract_Checklst__c(Name__c='Terms & Conditions Checked',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=11);
          Contract_Checklst__c ccc12= new Contract_Checklst__c(Name__c='APS - Drawings & Samples',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=12);
          Contract_Checklst__c ccc13= new Contract_Checklst__c(Name__c='Commission',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=13);
          Contract_Checklst__c ccc14= new Contract_Checklst__c(Name__c='Bond Requirements',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=14);
          Contract_Checklst__c ccc15= new Contract_Checklst__c(Name__c='Risk Assessment',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=15);
          Contract_Checklst__c ccc16= new Contract_Checklst__c(Name__c='Hand-over checked',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=16);
          Contract_Checklst__c ccc17= new Contract_Checklst__c(Name__c='Invoice for advance payement submitted',Name='Contract Checklist',Opportunity__c=o.id,S_No__c=17);
          ccchk.add(ccc1);ccchk.add(ccc2);ccchk.add(ccc3);ccchk.add(ccc4);ccchk.add(ccc5);
          ccchk.add(ccc6);ccchk.add(ccc7);ccchk.add(ccc8);ccchk.add(ccc9);ccchk.add(ccc10);
          ccchk.add(ccc11);ccchk.add(ccc12);ccchk.add(ccc13);ccchk.add(ccc14);ccchk.add(ccc15);
          ccchk.add(ccc16);ccchk.add(ccc17);
          insert ccchk ;
          
          Abu_Dhabi_Contract_Checklist__c abu1= new Abu_Dhabi_Contract_Checklist__c(Name__c='Does the PO have the correct Quote number including any revision?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=1);
          Abu_Dhabi_Contract_Checklist__c abu2= new Abu_Dhabi_Contract_Checklist__c(Name__c='Does the price and currency mentioned on the PO match that of the quotation?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=2);
          Abu_Dhabi_Contract_Checklist__c abu3= new Abu_Dhabi_Contract_Checklist__c(Name__c='Do the delivery terms match that of the quotation?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=3);
          Abu_Dhabi_Contract_Checklist__c abu4= new Abu_Dhabi_Contract_Checklist__c(Name__c='Have all penalties, guarantees, bonds, insurances, etc. been read understood and communicated to the concerned department?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=4);
          Abu_Dhabi_Contract_Checklist__c abu5= new Abu_Dhabi_Contract_Checklist__c(Name__c='Does the PO have the correct scope of work as per the quote?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=5);
          Abu_Dhabi_Contract_Checklist__c abu6= new Abu_Dhabi_Contract_Checklist__c(Name__c='Any Change  in Technical Speciafication ?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=6);
          Abu_Dhabi_Contract_Checklist__c abu7= new Abu_Dhabi_Contract_Checklist__c(Name__c='Do the payment terms match that of the quotation?',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=7);
          Abu_Dhabi_Contract_Checklist__c abu8= new Abu_Dhabi_Contract_Checklist__c(Name__c='Do the LD terms are matching that of Quotation ? ',Name='Abu Dhabi Contract Checklist',Opportunity__c=o.id,S_No__c=8);
          abuhk.add(abu1);abuhk.add(abu2);abuhk.add(abu3);abuhk.add(abu4);abuhk.add(abu5);
          abuhk.add(abu6);abuhk.add(abu7);abuhk.add(abu8);
          insert abuhk ;
       }
   }
}