global class CZPageSecurityPlugin implements SBQQ.PageSecurityPlugin2 {
    public Boolean isFieldEditable(String pageName, Schema.SObjectField field) {
        return null;
    }
    
    public Boolean isFieldEditable(String pageName, Schema.SObjectField field, SObject record) {
            if ((pageName == 'EditLines') && (record instanceof SBQQ__QuoteLine__c))
        {
            SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c) record;
            if ( (line.Running_User_Profile_System_Admin__c== false) && (field == SBQQ__QuoteLine__c.Starting_Price__c)  ) {
                return false;
        }     
            if ( (line.Running_User_Profile_System_Admin__c== false) && (field == SBQQ__QuoteLine__c.Partner_Discount_Percentage__c)  ) {
                return false;
        }                
            if ( (line.Running_User_Profile_System_Admin__c== false) && (field == SBQQ__QuoteLine__c.Global_Parent_Seat_Count__c)  ) {
                return false;
        }
        }
        return null;
    }  
    
    public Boolean isFieldVisible(String pageName, Schema.SObjectField field) {
        return null;
    }
    
    public Boolean isFieldVisible(String pageName, Schema.SObjectField field, SObject record) {
            if ((pageName == 'EditLines') && (record instanceof SBQQ__QuoteLine__c))
        {
            SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c) record;
            
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.Monthly_Unit_Price__c)  ) {
                return false;
        }
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.SBQQ__NetTotal__c)  ) {
                return false;
        }
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.Volume_Discount_Price_form__c)  ) {
                return false;
        }        
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.SBQQ__ListPrice__c)  ) {
                return false;
        }  
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.SBQQ__AdditionalDiscount__c)  ) {
                return false;
        }              
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.List_Price_form__c)  ) {
                return false;
        }     
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.Instance_Id__c)  ) {
                return false;
        }                         
            if ( (line.Parent_Bundle__c!= false) && (field == SBQQ__QuoteLine__c.Disc_Vol_Adj_form_final__c)  ) {
                return false;
        } 
            if ( (line.SBQQ__SubscriptionPercent__c != null) && (field == SBQQ__QuoteLine__c.SBQQ__Discount__c)  ) {
                return false;
        }
            if ( (line.Parent_Bundle__c!= false) && (field == SBQQ__QuoteLine__c.Approval__c)  ) {
                return false;
        } 
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.Global_Parent_Seat_Count__c)  ) {
                return false;
        }   
            if ( (line.Volume_Price_Curve_Quantity_Criteria__c!= 'Quote plus Global Parent Seat Count') && (field == SBQQ__QuoteLine__c.Global_Parent_Seat_Count__c)  ) {
                return false;
        } 
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.Starting_Price__c)  ) {
                return false;
        }   
            if ( (line.Parent_Bundle__c != false) && (field == SBQQ__QuoteLine__c.Partner_Discount_Percentage_Form__c) ) {
                return false;
        }         
        
        
        }
        
        
        return null;
    }
}