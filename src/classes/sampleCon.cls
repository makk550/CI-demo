public class sampleCon{
    public string strSelCountry {get; set;}
   // public List<SelectOption> lstCountries {get; set;}
    
    public sampleCon(){
        strSelCountry = 'MEXICO';
    }
    public List<SelectOption> getCountries() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('CANADA','Canada'));
        options.add(new SelectOption('MEXICO','Mexico'));
        return options;
    }   
}