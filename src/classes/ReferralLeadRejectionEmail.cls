public class ReferralLeadRejectionEmail {
    @InvocableMethod    
    public static void sendEmailNotification(List<ID> Leadidlist){
        List<Lead> EmailLeadList=[select id,Status,Referral_Partner__r.email,Referral_Partner__c from Lead where id in :Leadidlist];
        System.debug('EmailLeadList' +EmailLeadList[0].Referral_Partner__c);
        String Referral_LeadCC = Label.Referral_Lead_additonal_reciepants;
        String[] arrCCList = Referral_LeadCC.split(';');
        //List<Id>  
       List<Messaging.SingleEmailMessage> allemails = new List<Messaging.SingleEmailMessage>();
        for(Lead leadid:EmailLeadList){
            if(leadid.Status == 'Rejected'){
                Messaging.singleEmailMessage emailRequestNA = new Messaging.singleEmailMessage();
                emailRequestNA.setUseSignature(false);
                emailRequestNA.setTemplateId(Label.Referral_Lead_Reject_email);
                emailRequestNA.setTargetObjectId(leadid.Referral_Partner__c);
                emailRequestNA.setWhatId(leadid.Id);
                emailRequestNA.saveAsActivity = false;
                if(arrCCList.size() > 0){
                    emailRequestNA.setCcAddresses(arrCCList);
                }
                
                emailRequestNA.setSenderDisplayName('CApartners@ca.com');
                allemails.add(emailRequestNA);
            }
        }
        if(!test.isrunningtest())
        {
       			Messaging.SendEmailResult [] emailResultNA =  Messaging.sendEmail(allemails);
        }
    }

}