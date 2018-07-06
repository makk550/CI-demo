public with sharing class SolutionWrapper implements Comparable{
    
        public Boolean selected {get; set;}
        public String Reason {get; set;}
        public String AccessLevel {get;set;}
        public String SharedThrough {get;set;}
        public String SharedWith {get;set;}
        public Integer Frequency {get;set;}
    
    
    	public SolutionWrapper(String cause, String through, AggregateResult[] AReqList)
        {
            Reason = cause;
            AccessLevel = 'N/A';
            SharedThrough = through;
            selected = false;
            Frequency = 0;
            
            for(AggregateResult ar : AReqList){
                 system.debug('through>'+through);
                 system.debug('ar.get.sharedTo'+ar.get('SharedTo__c') );
                if(ar.get('SharedTo__c') == through)
                 Frequency = (Integer)ar.get('frequency');
            }
           
                        
            if(cause == 'Role')
                SharedWith = 'Role : '+[Select Name from UserRole where Id =:through].Name;
            else if(cause == 'Profile')
                SharedWith = 'Profile : '+[Select Name from Profile where Id =:through].Name;
                 
  
            
        }
    
    
    	public SolutionWrapper(AggregateResult[] AReqList, String cause, String through, String throughname)
        {
            Reason = cause;
            AccessLevel = 'N/A';
            SharedThrough = through;
            selected = false;
            Frequency = 0;
            
            for(AggregateResult ar : AReqList){
                 system.debug('through>'+through);
                 system.debug('ar.get.sharedTo'+ar.get('SharedTo__c') );
                if(ar.get('SharedTo__c') == through)
                 Frequency = (Integer)ar.get('frequency');
            }
            SharedWith = 'Territory : '+ throughname;
        }
                 
        public SolutionWrapper(String cause, String access,String through, AggregateResult[] AReqList)
        {
            Reason = cause;
            AccessLevel = access;
            SharedThrough = through;
            selected = false;
            Frequency = 0;
            
            for(AggregateResult ar : AReqList){
                 system.debug('through>'+through);
                 system.debug('ar.get.sharedTo'+ar.get('SharedTo__c') );
                if(ar.get('SharedTo__c') == through)
                 Frequency = (Integer)ar.get('frequency');
            }
           
                        
            if(cause == 'Profile')
                SharedWith = 'Profile : '+[Select Name from Profile where Id =:through].Name;
                 
            else if(cause == 'Permission Set')
                SharedWith = 'Permission Set : '+[Select Name from PermissionSet where Id =:through].Name;
            
        }
        
        public SolutionWrapper(String through, String With, String Cause, String access, AggregateResult[] AReqList)
        {
            Reason = Cause;
            AccessLevel = access;
            SharedThrough = through;
            selected = false;
            SharedWith = With;
            Frequency = 0;
            
            for(AggregateResult ar : AReqList){
                system.debug('5 through>'+through);
                 system.debug('5 ar.get.sharedTo'+ar.get('SharedTo__c') );
                if(ar.get('SharedTo__c') == through)
                 Frequency = (Integer)ar.get('frequency');
            }
            
            if (access == 'Read Only') 
                AccessLevel = 'Read';
            else if (access == 'Read/Write') 
                AccessLevel = 'Edit';
            else if (access == 'Private') 
                AccessLevel = 'None';
            else if (access == 'Full Access') 
                AccessLevel = 'All';    
                       
        }
         public SolutionWrapper(){}
         
         public Integer CompareTo(object compareTo){
            
            SolutionWrapper SW = (SolutionWrapper) compareTo;
            if(Frequency == SW.Frequency)
                return 0;
            if(Frequency < SW.Frequency)
                return 1;
            return -1;
            
         }
         
         
    
    

}