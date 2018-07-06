public class InputPicklistNoNoneController 
{
    public String             defaultOption {get;set;}
    public List<SelectOption> options       {get;set;}
    public String             fieldName
    { 
        get;
        set 
        {
            fieldName = value;
            options = new List<SelectOption>();
            List<String> fieldNameSplit = fieldName.split('\\.');
        
            Schema.DescribeFieldResult picklistFieldDescription =
              Schema.getGlobalDescribe().get(fieldNameSplit[0])
              .getDescribe().fields.getMap()
              .get(fieldNameSplit[1]).getDescribe();

            for (Schema.Picklistentry picklistEntry:
                 picklistFieldDescription.getPicklistValues())
            {
                options.add(new SelectOption(pickListEntry.getValue(),
                                             pickListEntry.getLabel()));

                if (picklistEntry.defaultValue)
                {
                    defaultOption = pickListEntry.getValue();
                }
            }    
        }
    }    
}