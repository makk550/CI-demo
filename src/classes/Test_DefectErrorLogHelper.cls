/*
Created By: Tarun Sharma
Created On: 10/21/2015
Purpose: Test class to cover defect error log class
Modified By:
*/
@isTest
public class Test_DefectErrorLogHelper {
    private static testMethod void testDefectErrorLogMethod(){
        DefectErrorLogHelper defectErrorLogHelperObj = new DefectErrorLogHelper();
        defectErrorLogHelperObj.defectErrorLogMethod('123', 'DE123','{"start":"end"}', 'service response', 'GET', 200, 'www.abc.com');
     }
}