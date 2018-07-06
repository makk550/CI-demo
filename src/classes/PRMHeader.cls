public class PRMHeader {

    public string RegisterUrl{set;get;}
     Public PRMHeader(){
         RegisterUrl = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox? Label.PartnerHeaderRegistrationLink_QA : Label.PartnerHeaderRegistrationLink_Prod;
     }
}