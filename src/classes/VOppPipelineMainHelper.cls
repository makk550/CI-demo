public class VOppPipelineMainHelper
{
    String[] tabNames = new String[]{'Core','Adoption','Health','Health Aging','Health Qtr','Health Qtr Aging','Momentum4','Momentum7'};
    public static Integer index = 0;
    String selectedTabName ; 

    public String getSelectedTabName()
    {
        return tabNames[index];
    }
}