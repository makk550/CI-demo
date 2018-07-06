global class MyUserLicense {

    public static String show{get;set;} 
    global static String rawData = ''; 
    public String OrgName{get;set;} 
    Organization orgDetails;  
    Id orgId;
    PageReference pr;
    public static Integer Rowpos;
        
    public MyUserLicense (){
        
        show = '';
        orgDetails =[select Id, Name from Organization limit 1];
        orgId = orgDetails.Id;
        OrgName = 'The below table shows the Salesforce Licenses usage in '+orgDetails.Name+' production instance';
        pr = new PageReference('/'+orgId);
        
        if (Test.IsRunningTest())
                rawData  = 'User LicensesXXXX</table>XXXX<th scope="row" class=" dataCell  ">Salesforce</th>XXXXnumericalColumn">18,316</td>XXXXnumericalColumn">18,016</td>XXXXnumericalColumn">4,733</td>XXXX</tr></table>';
        else
                rawData = pr.getContent().toString();
                System.debug(rawData);
        
        }
       
    public list<License> getUL() {
    
    list<License> lstResult = new list<License>();  
     Integer i=0;
    Rowpos= rawData.indexOf('User Licenses');
    Rowpos=rawData.indexOf('</table>',Rowpos);
   
    While(rawData.substring(Rowpos+5, Rowpos+13)!='</table>')
       
    {  
        System.debug(rawData.substring(Rowpos+5, Rowpos+13));
        License L = new License(Rowpos);
        lstResult.add(L); 
        i++;
        
    }  
        return lstResult; 
    }
         
         
  public class License
    {  
    
    public Integer Total
    { get;set; }
    
    public Integer Used
    { get;set; }  
      
    public Integer available
    { get;set; }
    
    public String common
    { get;set; }
     
    public String style
    { get;set; }
    
    
    
          
    public License(Integer pos)  
    { 
    
    Integer endPos;
    String result;
            
       System.debug(pos);
       pos =  MyUserLicense.rawData.indexOf('<th scope="row" class=" dataCell  ">', pos);
       pos =  rawData.indexOf('>', pos);
       endPos = MyUserLicense.rawData.indexOf('</th>',pos+1);
       common = MyUserLicense.rawData.substring(pos+1, endPos);
       System.debug('License'+common);
       
       pos=MyUserLicense.rawData.indexOf('numericalColumn', pos);
       pos=rawData.indexOf('>', pos);
       endPos=MyUserLicense.rawData.indexOf('</td', pos+1);
       
       result=MyUserLicense.rawData.substring(pos+1, endPos);
                 result = result.remove(',');
                 Total = Integer.valueOf(result);
                 
                 System.debug('Total'+result);
                 
       pos=MyUserLicense.rawData.indexOf('numericalColumn', pos);
       pos=rawData.indexOf('>', pos);
       endPos=MyUserLicense.rawData.indexOf('</td', pos+1);
       
       result=MyUserLicense.rawData.substring(pos+1, endPos);
                 result = result.remove(',');
                 Used= Integer.valueOf(result);
                 
                 System.debug('Used'+result);
                 
       pos=MyUserLicense.rawData.indexOf('numericalColumn', pos);
       pos=rawData.indexOf('>', pos);
       endPos=MyUserLicense.rawData.indexOf('</td', pos+1);
       
       result=MyUserLicense.rawData.substring(pos+1, endPos);
                 result = result.remove(',');
                 available = Integer.valueOf(result);
                
                 System.debug('Avail'+result);
               
  
    
       
    if (Used > ((Total)*(Double.valueOf(System.label.Threshold)))){
               style = 'threshold';
               licenseThreshold.thresholdReached++;
               MyUserLicense.show = 'The above high-lighted Salesforce License have reached 95% usage.';
           }
     MyUserLicense.Rowpos=MyUserLicense.rawData.indexOf('</tr>',pos);
    }
    
   }
  }