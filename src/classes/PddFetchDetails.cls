public class PddFetchDetails{
    
    Public Datetime lastModified{ get; set; }
    Public String relVer{ get; set; }
    Public Boolean checkNull { get; set; }    
    
    public PddFetchDetails(DateTime lastmodified, String relVer, Boolean checkNull){        
        this.lastmodified = lastmodified;
        if(relVer!=null) {  this.relVer= relVer; }
        else { this.relVer = ''; }
        this.checkNull =checkNull;
    }
    
    public PddFetchDetails(Boolean checkNull) {
        this.checkNull =checkNull;      
    }
}