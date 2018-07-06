function confirmBox(){
var answer = confirm('All the redlined changes made to the contract will go off. Do you want to proceed ?'); 
var AID= '{!$CurrentPage.parameters.AgrId}';
if(answer) {
	window.open('/apex/Apttus__SelectTemplate?id='+AID+'&action=Regenerate_Agreement&templateType=Agreement');                
            } else { 
                window.open('https://ca--dcml.cs27.my.salesforce.com/'+AID); 
        } 
}