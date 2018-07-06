trigger Presales_Commission_Validations on PreSales_Comm__c (before insert,Before update) {
    
    if(Trigger.isInsert||Trigger.isUpdate){
        
        Integer value=0;
        
        for(PreSales_Comm__c comRecord:trigger.new){
            
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c==null)){
                if(comRecord.Commission_Split1__c!=null)
                    value+=Integer.valueOf(comRecord.Commission_Split1__c);
                if(comRecord.Commission_Split2__c!=null)
                    value+=Integer.valueOf(comRecord.Commission_Split2__c);
                if(comRecord.Commission_Split3__c!=null)
                    value+=Integer.valueOf(comRecord.Commission_Split3__c);
                
                if(value>0)
                    comRecord.addError('You cannot enter a commission value when there is no resource.');
            }
            
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c==null)){
                if(comRecord.Commission_Split1__c==100){
                    value += Integer.valueOf(comRecord.Commission_Split1__c);
                }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_1_Resource); 
                }
            }
            
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c==null)){
                if(comRecord.Commission_Split2__c==100){
                    value += Integer.valueOf(comRecord.Commission_Split2__c);
                }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_1_Resource);  
                }
            }
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c!=null)){
                if(comRecord.Commission_Split3__c==100){
                    value += Integer.valueOf(comRecord.Commission_Split3__c);
                }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_1_Resource); 
                }
            }
            
            //check for 1 resource ends here
            
            //check for 2 resources
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c==null)){
                
                if(((comRecord.Commission_Split1__c==75&&comRecord.Commission_Split2__c==25)||(comRecord.Commission_Split1__c==50&&comRecord.Commission_Split2__c==50)||(comRecord.Commission_Split1__c==90&&comRecord.Commission_Split2__c==10)
                    || (comRecord.Commission_Split1__c==25&&comRecord.Commission_Split2__c==75) || (comRecord.Commission_Split1__c==10&&comRecord.Commission_Split2__c==90))){
                        value += Integer.valueOf(comRecord.Commission_Split1__c);
                        value += Integer.valueOf(comRecord.Commission_Split2__c); 
                    }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_2_Resources); 
                }
                
            }
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c!=null)){
                
                if(((comRecord.Commission_Split2__c==75&&comRecord.Commission_Split3__c==25)||(comRecord.Commission_Split2__c==50&&comRecord.Commission_Split3__c==50)||(comRecord.Commission_Split2__c==90&&comRecord.Commission_Split3__c==10)
                    || (comRecord.Commission_Split2__c==25&&comRecord.Commission_Split3__c==75) || (comRecord.Commission_Split2__c==10&&comRecord.Commission_Split3__c==90))){
                        value += Integer.valueOf(comRecord.Commission_Split2__c);
                        value += Integer.valueOf(comRecord.Commission_Split3__c); 
                    }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_2_Resources);  
                    
                }
                
            }
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c!=null)){
                if(((comRecord.Commission_Split1__c==75&&comRecord.Commission_Split3__c==25)||(comRecord.Commission_Split1__c==50&&comRecord.Commission_Split3__c==50)||(comRecord.Commission_Split1__c==90&&comRecord.Commission_Split3__c==10)
                    || (comRecord.Commission_Split1__c==25&&comRecord.Commission_Split3__c==75) || (comRecord.Commission_Split1__c==10&&comRecord.Commission_Split3__c==90))){
                        value += Integer.valueOf(comRecord.Commission_Split1__c);
                        value += Integer.valueOf(comRecord.Commission_Split3__c); 
                    }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_2_Resources); 
                }
            }
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c!=null)){
                if((comRecord.Commission_Split1__c==33&&comRecord.Commission_Split2__c==33&&comRecord.Commission_Split3__c==33)||(comRecord.Commission_Split1__c==60&&comRecord.Commission_Split2__c==30&&comRecord.Commission_Split3__c==10)||(comRecord.Commission_Split1__c==60&&comRecord.Commission_Split2__c==10&&comRecord.Commission_Split3__c==30) || (comRecord.Commission_Split1__c==10&&comRecord.Commission_Split2__c==60&&comRecord.Commission_Split3__c==30)||(comRecord.Commission_Split1__c==10&&comRecord.Commission_Split2__c==30&&comRecord.Commission_Split3__c==60)|| (comRecord.Commission_Split1__c==30&&comRecord.Commission_Split2__c==60&&comRecord.Commission_Split3__c==10)||(comRecord.Commission_Split1__c==30&&comRecord.Commission_Split2__c==10&&comRecord.Commission_Split3__c==60) || (comRecord.Commission_Split1__c==50&&comRecord.Commission_Split2__c==25&&comRecord.Commission_Split3__c==25)||(comRecord.Commission_Split1__c==25&&comRecord.Commission_Split2__c==50&&comRecord.Commission_Split3__c==25) || (comRecord.Commission_Split1__c==25&&comRecord.Commission_Split2__c==25&&comRecord.Commission_Split3__c==50)){
                    value += Integer.valueOf(comRecord.Commission_Split1__c);
                    value += Integer.valueOf(comRecord.Commission_Split2__c); 
                    value += Integer.valueOf(comRecord.Commission_Split3__c); 
                    
                    
                    
                }
                else{
                    comRecord.addError(Label.Pre_Sales_Commission_3_Resources);
                }
            }
            //check for 2 resources ends here
            
            //check for 3 resources starts here
        }  
        
        
        
    }
    
    
}