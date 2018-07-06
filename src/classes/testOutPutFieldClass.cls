public class testOutPutFieldClass {
    
    public opportunity opp{get;set;}
    
    public testOutPutFieldClass(){
        opp = [select name,closedate from opportunity limit 1];
    }

}