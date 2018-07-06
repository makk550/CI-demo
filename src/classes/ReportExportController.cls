public with sharing class ReportExportController {
    public static final Set<String> validEncodings = new Set<String>{'UTF-8','MS932','Shift_JIS','GB18030','GB2312','Big5','EUC_KR','UTF-16','Big5-HKSCS','x-SJIS_0213'};
    public static final Set<String> validformats = new Set<String>{'printable','csv','xls'};
    public static final Set<String> validShowDetails = new Set<String>{'yes','no',null};

    public static String mockOutput; // to be used in unit test. getContent() can't be called in test, 

    // Basic options.
    public Id reportId {get;set;}
    public String format {get;set;} 
    public Boolean prettify {get;set;}
    public String showDetails {get;set;}
    public String encoding {get;set;}

    private String requestUrl, output;
    private Boolean restRequestNeeded;

    public ReportExportController(){
        prettify = true;
        restRequestNeeded = System.isFuture() || System.isScheduled(); // System.isBatch()
    }

    public String getOutput(){        
        getRequestUrl();
        System.debug('requestUrl:'+requestUrl);        
        fetchData();        
        if(prettify && output != null && output.length() > 0){
            prettify();
        }        
        return output;
    }

    public String getRequestUrl(){
        sanitizeInput();
        requestUrl = '/' + reportId + '?';
        if(format == 'printable'){
            requestUrl += 'excel=1' + (showDetails != null ? '&details=' + showDetails : '');
        } else {
            requestUrl += 'export=1&xf=' + format + '&enc=' + encoding;
        }
        if(restRequestNeeded) {
            requestUrl = URL.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:') + requestUrl;
        }
        return requestUrl;
    }

    private void sanitizeInput(){
        if(reportId == null){
            throw new ReportExportException('Missing argument: reportId');
        } else  if(!String.valueOf(reportId).startsWith('00O')) {
            throw new ReportExportException('Suspicious reportId: ' + reportId + '. Were you trying to export something other than a report?');
        }
        if(encoding == null || !validEncodings.contains(encoding)){
            encoding = 'UTF-8';
        }
        if(format == null || !validformats.contains(format)){
            format = 'xls';
        }
        if(!validShowDetails.contains(showDetails)){
            showDetails = null;
        }
    }

    private void fetchData(){
        if(Test.isRunningTest()){
            output = mockOutput;
        } else  if(restRequestNeeded){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(requestUrl);
            req.setMethod('GET');
            req.setHeader('Cookie','sid=' + UserInfo.getSessionId());
            output = new Http().send(req).getBody();
        } else {
            output = new PageReference(requestUrl).getContent().toString();
        }
    }

    private void prettify(){
        Integer startIndex = 0;
        Integer stopIndex = output.length();

        if(format == 'csv'){
            stopIndex = output.lastIndexOf('\n\n\n');   // "lastindexOf" because we look for last occurence of 3 x "Enter". So it should work even if there's data in report (textarea?) that contains such line
        } else {
            String endToken = '';
            if(format == 'xls'){
                startIndex = output.indexOf('<table>');
                endToken = '</table>';
            } else if(format == 'printable'){
                startIndex = output.indexOf('<div id="fchArea">');
                endToken = '</table>\n</div>';
            }
            stopIndex = output.lastIndexOf(endToken) + endToken.length();
        }
        if(startIndex != -1 && stopIndex != -1) {
            output = output.substring(startIndex, stopIndex);
        }
    }   
       

    public class ReportExportException extends Exception{}
}