public class PLD_AcptRjtController {

    // Our test variable        
    public String myString {get; set;}

    public PLD_AcptRjtController(){
        myString = '';
    }

    // Method for testing a hidden field functionality 
    public PageReference myMethod(){
        System.debug('myString: ' + myString);
        return null;
    }
}