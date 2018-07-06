public class ctrlChecklist_lookup 
{
    
     Public  List<string> profiles {get;set;}
     public  List<SelectOption> Items{get;set;}
     
     Public ctrlChecklist_lookup()
     {
     
         List<SelectOption> options = new List<SelectOption>();
         for(Profile p:[Select Name, Id from Profile Order By name ])
         {
              options.add(new SelectOption(p.Name,p.Name));
         }
        
         items = options;
          
     }
    
 
      


}