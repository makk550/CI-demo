public class SAPUpgradeRenewalPayload {

    public Static SAPRequestPayloadutility.QuoteHeaderDetails HEADER_DETAILS = new SAPRequestPayloadutility.QuoteHeaderDetails();
    public Static SAPRequestPayloadutility.BillPlanDetails BILLPLAN_DETAILS = new SAPRequestPayloadutility.BillPlanDetails();
    public Static SAPRequestPayloadutility.QuoteIteamDetails ITEM_DETAILS = new SAPRequestPayloadutility.QuoteIteamDetails();
    public Static SAPRequestPayloadutility.QuotePricingDetails PRICING_DETAILS = new SAPRequestPayloadutility.QuotePricingDetails();
    public Static SAPRequestPayloadutility.QuoteVariantConfigDetails VARIANT_CONFIG_DETAILS = new SAPRequestPayloadutility.QuoteVariantConfigDetails();
    public Static SAPRequestPayloadutility.SalesText  SALES_TEXT=new SAPRequestPayloadutility.SalesText();
    Public Static Map < string, SBQQ__QuoteLine__c > parentQuoteLineMap = new Map < String, SBQQ__QuoteLine__c > ();
    public static Map < String, SBQQ__QuoteLine__c > vCdetailMap = new Map < String, SBQQ__QuoteLine__c > ();
    public static List < SBQQ__QuoteLine__c > midYearUpgradeList = new List < SBQQ__QuoteLine__c > ();
    public Static List < SBQQ__QuoteLine__c > UEnetTotalList = new List < SBQQ__QuoteLine__c > ();

    public static Decimal AcnulLicenceamount = 0.00;
    public static Decimal Acnuladditionaldismount = 0.00;
    public static Decimal AcnulLicenettotal = 0.00;

    public static Decimal AcnulLicenceamountMaint = 0.00;
    public static Decimal AcnuladditionaldismountMaint = 0.00;
    public static Decimal AcnulLicenettotalMaint = 0.00;

    public static Decimal AcnsvrLicenceamount = 0.00;
    public static Decimal Acnsvradditionaldismount = 0.00;
    public static Decimal AcnsvrLicenettotal = 0.00;

    public static Decimal AcnsvrLicenceamountMaint = 0.00;
    public static Decimal AcnsvradditionaldismountMaint = 0.00;
    public static Decimal AcnsvrLicenettotalMaint = 0.00;

    JSONGenerator g = JSON.createGenerator(false);


    public string requestDataforUpgRenewal(SBQQ__Quote__c sQuote) {
        String jsons = '';
        String replaceString;

        if (sQuote != null) {

            for (SBQQ__QuoteLine__c sqline: sQuote.SBQQ__LineItems__r) {
                parentQuoteLineMap.put(sqline.Name, sqline);

                if (sqline.Maintenance_Product__c == 'Yes') {
                    vCdetailMap.put(sqline.Maintenance_Parent_Quote_Line__c, sqline);
                }


            }

            for (SBQQ__QuoteLine__c sqline: sQuote.SBQQ__LineItems__r) {

                if (sqline.Quote_Type__C == 'Renewal' && sqline.CA_License_Type__c != null && sqline.SBQQ__ProductCode__c != null && (sqline.CA_License_Type__c.subString(0, 1) == 'p') && (sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990') || (sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNSVR990') && sqline.SBQQ__NetTotal__c != 0) || sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUE990'))) {

                    midYearUpgradeList.add(sqline);

                }


            }

            for (SBQQ__QuoteLine__c sqline: midYearUpgradeList) {

                if (sqline.SBQQ__ProductCode__c != null && (sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990'))) {

                    UEnetTotalList.add(sqline);

                }

                if (sqline.SBQQ__ProductCode__c != null && (sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNSVR990'))) {
                    UEnetTotalList.add(sqline);

                }

            }



            for (SBQQ__QuoteLine__c squoteLine: UEnetTotalList) {

                if (squoteLine.SBQQ__ProductCode__c == 'ACNUNL990') {
                   if(squoteLine.ELP_Total__c!=null)
                    AcnulLicenceamount += squoteLine.ELP_Total__c;
                    AcnulLicenettotal += squoteLine.SBQQ__NetTotal__c;
                    if (squoteLine.SBQQ__Discount__c != null)
                     Acnuladditionaldismount = squoteLine.SBQQ__Discount__c;


                }
                if (squoteLine.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990') && squoteLine.Maintenance_Product__c == 'Yes') {
                    AcnulLicenettotalMaint += squoteLine.SBQQ__NetTotal__c;
                    if (squoteLine.SBQQ__Discount__c != null)
                        AcnuladditionaldismountMaint += squoteLine.SBQQ__Discount__c;
                    if(squoteLine.Extended_List_Price_Maint_Product__c!=null)
                       AcnulLicenceamountMaint += squoteLine.Extended_List_Price_Maint_Product__c;

                }

                if (squoteLine.SBQQ__ProductCode__c == 'ACNSVR990' && squoteLine.SBQQ__NetTotal__c != 0) {
                   if(squoteLine.ELP_Total__c!=null)
                      AcnsvrLicenceamount += squoteLine.ELP_Total__c;
                    if (squoteLine.SBQQ__Discount__c != null)
                        Acnsvradditionaldismount += squoteLine.SBQQ__Discount__c;
                    AcnsvrLicenettotal += squoteLine.SBQQ__NetTotal__c;

                }


                if (squoteLine.SBQQ__ProductCode__c.containsIgnoreCase('ACNSVR990') && squoteLine.SBQQ__NetTotal__c != 0 && squoteLine.Maintenance_Product__c == 'Yes') { // UEtotalACULTE990+=squoteine.SBQQ__NetTotal__c; 
                    If(squoteLine.Extended_List_Price_Maint_Product__c!=null)
                     AcnsvrLicenceamountMaint += squoteLine.Extended_List_Price_Maint_Product__c;
                    if (squoteLine.SBQQ__Discount__c != null)
                        AcnsvradditionaldismountMaint += squoteLine.SBQQ__Discount__c;
                    AcnsvrLicenettotalMaint += squoteLine.SBQQ__NetTotal__c;

                }


            }

            HEADER_DETAILS = SAPRequestPayloadutility.quoteHeaderLevelDetails(sQuote, midYearUpgradeList);
            BILLPLAN_DETAILS = SAPRequestPayloadutility.billPlanDetails(sQuote.Payment_Plans__r);
            PRICING_DETAILS = quotePricingDetails(sQuote, midYearUpgradeList);
            ITEM_DETAILS = SAPRequestPayloadutility.quoteIteamDetails(midYearUpgradeList);
            VARIANT_CONFIG_DETAILS = quoteVarianConfigDetails(midYearUpgradeList);
             SALES_TEXT=SAPRequestPayloadutility.quoteSalesText(sQuote);
            g.writeStartObject();
            g.writeObjectField('HEADER_DETAILS', HEADER_DETAILS);
            g.writeObjectField('BILLPLAN_DETAILS', BILLPLAN_DETAILS);
            g.writeObjectField('ITEM_DETAILS', ITEM_DETAILS);
            g.writeObjectField('PRICING_DETAILS', PRICING_DETAILS);
            g.writeObjectField('VARIANT_CONFIG_DETAILS', VARIANT_CONFIG_DETAILS);
            g.writeObjectField('SALES_TEXT', SALES_TEXT);

            g.writeEndObject();
            jsons = g.getAsString();
            replaceString = jsons.replace('null', '""');

        }


        return replaceString;

    }







    public static SAPRequestPayloadutility.QuotePricingDetails quotePricingDetails(SBQQ__Quote__c squote, List < SBQQ__QuoteLine__c > squoteLines) {

        String MainainceLineNumber;

        List < Object > quotePricingInf = new List < Object > ();
        SAPRequestPayloadutility.QuotePricingDetails qpriceDetail = new SAPRequestPayloadutility.QuotePricingDetails();
        Map < String, SBQQ__QuoteLine__c > mapquoteLine = new Map < String, SBQQ__QuoteLine__c > ();
        Set < string > mainaincesku = new set < string > ();
        if (squoteLines != null) {
            for (SBQQ__QuoteLine__c quotLin: squoteLines) {
                if (quotLin.CA_License_Type__c == 'Perpetual') {
                    quotLin.CA_License_Type__c = 'P';

                } else if (quotLin.CA_License_Type__c == 'Subscription') {
                    quotLin.CA_License_Type__c = 'S';

                }
                if (quotLin.CA_License_Type__c == 'P' && quotLin.Quote_Type__c == 'Renewal' && quotLin.Maintenance_Product__c != 'Yes' && quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUE990')) {
                    mapquoteLine.put(quotLin.SBQQ__ProductCode__c, quotLin);

                }



            }
            if (mapquoteLine.size() > 0) {
                MainainceLineNumber = mapquoteLine.get('ACEEUE990').name.remove('QL-');
            }

            Integer maintNumtime = 0;
            for (SBQQ__QuoteLine__c quotLin: squoteLines) {
                System.debug('-----------enterloop');
                if (quotLin.SBQQ__ProductCode__c != null) {
                    System.debug('==========enterproduct');
                    if (quotLin.CA_License_Type__c == 'Perpetual') {
                        quotLin.CA_License_Type__c = 'P';

                    } else if (quotLin.CA_License_Type__c == 'Subscription') {
                        quotLin.CA_License_Type__c = 'S';

                    }



                    if (quotLin.CA_License_Type__c == 'P' && quotLin.Quote_Type__c == 'Renewal' && quotLin.Maintenance_Product__c != 'Yes' && quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')) {

                        String LineNumber = quotLin.Name.remove('QL-');
                        SAPRequestPayloadutility.ListPriceValues listPric = new SAPRequestPayloadutility.ListPriceValues();
                        listPric.LINE_NUMBER = String.ValueOf(LineNumber);
                        listPric.NAME = 'LIST_PRICE';
                        listPric.VALUE = String.valueOf(AcnulLicenceamount);
                        //listPric.VALUE=String.valueOf(0);
                        quotePricingInf.add(listPric);
                        SAPRequestPayloadutility.List_DiscountAmount listdiscount = new SAPRequestPayloadutility.List_DiscountAmount();
                        listdiscount.LINE_NUMBER = String.ValueOf(LineNumber);
                        listdiscount.NAME = 'LICENSE_DISC_AMOUNT';
                        listdiscount.VALUE = '100';
                        //listdiscount.VALUE=String.ValueOf(0);
                        quotePricingInf.add(listdiscount);
                        SAPRequestPayloadutility.Licence_Price licencePrice = new SAPRequestPayloadutility.Licence_Price();
                        licencePrice.LINE_NUMBER = String.ValueOf(LineNumber);
                        licencePrice.NAME = 'LICENSE_PRICE';
                        licencePrice.VALUE = String.valueOf(0); //
                        quotePricingInf.add(licencePrice);
                        SAPRequestPayloadutility.CA_LICENSECERT calicen = new SAPRequestPayloadutility.CA_LICENSECERT();
                        calicen.LINE_NUMBER = String.ValueOf(LineNumber);
                        calicen.NAME = 'CA_LICENSE_CERT';
                        calicen.VALUE = String.valueOf(quotLin.CA_License_Cert__c);
                        quotePricingInf.add(calicen);

                    }

                    if (quotLin.CA_License_Type__c == 'P' && quotLin.Quote_Type__c == 'Renewal' && quotLin.Maintenance_Product__c != 'Yes' && quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUE990')) {
                        String LineNumber = quotLin.Name.remove('QL-');
                        SAPRequestPayloadutility.ListPriceValues listPric = new SAPRequestPayloadutility.ListPriceValues();
                        listPric.LINE_NUMBER = String.ValueOf(LineNumber);
                        listPric.NAME = 'LIST_PRICE';
                        listPric.VALUE = String.valueOf(AcnulLicenceamount);
                        quotePricingInf.add(listPric);
                        SAPRequestPayloadutility.List_DiscountAmount listdiscount = new SAPRequestPayloadutility.List_DiscountAmount();
                        listdiscount.LINE_NUMBER = String.ValueOf(LineNumber);
                        listdiscount.NAME = 'LICENSE_DISC_AMOUNT';
                        listdiscount.VALUE = String.ValueOf(Acnuladditionaldismount);
                        quotePricingInf.add(listdiscount);
                        SAPRequestPayloadutility.Licence_Price licencePrice = new SAPRequestPayloadutility.Licence_Price();
                        licencePrice.LINE_NUMBER = String.ValueOf(LineNumber);
                        licencePrice.NAME = 'LICENSE_PRICE';
                        licencePrice.VALUE = String.valueOf(AcnulLicenettotal); //squote.SBQQ__NetAmount__c
                        quotePricingInf.add(licencePrice);
                        SAPRequestPayloadutility.CA_LICENSECERT calicen = new SAPRequestPayloadutility.CA_LICENSECERT();
                        calicen.LINE_NUMBER = String.ValueOf(LineNumber);
                        calicen.NAME = 'CA_LICENSE_CERT';
                        calicen.VALUE = String.valueOf(quotLin.CA_License_Cert__c);
                        quotePricingInf.add(calicen);

                    }

                    if (quotLin.CA_License_Type__c == 'P' && quotLin.Quote_Type__c == 'Renewal' && quotLin.Maintenance_Product__c == 'Yes' && quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')) {
                        SBQQ__QuoteLine__c qutelin = parentQuoteLineMap.get(quotLin.Maintenance_Parent_Quote_Line__c);
                        String LineNumber = qutelin.name.remove('QL-');
                        SAPRequestPayloadutility.List_Maintaince listMaintaince = new SAPRequestPayloadutility.List_Maintaince();
                        listMaintaince.LINE_NUMBER = String.ValueOf(LineNumber);
                        listMaintaince.NAME = 'LIST_MAINTENANCE';
                        listMaintaince.VALUE = String.valueOf(AcnulLicenceamountMaint);
                        quotePricingInf.add(listMaintaince);
                        SAPRequestPayloadutility.Maintain_Discount_Amount maintainDisc_Amount = new SAPRequestPayloadutility.Maintain_Discount_Amount();
                        maintainDisc_Amount.LINE_NUMBER = String.ValueOf(LineNumber);
                        maintainDisc_Amount.NAME = 'RENEWAL_DISC_AMT';
                        maintainDisc_Amount.VALUE = String.valueOf(100);
                        quotePricingInf.add(maintainDisc_Amount);
                        SAPRequestPayloadutility.Maintains_Price maintPrice = new SAPRequestPayloadutility.Maintains_Price();
                        maintPrice.LINE_NUMBER = String.ValueOf(LineNumber);
                        maintPrice.NAME = 'MAINTENANCE_PRICE';
                        maintPrice.VALUE = String.ValueOf(0);
                        quotePricingInf.add(maintPrice);
                        SAPRequestPayloadutility.CA_LICENSECERT calicen = new SAPRequestPayloadutility.CA_LICENSECERT();
                        calicen.LINE_NUMBER = String.ValueOf(LineNumber);
                        calicen.NAME = 'CA_LICENSE_CERT';
                        calicen.VALUE = String.valueOf(quotLin.CA_License_Cert__c);
                        quotePricingInf.add(calicen);
                    }

                    if (quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990') && quotLin.CA_License_Type__c == 'P' && quotLin.Quote_Type__c == 'Renewal' && quotLin.Maintenance_Product__c == 'Yes' && maintNumtime == 0) {
                        maintNumtime = 1;
                        SAPRequestPayloadutility.List_Maintaince listMaintaince = new SAPRequestPayloadutility.List_Maintaince();
                        listMaintaince.LINE_NUMBER = String.ValueOf(MainainceLineNumber);
                        listMaintaince.NAME = 'LIST_MAINTENANCE';
                        listMaintaince.VALUE = String.valueOf(AcnulLicenceamountMaint);
                        quotePricingInf.add(listMaintaince);
                        SAPRequestPayloadutility.Maintain_Discount_Amount maintainDisc_Amount = new SAPRequestPayloadutility.Maintain_Discount_Amount();
                        maintainDisc_Amount.LINE_NUMBER = String.ValueOf(MainainceLineNumber);
                        maintainDisc_Amount.NAME = 'RENEWAL_DISC_AMT';
                        maintainDisc_Amount.VALUE = String.valueOf(AcnuladditionaldismountMaint);
                        quotePricingInf.add(maintainDisc_Amount);
                        SAPRequestPayloadutility.Maintains_Price maintPrice = new SAPRequestPayloadutility.Maintains_Price();
                        maintPrice.LINE_NUMBER = String.ValueOf(MainainceLineNumber);
                        maintPrice.NAME = 'MAINTENANCE_PRICE';
                        maintPrice.VALUE = String.ValueOf(AcnulLicenettotalMaint);
                        quotePricingInf.add(maintPrice);
                        SAPRequestPayloadutility.CA_LICENSECERT calicen = new SAPRequestPayloadutility.CA_LICENSECERT();
                        calicen.LINE_NUMBER = String.ValueOf(MainainceLineNumber);
                        calicen.NAME = 'CA_LICENSE_CERT';
                        calicen.VALUE = String.valueOf(quotLin.CA_License_Cert__c);
                        quotePricingInf.add(calicen);
                    }


                    if (quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACNSVR990') && quotLin.SBQQ__NetTotal__c != 0 && quotLin.Maintenance_Product__c == 'Yes') {
                        SBQQ__QuoteLine__c qutelin = parentQuoteLineMap.get(quotLin.Maintenance_Parent_Quote_Line__c);
                        String LineNumber = qutelin.name.remove('QL-');
                        SAPRequestPayloadutility.List_Maintaince listMaintaince = new SAPRequestPayloadutility.List_Maintaince();
                        listMaintaince.LINE_NUMBER = String.ValueOf(LineNumber);
                        listMaintaince.NAME = 'LIST_MAINTENANCE';
                        listMaintaince.VALUE = String.valueOf(AcnsvrLicenceamountMaint);
                        quotePricingInf.add(listMaintaince);
                        SAPRequestPayloadutility.Maintain_Discount_Amount maintainDisc_Amount = new SAPRequestPayloadutility.Maintain_Discount_Amount();
                        maintainDisc_Amount.LINE_NUMBER = String.ValueOf(LineNumber);
                        maintainDisc_Amount.NAME = 'RENEWAL_DISC_AMT';
                        maintainDisc_Amount.VALUE = String.valueOf(AcnsvradditionaldismountMaint);
                        quotePricingInf.add(maintainDisc_Amount);
                        SAPRequestPayloadutility.Maintains_Price maintPrice = new SAPRequestPayloadutility.Maintains_Price();
                        maintPrice.LINE_NUMBER = String.ValueOf(LineNumber);
                        maintPrice.NAME = 'MAINTENANCE_PRICE';
                        maintPrice.VALUE = String.ValueOf(AcnsvrLicenettotalMaint);
                        quotePricingInf.add(maintPrice);
                        SAPRequestPayloadutility.CA_LICENSECERT calicen = new SAPRequestPayloadutility.CA_LICENSECERT();
                        calicen.LINE_NUMBER = String.ValueOf(LineNumber);
                        calicen.NAME = 'CA_LICENSE_CERT';
                        calicen.VALUE = String.valueOf(quotLin.CA_License_Cert__c);
                        quotePricingInf.add(calicen);

                    }


                }
                System.debug('==========quotePricingInf====' + quotePricingInf);

            }
            qpriceDetail.row = quotePricingInf;
        }
        return qpriceDetail;
    }
    public static SAPRequestPayloadutility.QuoteVariantConfigDetails quoteVarianConfigDetails(List < SBQQ__QuoteLine__c > sbqLines) {
        List < Object > varianList = new List < Object > ();
        Decimal ACEEUE990Quantity = 0;


        for (SBQQ__QuoteLine__c quoteLine: sbqLines) {
            if (quoteLine.SBQQ__ProductCode__c != null && quoteLine.Maintenance_Product__c != 'Yes') {

                String LineNumber = quoteLine.Name.remove('QL-');


                if (quoteLine.SBQQ__ProductCode__c == 'ACNUNL990' || quoteLine.SBQQ__ProductCode__c == 'ACEEUE990')
                    ACEEUE990Quantity = quoteLine.SBQQ__EffectiveQuantity__c;


                if (quoteLine.SAP_Operating_System__c != null && quoteLine.SAP_Operating_System__c != 'nce') {
                    SAPRequestPayloadutility.ZZOpsys zzops = new SAPRequestPayloadutility.ZZOpsys();
                    zzops.LINE_NUMBER = string.valueOf(LineNumber);
                    zzops.NAME = 'OPERATING_SYSTEM_ORDERABLE';
                    zzops.VALUE = quoteLine.SAP_Operating_System__c;
                    varianList.add(zzops);
                }
                if (quoteLine.CA_License_Type__c != null) {
                    SAPRequestPayloadutility.ZZLICTYPE zzLiceType = new SAPRequestPayloadutility.ZZLICTYPE();
                    zzLiceType.LINE_NUMBER = string.valueOf(LineNumber);
                    zzLiceType.NAME = 'LICENSE_TYPE';
                    zzLiceType.VALUE = quoteLine.CA_License_Type__c.subString(0, 1);
                    varianList.add(zzLiceType);
                }
                SBQQ__QuoteLine__c vcquoteMaint = vCdetailMap.get(quoteLine.Name);
                System.debug('=======vcquoteMaint====' + vcquoteMaint);
                if (vcquoteMaint != null) {
                    SAPRequestPayloadutility.ZZMAINT zzMaint = new SAPRequestPayloadutility.ZZMAINT();
                    zzMaint.LINE_NUMBER = string.valueOf(LineNumber);
                    zzMaint.NAME = 'MAINTENANCE';
                    zzMaint.VALUE = vcquoteMaint.Maintenance_SAP__c;
                    varianList.add(zzMaint);
                } else if (quoteLine.Maintenance_SAP__c != '0') {
                    SAPRequestPayloadutility.ZZMAINT zzMaint = new SAPRequestPayloadutility.ZZMAINT();
                    zzMaint.LINE_NUMBER = string.valueOf(LineNumber);
                    zzMaint.NAME = 'MAINTENANCE';
                    zzMaint.VALUE = quoteLine.Maintenance_SAP__c;
                    varianList.add(zzMaint);
                }
                if (quoteLine.Business_Transaction_Type_SAP__c != null) {
                    SAPRequestPayloadutility.ZZBUSTYPE zzbustype = new SAPRequestPayloadutility.ZZBUSTYPE();
                    zzbustype.LINE_NUMBER = string.valueOf(LineNumber);
                    zzbustype.NAME = 'BUSINESS_TRANSACTION_TYPE';
                    zzbustype.VALUE = quoteLine.Business_Transaction_Type_SAP__c.subString(0, 1);
                    varianList.add(zzbustype);
                }
                System.debug('quoteLine.Auth_Use_Mode__c======' + quoteLine.Auth_Use_Mode__c);
                if (quoteLine.Auth_Use_Mode__c != null) {
                    SAPRequestPayloadutility.ZZAUTHUSEMDL zzAuthmdl = new SAPRequestPayloadutility.ZZAUTHUSEMDL();
                    zzAuthmdl.LINE_NUMBER = string.valueOf(LineNumber);
                    zzAuthmdl.NAME = 'AUTHORIZED_USE_MODEL';
                    zzAuthmdl.VALUE = quoteLine.Auth_Use_Mode__c.subString(0, 1);
                    varianList.add(zzAuthmdl);
                }
                System.debug('========quoteLine.SBQQ__EffectiveQuantity__c' + quoteLine.SBQQ__EffectiveQuantity__c);
                if (quoteLine.SBQQ__EffectiveQuantity__c != null && quoteLine.SBQQ__ProductCode__c == 'ACEEUE990') {
                    SAPRequestPayloadutility.ZZLICINST zzLicnt = new SAPRequestPayloadutility.ZZLICINST();
                    zzLicnt.LINE_NUMBER = string.valueOf(LineNumber);
                    zzLicnt.NAME = 'LICENSED_QUANTITY';
                    zzLicnt.VALUE = String.valueOf(ACEEUE990Quantity);
                    varianList.add(zzLicnt);

                } else if (quoteLine.SBQQ__EffectiveQuantity__c != null) {
                    SAPRequestPayloadutility.ZZLICINST zzLicnt = new SAPRequestPayloadutility.ZZLICINST();
                    zzLicnt.LINE_NUMBER = string.valueOf(LineNumber);
                    zzLicnt.NAME = 'LICENSED_QUANTITY';
                    zzLicnt.VALUE = String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                    varianList.add(zzLicnt);



                }


                if (quoteLine.Quantity_Distributed_Capacity__c != null) {
                    SAPRequestPayloadutility.ZZADDINST zzadd = new SAPRequestPayloadutility.ZZADDINST();
                    zzadd.LINE_NUMBER = string.valueOf(LineNumber);
                    zzadd.NAME = 'ADDITIONAL_INSTANCES';
                    zzadd.VALUE = String.valueOf(quoteLine.Quantity_Distributed_Capacity__c);
                    varianList.add(zzadd);
                }
                System.debug('quoteLine.Auth_Use_Mode__c======' + quoteLine.Upgrade_SAP__c);
                if (quoteLine.Upgrade_SAP__c != null) {
                    SAPRequestPayloadutility.ZZUpgradte zzupgrade = new SAPRequestPayloadutility.ZZUpgradte();
                    zzupgrade.LINE_NUMBER = string.valueOf(LineNumber);
                    zzupgrade.NAME = 'UPGRADE_RENEWAL';
                    zzupgrade.VALUE = quoteLine.Upgrade_SAP__c;
                    varianList.add(zzupgrade);
                }



            }


        }

        SAPRequestPayloadutility.QuoteVariantConfigDetails quotevarit = new SAPRequestPayloadutility.QuoteVariantConfigDetails();
        quotevarit.row = varianList;
        return quotevarit;
    }



}