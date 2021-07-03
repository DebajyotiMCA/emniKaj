trigger InvoiceLineItem_Trigger on Invoice_Line_Items__c (before insert,before update) {
    if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore ){
        
        List<String> prodDes = new List<String>();
        Map<String, Product_Codes__c> prodCodes = Product_Codes__c.getAll();
        for (String descr : prodCodes.keySet()) {
            Product_Codes__c aTax = prodCodes.get(descr);
            //prodDes.add(aTax.Description__c);
        }
        
        if(Trigger.isBefore && Trigger.isInsert){
            for(Invoice_Line_Items__c inItems : trigger.new){
                if(inItems.Product_Code__c != null){
                    Product_Codes__c prod = prodCodes.get(inItems.Product_Code__c);
                    if(prod != null){
                    if(prod.Arabic_ID__c != null){
                        //inItems.Product_Detatil__c = prod.Description__c;
                        if(prod.Level__c == 'L1'){
                            inItems.Arabic_ID__c = prod.Arabic_ID__c;
                        } else if(prod.Level__c == 'L2'){
                            inItems.Level_2_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L3'){
                            inItems.Level_3_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L4'){
                            inItems.Level_4_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L5'){
                            inItems.Level_5_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L6'){
                            inItems.Level_6_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L7'){
                            inItems.Level_7_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L8'){
                            inItems.Level_8_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L9'){
                            inItems.Level_9_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L10'){
                            inItems.Level_10_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L11'){
                            inItems.Level_11_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L12'){
                            inItems.Level_12_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L13'){
                            inItems.Level_13_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L14'){
                            inItems.Level_14_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L15'){
                            inItems.Level_15_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L16'){
                            inItems.Level_16_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L17'){
                            inItems.Level_17_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L18'){
                            inItems.Level_18_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L19'){
                            inItems.Level_19_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L20'){
                            inItems.Level_20_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L21'){
                            inItems.Level_21_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L22'){
                            inItems.Level_22_Link__c = prod.Arabic_ID__c; 
                        } else if(prod.Level__c == 'L23'){
                            inItems.Level_23_Link__c = prod.Arabic_ID__c; 
                        }
                        
                        
                    }
                	}
                }
            }
        } else if(Trigger.isBefore && Trigger.isUpdate){
            for(Invoice_Line_Items__c inItems : trigger.new){
                if(inItems.Product_Code__c != null){
                    Invoice_Line_Items__c old = Trigger.oldMap.get(inItems.Id);
                    
                    if(old.Product_Code__c != inItems.Product_Code__c && inItems.Product_Code__c != null){
                        if(old.Arabic_ID__c != null){
                            inItems.Arabic_ID__c = '';
                        } else if(old.Level_2_Link__c != null){
                            inItems.Level_2_Link__c = '';
                        } else if(old.Level_3_Link__c != null){
                            inItems.Level_3_Link__c = '';
                        } else if(old.Level_4_Link__c != null){
                            inItems.Level_4_Link__c = '';
                        } else if(old.Level_5_Link__c != null){
                            inItems.Level_5_Link__c = '';
                        } else if(old.Level_6_Link__c != null){
                            inItems.Level_6_Link__c = '';
                        } else if(old.Level_7_Link__c != null){
                            inItems.Level_7_Link__c = '';
                        } else if(old.Level_8_Link__c != null){
                            inItems.Level_8_Link__c = '';
                        } else if(old.Level_9_Link__c != null){
                            inItems.Level_9_Link__c = '';
                        } else if(old.Level_10_Link__c != null){
                            inItems.Level_10_Link__c = '';
                        } else if(old.Level_11_Link__c != null){
                            inItems.Level_11_Link__c = '';
                        } else if(old.Level_12_Link__c != null){
                            inItems.Level_12_Link__c = '';
                        } else if(old.Level_13_Link__c != null){
                            inItems.Level_13_Link__c = '';
                        } else if(old.Level_14_Link__c != null){
                            inItems.Level_14_Link__c = '';
                        } else if(old.Level_15_Link__c != null){
                            inItems.Level_15_Link__c = '';
                        } else if(old.Level_16_Link__c != null){
                            inItems.Level_16_Link__c = '';
                        } else if(old.Level_17_Link__c != null){
                            inItems.Level_17_Link__c = '';
                        } else if(old.Level_18_Link__c != null){
                            inItems.Level_18_Link__c = '';
                        } else if(old.Level_19_Link__c != null){
                            inItems.Level_19_Link__c = '';
                        } else if(old.Level_20_Link__c != null){
                            inItems.Level_20_Link__c = '';
                        } else if(old.Level_21_Link__c != null){
                            inItems.Level_21_Link__c = '';
                        } else if(old.Level_22_Link__c != null){
                            inItems.Level_22_Link__c = '';
                        } else if(old.Level_23_Link__c != null){
                            inItems.Level_23_Link__c = '';
                        } 
                        
                        Product_Codes__c prod = prodCodes.get(inItems.Product_Code__c);
                        if(prod.Arabic_ID__c != null){
                            if(prod.Level__c == 'L1'){
                                inItems.Arabic_ID__c = prod.Arabic_ID__c;
                            } else if(prod.Level__c == 'L2'){
                                inItems.Level_2_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L3'){
                                inItems.Level_3_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L4'){
                                inItems.Level_4_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L5'){
                                inItems.Level_5_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L6'){
                                inItems.Level_6_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L7'){
                                inItems.Level_7_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L8'){
                                inItems.Level_8_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L9'){
                                inItems.Level_9_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L10'){
                                inItems.Level_10_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L11'){
                                inItems.Level_11_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L12'){
                                inItems.Level_12_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L13'){
                                inItems.Level_13_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L14'){
                                inItems.Level_14_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L15'){
                                inItems.Level_15_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L16'){
                                inItems.Level_16_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L17'){
                                inItems.Level_17_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L18'){
                                inItems.Level_18_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L19'){
                                inItems.Level_19_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L20'){
                                inItems.Level_20_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L21'){
                                inItems.Level_21_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L22'){
                                inItems.Level_22_Link__c = prod.Arabic_ID__c; 
                            } else if(prod.Level__c == 'L23'){
                                inItems.Level_23_Link__c = prod.Arabic_ID__c; 
                            }
                            
                            
                        }
                	}
                }
            }
        }
        
    }
}