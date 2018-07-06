public  class NumberToWord {
	
	static String[] text_19 = new string[]{ 'zero', 'one',  'two', 'three', 'four',  'five',  'six', 'seven', 'eight', 'nine', 'ten',  'eleven', 'twelve', 'thirteen',  
      'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen' };  
      static String[] tens = new string[]{ 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};  
      static String[] denom = new string[]{ '',  
      'thousand',   'million',     'billion',    'trillion',    'quadrillion',  
      'quintillion', 's!xtillion',   'septillion',  'octillion',   'nonillion',  
      'decillion',  'undecillion',   'duodecillion', 'tredecillion',  'quattuordecillion',  
      's!xdecillion', 'septendecillion', 'octodecillion', 'novemdecillion', 'vigintillion' }; 
      
       
    
   public static String convert_nn(Integer val) {  
      if (val < 20)  
        return text_19[val];  
      if(val == 100)  
          return 'One Hundred';  
      for (Integer v = 0; v < tens.size(); v++) {  
        String dcap = tens[v];  
        Integer dval = 20 + 10 * v;  
        if (dval + 10 > val) {  
          if (Math.Mod(val,10) != 0)  
            return dcap + ' ' + text_19[Math.Mod(val,10)];  
          return dcap;  
        }      
      }  
      return null;  
    }  
    
    public static String convert_nnn(Integer val) {  
      String word = '';  
      Integer rem = val / 100;  
      Integer mod = Math.mod(val,100);  
      if (rem > 0) {  
        word = text_19[rem] + ' hundred';  
        if (mod > 0) {  
          word += ' ';  
        }  
      }  
      if (mod > 0) {  
        word += convert_nn(mod);  
      }  
      return word;  
    }  
    public static String convertWord(long val) {  
      if (val < 100) {  
        return convert_nn(val.intValue());  
      }  
      if (val < 1000) {  
        return convert_nnn(val.intValue());  
      }  
     for (Integer v = 0; v < denom.size(); v++) {  
        Integer didx = v - 1;  
        long dval = (long)Math.pow(1000, v);  
        if (dval > val) {  
          long mod = (long)Math.pow(1000, didx);  
          long l = (long) val / mod;  
          long r = (long) val - (l * mod);  
          String ret = convert_nnn(l.intValue()) + ' ' + denom[didx];  
          if (r > 0) {  
            ret += ', ' + convertWord(r);  
          }  
          return ret;  
        }  
      }  
      return null;  
    }  
  

}