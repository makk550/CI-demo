public class PLR_PartnerScore 
{
    // Storage class to store the score value and the score reason for a partner account
    // This class is used by the Partner Lead Distribution feature
    // 
	Public Decimal ScoreValue = 0;
    Public String ScoreReason1 = '';
    Public String ScoreReason2 = '';
    Public String ScoreReason3 = '';
    Public String ScoreReason4 = '';
    Public String ScoreReason5 = '';
    
    Public void SetPartnerScoreValue( Decimal ScoreValueToSet )
    {
        ScoreValue = ScoreValueToSet.setScale(2);
    }
    
    Public void SetPartnerScoreReason1( String ScoreReasonToSet )
    {
        ScoreReason1 = ScoreReasonToSet;
    }
    
    Public void SetPartnerScoreReason2( String ScoreReasonToSet )
    {
        ScoreReason2 = ScoreReasonToSet;
    }
    
    Public void SetPartnerScoreReason3( String ScoreReasonToSet )
    {
        ScoreReason3 = ScoreReasonToSet;
    }
    
    Public void SetPartnerScoreReason4( String ScoreReasonToSet )
    {
        ScoreReason4 = ScoreReasonToSet;
    }
    
    Public void SetPartnerScoreReason5( String ScoreReasonToSet )
    {
        ScoreReason5 = ScoreReasonToSet;
    }
    
    Public Decimal GetPartnerScoreValue()
    {
        return ScoreValue;
    }
    
    Public String GetPartnerScoreReason1()
    {
        return ScoreReason1;
    }
    
    Public String GetPartnerScoreReason2()
    {
        return ScoreReason2;
    }
    
    Public String GetPartnerScoreReason3()
    {
        return ScoreReason3;
    }
    
    Public String GetPartnerScoreReason4()
    {
        return ScoreReason4;
    }
    
    Public String GetPartnerScoreReason5()
    {
        return ScoreReason5;
    }
}