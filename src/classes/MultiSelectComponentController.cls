public with sharing class MultiSelectComponentController {
	
	public List<SelectOption> selectedOptions{get;set;}
	public List<SelectOption> options{get;set;}
	public List<String> selected{get;set;}
	public List<String> deselected{get;set;}
	public String availableListName{get;set;}
	public String chosenListName{get;set;}
	
	public void selecting() {   
		for(String toSelect: selected) {
			Integer i = 0;
			While(i<options.size()) {
				if(options[i].getvalue()==toSelect) {
					selectedOptions.add(new SelectOption(toSelect,toSelect));
					options.remove(i);
				}                    
				i++;
			}
		}
	}
	
	public void deselecting() { 
		for(String toDeselect: deselected) {            
			Integer i = 0;
			While(i<selectedOptions.size()) {
				if(selectedOptions[i].getvalue()==toDeselect) {
					options.add(new SelectOption(toDeselect, toDeselect));
					selectedOptions.remove(i);
				}                    
				i++;
			}
		}  
	}
}