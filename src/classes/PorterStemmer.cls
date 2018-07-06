public with sharing class PorterStemmer
implements ILanguageStemmingAlgorithm
{
  //---------------------------------------------------------------------------------
  //  Adapted for Salesforce.com APEX lanaguage by 
  //  John Sautter
  //  jsautter@salesforce.com
  //
  //  This class implements the PORTER stemming algorithm, which
  //  is fully described in "An algorithm for suffix stripping",
  //  M.F. Porter (1980), _Program_, Vol. 14, No. 3, pp. 130-137
  //---------------------------------------------------------------------------------
  Pattern ALL_LC_WORDS_ONLY = null; 
  public PorterStemmer() { }
  
  //---------------------------------------------------------------------------------
  // ILanguageStemmingAlgorithm interface methods
  //---------------------------------------------------------------------------------
  
  //---------------------------------------------------------------------------------
  // Called once immediately after Algorithm is instantiated.  
  //--------------------------------------------------------------------------------- 
  public void initialize() 
  { 
    ALL_LC_WORDS_ONLY = Pattern.compile('(\\b[^\\WA-Z0-9_]+\\b)');  
  }
  
  //---------------------------------------------------------------------------------
  // Returns a list of the ISO 639-1 Languages that this Stemming Algorithm supports.
  // See: http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
  //---------------------------------------------------------------------------------
  private static final String[] LANGUAGES = new String[]{ 'en' };
  public String[] languagesSupported()
  {
    return LANGUAGES;
  }
  
  //---------------------------------------------------------------------------------
  // Returns the stem of pWord (pWord stripped of prefixes and/or suffixes).
  // This method must be re-entrant (unaffacted by multiple calls from different 
  // threads).  Typically, this is achieved by NOT relying on class member variables
  // to store state information in your class.
  //
  // Any implementation should expect whole words that match the regex
  // [\W]+ expression.  If the stemming algorithm can't stem the results, please
  // just return the word as-is and DO NOT throw any exceptions or alter the 
  // string in any way.
  //---------------------------------------------------------------------------------
  public String stem(String pWord)
  {
    String stemmedWord = pWord;
    if (ALL_LC_WORDS_ONLY.matcher(pWord).matches())
    {
        stemmedWord = porterStem(pWord);
    }
    return stemmedWord;
  }
  
  //---------------------------------------------------------------------------------
  // Below is the meat of the Porter Algorithm, as translated to Apex from 
  // John Keys original Java implementation.
  // 
  // ALL methods below here should remain private static.
  //---------------------------------------------------------------------------------

  //***************************************************************
  //  PorterStemmer.java
  //  Programmer: John Keyes (keyeg@ils.unc.edu)
  //  Last Modified: January 3, 1998
  //
  //  http://www.ils.unc.edu/~keyeg/java/porter/PorterStemmer.java
  //
  //  This class implements the PORTER stemming algorithm, which
  //  is fully described in "An algorithm for suffix stripping",
  //  M.F. Porter (1980), _Program_, Vol. 14, No. 3, pp. 130-137
  //***************************************************************

    private static String porterStem(String str) 
    {   
        // check for zero length
        if (str.length() > 0) {
        } else {
            return '';
        }
        str = step1a(str);
        str = step1b(str);
        str = step1c(str);
        str = step2(str);
        str = step3(str);
        str = step4(str);
        str = step5a(str);
        str = step5b(str);
        return str;
    } // end stem
    
    private static String step1a (String str) 
    {
        // SSES -> SS
        if (str.endsWith('sses')) {
            return str.substring(0, str.length() - 2);
//        // IES -> I
//        } else if (str.endsWith('ies')) {
//            return str.substring(0, str.length() - 2);
        // IES -> Y
        } else if (str.endsWith('ies')) {
            return str.substring(0, str.length() - 3) + 'y';
        // SS -> S
        } else if (str.endsWith('ss')) {
            return str;
        // S ->
        } else if (str.endsWith('s')) {
            return str.substring(0, str.length() - 1);
        } else {
            return str;
        }
    } // end step1a
    
    
    private static String step1b (String str) {
        // (m > 0) EED -> EE
        if (str.endsWith('eed')) {
            if (stringMeasure(str.substring(0, str.length() - 3)) > 0)
                return str.substring(0, str.length() - 1);
            else
                return str;
        // (*v*) ED ->
        } else if ((str.endsWith('ed')) &&
                   (containsVowel(str.substring(0, str.length() - 2)))) {
            return step1b2(str.substring(0, str.length() - 2));
        // (*v*) ING ->
        } else if ((str.endsWith('ing')) &&
                   (containsVowel(str.substring(0, str.length() - 3)))) {
            return step1b2(str.substring(0, str.length() - 3));
        } // end if
        return str;
    } // end step1b

    private static String step1b2 (String str) {
        // AT -> ATE
        if (str.endsWith('at') ||
            str.endsWith('bl') ||
            str.endsWith('iz')) {
            return str + 'e';
        } else if ((endsWithDoubleConsonent(str)) &&
                   (!(str.endsWith('l') || str.endsWith('s') || str.endsWith('z')))) {
            return str.substring(0, str.length() - 1);
        } else if ((stringMeasure(str) == 1) &&
                   (endsWithCVC(str))) {
            return str + 'e';
        } else {
            return str;
        }
    } // end step1b2

    private static String step1c(String str) {
//        // (*v*) Y -> I
//        if (str.endsWith('y')) {
//            if (containsVowel(str.substring(0, str.length() - 1)))
//                return str.substring(0, str.length() - 1) + 'i';
//        } // end if
        // (*v*) Remove 'Y' if not proceeded by vowel.  methodology becomes methodolog, but money stays money, relay stays relay 
        if ((str.length() > 3) && str.endsWith('y')) {
            if (!containsVowel(str.substring(str.length() - 2, str.length() - 1)))
                return str.substring(0, str.length() - 1);
        } // end if
        return str;
    } // end step1c

    private static String step2 (String str) {
        // (m > 0) ATIONAL -> ATE
        if ((str.endsWith('ational')) &&
            (stringMeasure(str.substring(0, str.length() - 5)) > 0)) {
            return str.substring(0, str.length() - 5) + 'e';
        // (m > 0) TIONAL -> TION
        } else if ((str.endsWith('tional')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) ENCI -> ENCE
        } else if ((str.endsWith('enci')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) ANCI -> ANCE
        } else if ((str.endsWith('anci')) &&
            (stringMeasure(str.substring(0, str.length() - 1)) > 0)) {
            return str.substring(0, str.length() - 1) + 'e';
        // (m > 0) IZER -> IZE
        } else if ((str.endsWith('izer')) &&
            (stringMeasure(str.substring(0, str.length() - 1)) > 0)) {
            return str.substring(0, str.length() - 1);
        // (m > 0) ABLI -> ABLE
        } else if ((str.endsWith('abli')) &&
            (stringMeasure(str.substring(0, str.length() - 1)) > 0)) {
            return str.substring(0, str.length() - 1) + 'e';
        // (m > 0) ENTLI -> ENT
        } else if ((str.endsWith('alli')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) ELI -> E
        } else if ((str.endsWith('entli')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) OUSLI -> OUS
        } else if ((str.endsWith('eli')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) IZATION -> IZE
        } else if ((str.endsWith('ousli')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) IZATION -> IZE
        } else if ((str.endsWith('ization')) &&
            (stringMeasure(str.substring(0, str.length() - 5)) > 0)) {
            return str.substring(0, str.length() - 5) + 'e';
        // (m > 0) ATION -> ATE
        } else if ((str.endsWith('ation')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3) + 'e';
        // (m > 0) ATOR -> ATE
        } else if ((str.endsWith('ator')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2) + 'e';
        // (m > 0) ALISM -> AL
        } else if ((str.endsWith('alism')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
           return str.substring(0, str.length() - 3);
        // (m > 0) IVENESS -> IVE
        } else if ((str.endsWith('iveness')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 0)) {
            return str.substring(0, str.length() - 4);
        // (m > 0) FULNESS -> FUL
        } else if ((str.endsWith('fulness')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 0)) {
            return str.substring(0, str.length() - 4);
        // (m > 0) OUSNESS -> OUS
        } else if ((str.endsWith('ousness')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 0)) {
            return str.substring(0, str.length() - 4);
        // (m > 0) ALITII -> AL
        } else if ((str.endsWith('aliti')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3);
        // (m > 0) IVITI -> IVE
        } else if ((str.endsWith('iviti')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3) + 'e';
        // (m > 0) BILITI -> BLE
        } else if ((str.endsWith('biliti')) &&
            (stringMeasure(str.substring(0, str.length() - 5)) > 0)) {
            return str.substring(0, str.length() - 5) + 'le';
        } // end if
        return str;
    } // end step2

    private static String step3 (String str) {
        // (m > 0) ICATE -> IC
        if ((str.endsWith('icate')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3);
        // (m > 0) ATIVE ->
        } else if ((str.endsWith('ative')) &&
            (stringMeasure(str.substring(0, str.length() - 5)) > 0)) {
            return str.substring(0, str.length() - 5);
        // (m > 0) ALIZE -> AL
        } else if ((str.endsWith('alize')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3);
        // (m > 0) ICITI -> IC
        } else if ((str.endsWith('iciti')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3);
        // (m > 0) ICAL -> IC
        } else if ((str.endsWith('ical')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 0)) {
            return str.substring(0, str.length() - 2);
        // (m > 0) FUL ->
        } else if ((str.endsWith('ful')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 0)) {
            return str.substring(0, str.length() - 3);
        // (m > 0) NESS ->
        } else if ((str.endsWith('ness')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 0)) {
            return str.substring(0, str.length() - 4);
        } // end if
        return str;
    } // end step3

    private static String step4 (String str) {
        if ((str.endsWith('al')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 1)) {
            return str.substring(0, str.length() - 2);
            // (m > 1) ANCE ->
        } else if ((str.endsWith('ance')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 1)) {
            return str.substring(0, str.length() - 4);
        // (m > 1) ENCE ->
        } else if ((str.endsWith('ence')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 1)) {
            return str.substring(0, str.length() - 4);
        // (m > 1) ER ->
        } else if ((str.endsWith('er')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 1)) {
            return str.substring(0, str.length() - 2);
        // (m > 1) IC ->
        } else if ((str.endsWith('ic')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 1)) {
            return str.substring(0, str.length() - 2);
        // (m > 1) ABLE ->
        } else if ((str.endsWith('able')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 1)) {
            return str.substring(0, str.length() - 4);
        // (m > 1) IBLE ->
        } else if ((str.endsWith('ible')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 1)) {
            return str.substring(0, str.length() - 4);
        // (m > 1) ANT ->
        } else if ((str.endsWith('ant')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) EMENT ->
        } else if ((str.endsWith('ement')) &&
            (stringMeasure(str.substring(0, str.length() - 5)) > 1)) {
            return str.substring(0, str.length() - 5);
        // (m > 1) MENT ->
        } else if ((str.endsWith('ment')) &&
            (stringMeasure(str.substring(0, str.length() - 4)) > 1)) {
            return str.substring(0, str.length() - 4);
        // (m > 1) ENT ->
        } else if ((str.endsWith('ent')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) and (*S or *T) ION ->
        } else if ((str.endsWith('sion') || str.endsWith('tion')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) OU ->
        } else if ((str.endsWith('ou')) &&
            (stringMeasure(str.substring(0, str.length() - 2)) > 1)) {
            return str.substring(0, str.length() - 2);
        // (m > 1) ISM ->
        } else if ((str.endsWith('ism')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) ATE ->
        } else if ((str.endsWith('ate')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) ITI ->
        } else if ((str.endsWith('iti')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) OUS ->
        } else if ((str.endsWith('ous')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) IVE ->
        } else if ((str.endsWith('ive')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        // (m > 1) IZE ->
        } else if ((str.endsWith('ize')) &&
            (stringMeasure(str.substring(0, str.length() - 3)) > 1)) {
            return str.substring(0, str.length() - 3);
        } // end if
        return str;
    } // end step4


    private static String step5a (String str) {
        // (m > 1) E ->
        if ((stringMeasure(str.substring(0, str.length() - 1)) > 1) &&
            str.endsWith('e'))
            return str.substring(0, str.length() -1);
        // (m = 1 and not *0) E ->
        else if ((stringMeasure(str.substring(0, str.length() - 1)) == 1) &&
                 (!endsWithCVC(str.substring(0, str.length() - 1))) &&
                 (str.endsWith('e')))
            return str.substring(0, str.length() - 1);
        else
            return str;
    } // end step5a


    private static String step5b (String str) {
        // (m > 1 and *d and *L) ->
        if (str.endsWith('l') &&
            endsWithDoubleConsonent(str) &&
            (stringMeasure(str.substring(0, str.length() - 1)) > 1)) {
            return str.substring(0, str.length() - 1);
        } else {
            return str;
        }
    } // end step5b

   //-------------------------------------------------------
   // The following are functions to help compute steps 1 - 5
   //-------------------------------------------------------

  private static String[] toCharArray(string str)
  {
    String[] result = new String[str.length()];
    for (Integer k=0; k < str.length(); k++)
    {
      result[k] = str.substring(k,k+1);
    } // endfor
    return result;
  }
  
  private static String charAt(String str, Integer index)
  {
    return str.substring(index, index+1);
  }
  
  private static boolean endsWithS(String str)
  {
    return str.endsWith('s');
  }
  
  private static boolean containsVowel(String str) 
  {
    return str.contains('a') || str.contains('e') || str.contains('i') || 
           str.contains('o') || str.contains('u') || str.contains('y');
  } // end function
  
  private static boolean isVowel(String str)
  {
    return str.equals('a') || str.equals('e') || str.equals('i') || 
           str.equals('o') || str.equals('u');
  }
  
  private static boolean endsWithDoubleConsonent(String str) 
  {
    String c = charAt(str, str.length() - 1);
    
    return ((!isVowel(c)) && (c.equals(charAt(str, str.length() - 2))));
  } // end function

  private static Integer stringMeasure(String str) 
  {
    Integer count = 0;
    boolean vowelSeen = false;
    String[] strchars = toCharArray(str);

    for (String nextChar: strchars) 
    {
      if (isVowel(nextChar)) 
      {
        vowelSeen = true;
      } else if (vowelSeen) 
      {
        count++;
        vowelSeen = false;
      }
    } // end for
    return count;
  } // end function

    // does stem end with CVC?
  private static boolean endsWithCVC (String str) 
  {
      String c, v, c2 = ' ';
      if (str.length() >= 3) 
      {
          c = charAt(str, str.length() - 1);
          v = charAt(str, str.length() - 2);
          c2 = charAt(str, str.length() - 3);
      } 
      else 
      {
        return false;
      }

      if ((c == 'w') || (c == 'x') || (c == 'y')) {
            return false;
      } else if (isVowel(c)) {
            return false;
      } else if (!isVowel(v)) {
            return false;
      } else if (isVowel(c2)) {
            return false;
      } else {
            return true;
      }
  } // end function
  

  public static testMethod void testPorterStemmer()
  {
    ILanguageStemmingAlgorithm test = new PorterStemmer();
    test.initialize();
    System.debug('Languages Supported -> ' + test.languagesSupported()[0]);

    // These will all get kicked back as-is, since they violate the ALL_LC_WORDS_ONLY screen.
    
    System.debug('san francisco -> ' + test.stem('san francisco')); // contains whitespace
    System.debug('webMethods -> ' + test.stem('webMethods'));       // embedded UC character
    System.debug('lotus123 -> ' + test.stem('lotus123'));           // numbers
    System.debug('tcp/ip -> ' + test.stem('tcp/ip'));               // punctuation
    
    
    System.debug('caresses -> ' + test.stem('caresses'));
    System.debug('conditional -> ' + test.stem('conditional'));
    System.debug('rational -> ' + test.stem('rational'));
    System.debug('digitizer -> ' + test.stem('digitizer'));
    System.debug('operator -> ' + test.stem('operator'));
    System.debug('feudalism -> ' + test.stem('feudalism'));
    System.debug('decisiveness -> ' + test.stem('decisiveness'));
    System.debug('hopefulness -> ' + test.stem('hopefulness'));
    System.debug('callousness -> ' + test.stem('callousness'));

    System.debug('triplicate -> ' + test.stem('triplicate'));
    System.debug('formative -> ' + test.stem('formative'));
    System.debug('formalize -> ' + test.stem('formalize'));
    System.debug('electrical -> ' + test.stem('electrical'));
    System.debug('hopeful -> ' + test.stem('hopeful'));
    System.debug('goodness -> ' + test.stem('goodness'));

    System.debug('revival -> ' + test.stem('revival'));
    System.debug('allowance -> ' + test.stem('allowance'));
    System.debug('inference -> ' + test.stem('inference'));
    System.debug('airliner -> ' + test.stem('airliner'));
    System.debug('adjustable -> ' + test.stem('adjustable'));
    System.debug('defensible -> ' + test.stem('defensible'));
    System.debug('replacement -> ' + test.stem('replacement'));
    System.debug('adoption -> ' + test.stem('adoption'));
    
    System.debug('probate -> ' + test.stem('probate'));
    System.debug('rate -> ' + test.stem('rate'));
    System.debug('cease -> ' + test.stem('cease'));
    System.debug('controll -> ' + test.stem('controll'));
    System.debug('roll -> ' + test.stem('roll'));
    System.debug('replacement -> ' + test.stem('replacement'));
    
    System.debug('anomalies -> ' + test.stem('anomalies'));     
    System.debug('keys -> ' + test.stem('keys'));
    System.debug('mannered -> ' + test.stem('mannered'));
    
  }
  
  
    
}