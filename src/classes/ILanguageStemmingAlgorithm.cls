public interface ILanguageStemmingAlgorithm 
{
  //---------------------------------------------------------------------------------  
  // This Interface represents a stemming algorithm.  If you choose to implement this
  // interface for use with RFPForce, your implementation must only have a 
  // no-argument constructor.
  //--------------------------------------------------------------------------------- 
    
  //---------------------------------------------------------------------------------
  // Called once immediately after Algorithm is instantiated.  
  //--------------------------------------------------------------------------------- 
  void initialize();
  
  //---------------------------------------------------------------------------------
  // Returns a list of the ISO 639-1 Languages that this Stemming Algorithm supports.
  // See: http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
  //---------------------------------------------------------------------------------
  String[] languagesSupported();
  
  //---------------------------------------------------------------------------------
  // Returns the stem of pWord (pWord stripped of prefixes and/or suffixes).
  // This method must be re-entrant (unaffacted by multiple calls from different 
  // threads).  Typically, this is achieved by NOT relying on class member variables
  // to store state information in your class.
  //
  // Any implementation should expect only whole words that match the regex
  // [\W]+ expression.  If the stemming algorithm can't stem the results, please
  // just return the word as-is and DO NOT throw any exceptions or alter the 
  // string in any way.
  //---------------------------------------------------------------------------------
  String stem(String pWord);
}