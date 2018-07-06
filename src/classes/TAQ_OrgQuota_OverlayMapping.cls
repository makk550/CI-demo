public with sharing class TAQ_OrgQuota_OverlayMapping {
     
       public void Org_Approved_overlayMapping(List<TAQ_Org_Quota_Approved__c> TAQList){
         set<String> region = new Set<String>();
         set<String> area = new Set<String>();
         set<String> country = new Set<String>();
         Set<String> territory_country = new Set<String>();
         Set<String> bu = new Set<String>();
         Set<String> quotatype = new Set<String>();
         Set<String> quotasegment = new Set<String>();
         Set<String> plantype = new Set<String>();
         
         for(TAQ_Org_Quota_Approved__c t: TAQList){
             
             if(t.Area__c!= null){
                if(t.Area__c.contains(';'))
                    for(String s: t.Area__c.split(';',0))
                      area.add(s);
                else
                    area.add(t.Area__c);                 
             }
             
             if(t.Country__c!= null){
                if(t.country__c.contains(';'))
                    for(String s: t.country__c.split(';',0))
                      country.add(s);
                else
                    country.add(t.country__c);
                
             }
            if(t.Territory_Country__c != null){
                 if(t.territory_country__c.contains(';'))
                    for(String s: t.territory_country__c.split(';',0))
                      territory_country.add(s);
                 else
                    territory_country.add(t.territory_country__c);
            }
            if(t.Account_Segment__c != null){
                 if(t.Account_Segment__c.contains(';'))
                    for(String s: t.Account_Segment__c.split(';',0))
                      quotasegment.add(s);
                 else
                    quotasegment.add(t.Account_Segment__c);
            }   
            region.add(t.region__c);
            bu.add(t.CSU_BU__c);
            quotatype.add(t.Quota_Type__c);
            plantype.add(t.Plan_Type__c);
         }
        
        string plantrypestring = '';
        for(string strplan: plantype)
        {
                    plantrypestring += (plantrypestring == ''?'':';');
                    plantrypestring +=   strplan ;
        }
        
        string areastring = '';
        for(string strplan: area)
        {
                    areastring += (areastring == ''?'':';');
                    areastring +=  strplan;
        }
        
            /* System.debug('______REGION_____'+region);
                    System.debug('______AREA_____'+area);
                    System.debug('______TERRITORY_____'+territory_country);
                    System.debug('______COUNTRY_____'+country);
                    System.debug('______PLAN TYPE_____'+plantrypestring);
                    System.debug('______SEGMENT_____'+quotasegment);
                    System.debug('______BU_____'+bu);
                    System.debug('______QUOTA TYPE_____'+quotatype);
         */
                 //Key would be Region |  Quota Type , value would be the list of overlay codes related   to the set of region and quota type                                                   
                                                               
         Map<string, list<Overlay_codes__c>> mapOverlay = new map<string,List<Overlay_codes__c>>();
                    
         for( Overlay_codes__c oc:    [Select Id, Quota_Region__c,Quota_Area__c,Quota_Country__c,Quota_Type__c, Quota_Territory_Country__c, Quota_BU__c, Plan_Type__c,Quota_Segment__c,Name From Overlay_Codes__c 
                                                       WHERE (Quota_Region__c in: region OR Quota_Region__c = NULL) and
                                                            // (Quota_Area__c in: area OR Quota_Area__c =: areastring  OR Quota_Area__c = NULL)  and
                                                           //  (Quota_Country__c in: country OR Quota_Country__c = NULL) and
                                                          //   ((Quota_Territory_Country__c in: territory_country) OR (Quota_Territory_Country__c = NULL)) and
                                                          //   (Quota_BU__c in: bu OR Quota_BU__c = NULL)  and 
                                                             (Quota_Type__c in: quotatype OR Quota_Type__c = NULL) //and
                                                          //  (Plan_Type__c includes (:plantrypestring) OR Plan_Type__c = NULL)// and
                                                          //   (Quota_Segment__c in: quotasegment OR Quota_Segment__c = NULL) 
                                                      ORDER BY Quota_Region__c DESC NULLS LAST,
                                                               Quota_Area__c DESC NULLS LAST,
                                                               Quota_Territory_Country__c DESC NULLS LAST,
                                                               Quota_Country__c DESC NULLS LAST,                                                               
                                                               Quota_BU__c DESC NULLS LAST,
                                                               Quota_Type__c DESC NULLS LAST,
                                                               Segment_Formula__c DESC NULLS LAST])
         {
         
         
            if(oc.Quota_Region__c!=null && oc.Quota_Type__c!= null)
            {
              List<Overlay_codes__c> overlaycodes= mapOverlay.get( oc.Quota_Region__c.toUpperCase()+ '|' + oc.Quota_Type__c.toUpperCase());
              if(overlaycodes == null) overlaycodes = new List<Overlay_codes__c>();
              
              overlaycodes.add(oc);
              mapOverlay.put( oc.Quota_Region__c.toUpperCase()+ '|' + oc.Quota_Type__c.toUpperCase(),overlaycodes);
            }
         
         }                                                      
                                                               
                                                               

                                    
           
         for(TAQ_Org_Quota_Approved__c t: TAQList){
                t.Overlay_Code__c = NULL;
                Boolean overlayassigned = false;
                if(t.Region__c == null || t.Quota_Type__c == null)
                    continue;
                List<Overlay_codes__c> overlaycodes= mapOverlay.get( t.Region__c.toUpperCase()+ '|' + t.Quota_Type__c.toUpperCase());
                System.debug('overlaycodes'+overlaycodes);
                if( overlaycodes <> null)
                   for(Overlay_Codes__c o: overlaycodes){
                   
                    
               /*   System.debug('______REGION_____'+o.Quota_Region__c);
                    System.debug('______AREA_____'+o.Quota_Area__c);
                    System.debug('______TERRITORY_____'+o.Quota_Territory_Country__c);
                    System.debug('______COUNTRY_____'+o.Quota_Country__c);
                    System.debug('______PLAN TYPE_____'+o.Plan_Type__c);
                    System.debug('______SEGMENT_____'+o.Quota_Segment__c);
                    System.debug('______BU_____'+o.Quota_BU__c);
                    System.debug('______QUOTA TYPE_____'+o.Quota_Type__c);
               */     
                    String qcr = o.Quota_Region__c == null?'NULL':O.Quota_Region__c;
                    String qca = o.Quota_Area__c == null?'NULL':O.Quota_Area__c;
                    String qc = o.Quota_Country__c == null?'NULL':O.Quota_Country__c;
                    String qtc = o.Quota_Territory_Country__c == null?'NULL':O.Quota_Territory_Country__c;
                    String qbu = o.Quota_BU__c == null?'NULL':O.Quota_BU__c;
                    String qt = o.Quota_Type__c == null?'NULL':O.Quota_Type__c;
                    String qs = o.Quota_Segment__c == null?'NULL':O.Quota_Segment__c;
                    String pt_oc = o.Plan_Type__c == null?'NULL':o.Plan_Type__c;
                    
                    String tcr = t.Region__c == null?'NULL':t.Region__c;
                    String tca = t.Area__c == null?'NULL':t.Area__c;
                    String tc = t.Country__c == null?'NULL':t.Country__c;
                    String ttc = t.territory_Country__c == null?'NULL':t.territory_Country__c;
                    String tbu = t.CSU_BU__c == null?'NULL':t.CSU_BU__c;
                    String tt = t.Quota_Type__c == null?'NULL':t.Quota_Type__c;
                    String ts = t.Account_Segment__c == null?'NULL':t.Account_Segment__c;
                    String pt_qta = t.Plan_Type__c == null?'NULL':t.Plan_Type__c;
                    
                     
                  if(!overlayassigned && 
                         ((tcr.equals(qcr) /* || o.Quota_Region__c == NULL*/) &&
                         (tca.equals(qca)/* || o.Quota_Area__c == NULL*/)   &&
                         (ttc.contains(qtc)/* || o.Quota_Territory_Country__c == NULL*/) &&
                         (tc.contains(qc)  /* || o.Quota_Country__c == NULL*/) &&
                         (pt_oc.contains(pt_qta)) &&
                         (ts.equals(qs)      || o.Quota_Segment__c == NULL) &&
                         (tbu.equals(qbu)  /* || o.Quota_BU__c == NULL*/) &&
                         (tt.equals(qt)    /* || o.Quota_Type__c == NULL*/))){
                            t.Overlay_Code__c = o.Name;
                            overlayassigned = true;
                            System.debug('tca.equals(qca)'+tca+qca+tca.contains(qca));
                            break;
                       }
                       
                }
         } 
   
     }
     
}