public class Renewals_CRV {
    public  Renewals_CRV()
    {
          
    }

    public pagereference gotoRep()
    {
       // return new pagereference('/00OQ0000000OTL9?pv0=' + [Select name from user where id=: userinfo.getuserid()].name);
         return new pagereference('/' + Label.CRV_Report + '?pv0=' + [Select name from user where id=: userinfo.getuserid()].name);
       
    }
    public Static testMethod void testCRV()
    {
        Renewals_CRV crv =new Renewals_CRV();
        crv.gotoRep();
    }
}