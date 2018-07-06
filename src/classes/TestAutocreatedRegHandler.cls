@isTest
public class TestAutocreatedRegHandler {
    static testMethod void JitClassTest(){
ID samlSSoProviderId='0LE560000008ON0';
ID communityId='0DB56000000CaS0';
ID portalid='0DB56000000CaS0';
String federationIdentifier='rukhi03-cc@ca.com.fsb1';
Map<string,string> testmapAttributes = new Map<string,string>{'FirstName'=>'Himanshu','LastName'=>'Rukmangad','ProfileId'=>'00e30000001gy37','Username'=>'rukhi03-cc@ca.com.fsb1','Email'=>'rukhi03@ca.com'};
String assertion ='';
AutocreatedRegHandler1460987660036 jitclass = new AutocreatedRegHandler1460987660036();
User newUser=jitclass.createUser(samlSSoProviderId,communityId,portalid,federationIdentifier,testmapAttributes,assertion);
ID newuservalue='00556000000cCKU';    
    
//jitclass.updateUser(newuservalue,samlSSoProviderId,communityId,portalid,federationIdentifier,testmapAttributes,assertion); 
        }   
    static testMethod void JitClassTest1(){
        PostToGetController postget=new PostToGetController();
        PostToGetControllerCC postgetCC=new PostToGetControllerCC();
        PostToGetControllerPC postgetPC=new PostToGetControllerPC();
    }
}