public class PaginatedList {
       
        public List<String> lstItems = new List<String>();
       
        private String selection;
        private Integer startIndex = 0;
        private Integer endIndex = 0;
               
        private Integer ACTUAL_SIZE = 0;
        private final Integer ALLOWED_LIST_SIZE=1000;
                 
        public PaginatedList (){
            lstItems.clear();
            for(Integer n=1; n<=3001; n++){
                lstItems.add(n+'');  
            }
            ACTUAL_SIZE = lstItems.size();
            Integer tempVar = (ACTUAL_SIZE <= ALLOWED_LIST_SIZE)? ACTUAL_SIZE:ALLOWED_LIST_SIZE;
            startIndex = 0;
            if(ACTUAL_SIZE == ALLOWED_LIST_SIZE || tempVar < ALLOWED_LIST_SIZE)
                endIndex = tempVar - 1;
            else
                endIndex = tempVar - 2;   
            selection = lstItems[0];
        }
               
        public PageReference change(){
           
            if (selection == 'next'){
                startIndex = endIndex + 1;
                Integer tempVar = ((ACTUAL_SIZE - endIndex)< ALLOWED_LIST_SIZE)? (ACTUAL_SIZE - endIndex): ALLOWED_LIST_SIZE;
                if (tempVar == ALLOWED_LIST_SIZE)
                    endIndex  = endIndex  + (tempVar - 2);
                else
                    endIndex  = endIndex  + (tempVar - 1);
            }
            if (selection == 'prev'){               
                endIndex = startIndex - 1;
                if(endIndex > ALLOWED_LIST_SIZE)
                    startIndex = startIndex - (ALLOWED_LIST_SIZE - 2);
                else
                    startIndex = startIndex - (ALLOWED_LIST_SIZE - 1);      
            }   
            return null;
        }
           
        public List<SelectOption> getItems(){            
            List<SelectOption> options = new List<SelectOption>();
            if(startIndex > 0){
                options.add(new SelectOption('prev','- prev -'));               
            }                      
            for(Integer i=startIndex; i<=endIndex; i++){
                options.add(new SelectOption(lstItems[i],lstItems[i]));  
            }
            if((ACTUAL_SIZE - startIndex) > ALLOWED_LIST_SIZE){
                options.add(new SelectOption('next','- next -'));               
            }                     
            return options;
        }
         
        public String getSelection(){
            if(selection == 'next' || selection == 'prev')
                selection = lstItems[startIndex];
            return selection;
        }
           
        public void setSelection(String selection){           
            this.selection = selection;
        }
}