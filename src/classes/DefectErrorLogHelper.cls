/*
Created By: Tarun Sharma
Created On: 10/21/2015
Purpose: To store errors in defect error log object
Modified By:
*/
public class DefectErrorLogHelper{
    public void defectErrorLogMethod(String caseNumber, String defectNumber, String request, String response, String operation, Integer statusCode, String endPoint){
        DefectErrorLog__c defectErrorLogObj = new DefectErrorLog__c();
        defectErrorLogObj.Case_Number__c = caseNumber;
        defectErrorLogObj.Defect_Number__c = defectNumber;
        defectErrorLogObj.Request_Payload__c = request;
        defectErrorLogObj.Response_Payload__c = response;
        if(statusCode>0 || statusCode<0){
            defectErrorLogObj.Status_Code__c = string.valueOf(statusCode);
        }
        defectErrorLogObj.Operation__c = operation;
        defectErrorLogObj.End_Point__c = endPoint;
        insert defectErrorLogObj;
    }
}