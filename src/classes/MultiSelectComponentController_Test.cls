@isTest
public class MultiSelectComponentController_Test {
    
 public static testMethod void multiselectTest(){
    
     MultiSelectComponentController multiselect=new MultiSelectComponentController();
     
     List<string> slectedstring=new List<string>();
        slectedstring.add('test 1');
        slectedstring.add('test 2');
     multiselect.selected=slectedstring;
     
     List<selectOption> selectop=new List<selectOption>();
       selectop.add(new  selectOption('test 1','test 1') );
            selectop.add(new  selectOption('test 2','test 2') );
   multiselect.options=selectop;
     multiselect.selectedOptions=new List<SelectOption>();
     
     multiselect.selecting();
     List<string> liststring=new List<string>();
        liststring.add('test 1');
     multiselect.deselected=liststring;
     multiselect.availableListName='';
     multiselect.chosenListName='';
     multiselect.deselecting();
     
     
     
     
     
     
        
        
        
 }
  
    
    

}