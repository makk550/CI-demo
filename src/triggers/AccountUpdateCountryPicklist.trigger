trigger AccountUpdateCountryPicklist on Account (before insert, before update) 
{
     if(SystemIdUtility.skipAccount == true)
        return;
     if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
integer i=0;
  for(Account acc: trigger.new)
    {
       if((trigger.isUpdate && (Trigger.old[i].Country_ISO_code__c != acc.Country_ISO_code__c) || trigger.isInsert))
       if(acc.Country_ISO_code__c != null && acc.Country_ISO_code__c != '' )
        {    
        
            if(acc.Country_ISO_code__c == 'AD') { acc.Country_Picklist__c = 'AD - ANDORRA'; }
            else if(acc.Country_ISO_code__c == 'AE') { acc.Country_Picklist__c = 'AE - UNITED ARAB EMIRATES'; }
            else if(acc.Country_ISO_code__c == 'AF') { acc.Country_Picklist__c = 'AF - AFGHANISTAN'; }
            else if(acc.Country_ISO_code__c == 'AG') { acc.Country_Picklist__c = 'AG - ANTIGUA AND BARBUDA'; }
            else if(acc.Country_ISO_code__c == 'AI') { acc.Country_Picklist__c = 'AI - ANGUILLA'; }
            else if(acc.Country_ISO_code__c == 'AL') { acc.Country_Picklist__c = 'AL - ALBANIA'; }
            else if(acc.Country_ISO_code__c == 'AM') { acc.Country_Picklist__c = 'AM - ARMENIA'; }
            else if(acc.Country_ISO_code__c == 'AN') { acc.Country_Picklist__c = 'AN - NETHERLANDS ANTILLES'; }
            else if(acc.Country_ISO_code__c == 'AO') { acc.Country_Picklist__c = 'AO - ANGOLA'; }
            else if(acc.Country_ISO_code__c == 'AQ') { acc.Country_Picklist__c = 'AQ - ANTARCTICA'; }
            else if(acc.Country_ISO_code__c == 'AR') { acc.Country_Picklist__c = 'AR - ARGENTINA'; }
            else if(acc.Country_ISO_code__c == 'AS') { acc.Country_Picklist__c = 'AS - AMERICAN SAMOA'; }
            else if(acc.Country_ISO_code__c == 'AT') { acc.Country_Picklist__c = 'AT - AUSTRIA'; }
            else if(acc.Country_ISO_code__c == 'AU') { acc.Country_Picklist__c = 'AU - AUSTRALIA'; }
            else if(acc.Country_ISO_code__c == 'AW') { acc.Country_Picklist__c = 'AW - ARUBA'; }
            else if(acc.Country_ISO_code__c == 'AX') { acc.Country_Picklist__c = 'AX - ÅLAND ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'AZ') { acc.Country_Picklist__c = 'AZ - AZERBAIJAN'; }
            else if(acc.Country_ISO_code__c == 'BA') { acc.Country_Picklist__c = 'BA - BOSNIA AND HERZEGOVINA'; }
            else if(acc.Country_ISO_code__c == 'BB') { acc.Country_Picklist__c = 'BB - BARBADOS'; }
            else if(acc.Country_ISO_code__c == 'BD') { acc.Country_Picklist__c = 'BD - BANGLADESH'; }
            else if(acc.Country_ISO_code__c == 'BE') { acc.Country_Picklist__c = 'BE - BELGIUM'; }
            else if(acc.Country_ISO_code__c == 'BF') { acc.Country_Picklist__c = 'BF - BURKINA FASO'; }
            else if(acc.Country_ISO_code__c == 'BG') { acc.Country_Picklist__c = 'BG - BULGARIA'; }
            else if(acc.Country_ISO_code__c == 'BH') { acc.Country_Picklist__c = 'BH - BAHRAIN'; }
            else if(acc.Country_ISO_code__c == 'BI') { acc.Country_Picklist__c = 'BI - BURUNDI'; }
            else if(acc.Country_ISO_code__c == 'BJ') { acc.Country_Picklist__c = 'BJ - BENIN'; }
            else if(acc.Country_ISO_code__c == 'BL') { acc.Country_Picklist__c = 'BL - SAINT BARTHÉLEMY'; }
            else if(acc.Country_ISO_code__c == 'BM') { acc.Country_Picklist__c = 'BM - BERMUDA'; }
            else if(acc.Country_ISO_code__c == 'BN') { acc.Country_Picklist__c = 'BN - BRUNEI DARUSSALAM'; }
            else if(acc.Country_ISO_code__c == 'BO') { acc.Country_Picklist__c = 'BO - BOLIVIA'; }
            else if(acc.Country_ISO_code__c == 'BR') { acc.Country_Picklist__c = 'BR - BRAZIL'; }
            else if(acc.Country_ISO_code__c == 'BS') { acc.Country_Picklist__c = 'BS - BAHAMAS'; }
            else if(acc.Country_ISO_code__c == 'BT') { acc.Country_Picklist__c = 'BT - BHUTAN'; }
            else if(acc.Country_ISO_code__c == 'BV') { acc.Country_Picklist__c = 'BV - BOUVET ISLAND'; }
            else if(acc.Country_ISO_code__c == 'BW') { acc.Country_Picklist__c = 'BW - BOTSWANA'; }
            else if(acc.Country_ISO_code__c == 'BY') { acc.Country_Picklist__c = 'BY - BELARUS'; }
            else if(acc.Country_ISO_code__c == 'BZ') { acc.Country_Picklist__c = 'BZ - BELIZE'; }
            else if(acc.Country_ISO_code__c == 'CA') { acc.Country_Picklist__c = 'CA - CANADA'; }
            else if(acc.Country_ISO_code__c == 'CC') { acc.Country_Picklist__c = 'CC - COCOS (KEELING) ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'CD') { acc.Country_Picklist__c = 'CD - CONGO, THE DEMOCRATIC REPUBLIC OF THE'; }
            else if(acc.Country_ISO_code__c == 'CF') { acc.Country_Picklist__c = 'CF - CENTRAL AFRICAN REPUBLIC'; }
            else if(acc.Country_ISO_code__c == 'CG') { acc.Country_Picklist__c = 'CG - CONGO'; }
            else if(acc.Country_ISO_code__c == 'CH') { acc.Country_Picklist__c = 'CH - SWITZERLAND'; }
            else if(acc.Country_ISO_code__c == 'CI') { acc.Country_Picklist__c = 'CI - CÔTE D\'IVOIRE'; }
            else if(acc.Country_ISO_code__c == 'CK') { acc.Country_Picklist__c = 'CK - COOK ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'CL') { acc.Country_Picklist__c = 'CL - CHILE'; }
            else if(acc.Country_ISO_code__c == 'CM') { acc.Country_Picklist__c = 'CM - CAMEROON'; }
            else if(acc.Country_ISO_code__c == 'CN') { acc.Country_Picklist__c = 'CN - CHINA'; }
            else if(acc.Country_ISO_code__c == 'CO') { acc.Country_Picklist__c = 'CO - COLOMBIA'; }
            else if(acc.Country_ISO_code__c == 'CR') { acc.Country_Picklist__c = 'CR - COSTA RICA'; }
            else if(acc.Country_ISO_code__c == 'CU') { acc.Country_Picklist__c = 'CU - CUBA'; }
            else if(acc.Country_ISO_code__c == 'CV') { acc.Country_Picklist__c = 'CV - CAPE VERDE'; }
            else if(acc.Country_ISO_code__c == 'CW') { acc.Country_Picklist__c = 'CW - COURACAO'; }
            else if(acc.Country_ISO_code__c == 'CX') { acc.Country_Picklist__c = 'CX - CHRISTMAS ISLAND'; }
            else if(acc.Country_ISO_code__c == 'CY') { acc.Country_Picklist__c = 'CY - CYPRUS'; }
            else if(acc.Country_ISO_code__c == 'CZ') { acc.Country_Picklist__c = 'CZ - CZECH REPUBLIC'; }
            else if(acc.Country_ISO_code__c == 'DE') { acc.Country_Picklist__c = 'DE - GERMANY'; }
            else if(acc.Country_ISO_code__c == 'DJ') { acc.Country_Picklist__c = 'DJ - DJIBOUTI'; }
            else if(acc.Country_ISO_code__c == 'DK') { acc.Country_Picklist__c = 'DK - DENMARK'; }
            else if(acc.Country_ISO_code__c == 'DM') { acc.Country_Picklist__c = 'DM - DOMINICA'; }
            else if(acc.Country_ISO_code__c == 'DO') { acc.Country_Picklist__c = 'DO - DOMINICAN REPUBLIC'; }
            else if(acc.Country_ISO_code__c == 'DZ') { acc.Country_Picklist__c = 'DZ - ALGERIA'; }
            else if(acc.Country_ISO_code__c == 'EC') { acc.Country_Picklist__c = 'EC - ECUADOR'; }
            else if(acc.Country_ISO_code__c == 'EE') { acc.Country_Picklist__c = 'EE - ESTONIA'; }
            else if(acc.Country_ISO_code__c == 'EG') { acc.Country_Picklist__c = 'EG - EGYPT'; }
            else if(acc.Country_ISO_code__c == 'EH') { acc.Country_Picklist__c = 'EH - WESTERN SAHARA'; }
            else if(acc.Country_ISO_code__c == 'ER') { acc.Country_Picklist__c = 'ER - ERITREA'; }
            else if(acc.Country_ISO_code__c == 'ES') { acc.Country_Picklist__c = 'ES - SPAIN'; }
            else if(acc.Country_ISO_code__c == 'ET') { acc.Country_Picklist__c = 'ET - ETHIOPIA'; }
            else if(acc.Country_ISO_code__c == 'FI') { acc.Country_Picklist__c = 'FI - FINLAND'; }
            else if(acc.Country_ISO_code__c == 'FJ') { acc.Country_Picklist__c = 'FJ - FIJI'; }
            else if(acc.Country_ISO_code__c == 'FK') { acc.Country_Picklist__c = 'FK - FALKLAND ISLANDS (MALVINAS)'; }
            else if(acc.Country_ISO_code__c == 'FM') { acc.Country_Picklist__c = 'FM - MICRONESIA, FEDERATED STATES OF'; }
            else if(acc.Country_ISO_code__c == 'FO') { acc.Country_Picklist__c = 'FO - FAROE ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'FR') { acc.Country_Picklist__c = 'FR - FRANCE'; }
            else if(acc.Country_ISO_code__c == 'GA') { acc.Country_Picklist__c = 'GA - GABON'; }
            else if(acc.Country_ISO_code__c == 'GB') { acc.Country_Picklist__c = 'GB - UNITED KINGDOM'; }
            else if(acc.Country_ISO_code__c == 'GD') { acc.Country_Picklist__c = 'GD - GRENADA'; }
            else if(acc.Country_ISO_code__c == 'GE') { acc.Country_Picklist__c = 'GE - GEORGIA'; }
            else if(acc.Country_ISO_code__c == 'GF') { acc.Country_Picklist__c = 'GF - FRENCH GUIANA'; }
            else if(acc.Country_ISO_code__c == 'GG') { acc.Country_Picklist__c = 'GG - GUERNSEY'; }
            else if(acc.Country_ISO_code__c == 'GH') { acc.Country_Picklist__c = 'GH - GHANA'; }
            else if(acc.Country_ISO_code__c == 'GI') { acc.Country_Picklist__c = 'GI - GIBRALTAR'; }
            else if(acc.Country_ISO_code__c == 'GL') { acc.Country_Picklist__c = 'GL - GREENLAND'; }
            else if(acc.Country_ISO_code__c == 'GM') { acc.Country_Picklist__c = 'GM - GAMBIA'; }
            else if(acc.Country_ISO_code__c == 'GN') { acc.Country_Picklist__c = 'GN - GUINEA'; }
            else if(acc.Country_ISO_code__c == 'GP') { acc.Country_Picklist__c = 'GP - GUADELOUPE'; }
            else if(acc.Country_ISO_code__c == 'GQ') { acc.Country_Picklist__c = 'GQ - EQUATORIAL GUINEA'; }
            else if(acc.Country_ISO_code__c == 'GR') { acc.Country_Picklist__c = 'GR - GREECE'; }
            else if(acc.Country_ISO_code__c == 'GS') { acc.Country_Picklist__c = 'GS - SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'GT') { acc.Country_Picklist__c = 'GT - GUATEMALA'; }
            else if(acc.Country_ISO_code__c == 'GU') { acc.Country_Picklist__c = 'GU - GUAM'; }
            else if(acc.Country_ISO_code__c == 'GW') { acc.Country_Picklist__c = 'GW - GUINEA-BISSAU'; }
            else if(acc.Country_ISO_code__c == 'GY') { acc.Country_Picklist__c = 'GY - GUYANA'; }
            else if(acc.Country_ISO_code__c == 'HK') { acc.Country_Picklist__c = 'HK - HONG KONG'; }
            else if(acc.Country_ISO_code__c == 'HM') { acc.Country_Picklist__c = 'HM - HEARD ISLAND AND MCDONALD ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'HN') { acc.Country_Picklist__c = 'HN - HONDURAS'; }
            else if(acc.Country_ISO_code__c == 'HR') { acc.Country_Picklist__c = 'HR - CROATIA'; }
            else if(acc.Country_ISO_code__c == 'HT') { acc.Country_Picklist__c = 'HT - HAITI'; }
            else if(acc.Country_ISO_code__c == 'HU') { acc.Country_Picklist__c = 'HU - HUNGARY'; }
            else if(acc.Country_ISO_code__c == 'ID') { acc.Country_Picklist__c = 'ID - INDONESIA'; }
            else if(acc.Country_ISO_code__c == 'IE') { acc.Country_Picklist__c = 'IE - IRELAND'; }
            else if(acc.Country_ISO_code__c == 'IL') { acc.Country_Picklist__c = 'IL - ISRAEL'; }
            else if(acc.Country_ISO_code__c == 'IM') { acc.Country_Picklist__c = 'IM - ISLE OF MAN'; }
            else if(acc.Country_ISO_code__c == 'IN') { acc.Country_Picklist__c = 'IN - INDIA'; }
            else if(acc.Country_ISO_code__c == 'IO') { acc.Country_Picklist__c = 'IO - BRITISH INDIAN OCEAN TERRITORY'; }
            else if(acc.Country_ISO_code__c == 'IQ') { acc.Country_Picklist__c = 'IQ - IRAQ'; }
            else if(acc.Country_ISO_code__c == 'IR') { acc.Country_Picklist__c = 'IR - IRAN, ISLAMIC REPUBLIC OF'; }
            else if(acc.Country_ISO_code__c == 'IS') { acc.Country_Picklist__c = 'IS - ICELAND'; }
            else if(acc.Country_ISO_code__c == 'IT') { acc.Country_Picklist__c = 'IT - ITALY'; }
            else if(acc.Country_ISO_code__c == 'JE') { acc.Country_Picklist__c = 'JE - JERSEY'; }
            else if(acc.Country_ISO_code__c == 'JM') { acc.Country_Picklist__c = 'JM - JAMAICA'; }
            else if(acc.Country_ISO_code__c == 'JO') { acc.Country_Picklist__c = 'JO - JORDAN'; }
            else if(acc.Country_ISO_code__c == 'JP') { acc.Country_Picklist__c = 'JP - JAPAN'; }
            else if(acc.Country_ISO_code__c == 'KE') { acc.Country_Picklist__c = 'KE - KENYA'; }
            else if(acc.Country_ISO_code__c == 'KG') { acc.Country_Picklist__c = 'KG - KYRGYZSTAN'; }
            else if(acc.Country_ISO_code__c == 'KH') { acc.Country_Picklist__c = 'KH - CAMBODIA'; }
            else if(acc.Country_ISO_code__c == 'KI') { acc.Country_Picklist__c = 'KI - KIRIBATI'; }
            else if(acc.Country_ISO_code__c == 'KM') { acc.Country_Picklist__c = 'KM - COMOROS'; }
            else if(acc.Country_ISO_code__c == 'KN') { acc.Country_Picklist__c = 'KN - SAINT KITTS AND NEVIS'; }
            else if(acc.Country_ISO_code__c == 'KR') { acc.Country_Picklist__c = 'KR - KOREA, REPUBLIC OF'; }
            else if(acc.Country_ISO_code__c == 'KW') { acc.Country_Picklist__c = 'KW - KUWAIT'; }
            else if(acc.Country_ISO_code__c == 'KY') { acc.Country_Picklist__c = 'KY - CAYMAN ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'KZ') { acc.Country_Picklist__c = 'KZ - KAZAKHSTAN'; }
            else if(acc.Country_ISO_code__c == 'LA') { acc.Country_Picklist__c = 'LA - LAO PEOPLE\'S DEMOCRATIC REPUBLIC'; }
            else if(acc.Country_ISO_code__c == 'LB') { acc.Country_Picklist__c = 'LB - LEBANON'; }
            else if(acc.Country_ISO_code__c == 'LC') { acc.Country_Picklist__c = 'LC - SAINT LUCIA'; }
            else if(acc.Country_ISO_code__c == 'LI') { acc.Country_Picklist__c = 'LI - LIECHTENSTEIN'; }
            else if(acc.Country_ISO_code__c == 'LK') { acc.Country_Picklist__c = 'LK - SRI LANKA'; }
            else if(acc.Country_ISO_code__c == 'LR') { acc.Country_Picklist__c = 'LR - LIBERIA'; }
            else if(acc.Country_ISO_code__c == 'LS') { acc.Country_Picklist__c = 'LS - LESOTHO'; }
            else if(acc.Country_ISO_code__c == 'LT') { acc.Country_Picklist__c = 'LT - LITHUANIA'; }
            else if(acc.Country_ISO_code__c == 'LU') { acc.Country_Picklist__c = 'LU - LUXEMBOURG'; }
            else if(acc.Country_ISO_code__c == 'LV') { acc.Country_Picklist__c = 'LV - LATVIA'; }
            else if(acc.Country_ISO_code__c == 'LY') { acc.Country_Picklist__c = 'LY - LIBYAN ARAB JAMAHIRIYA'; }
            else if(acc.Country_ISO_code__c == 'MA') { acc.Country_Picklist__c = 'MA - MOROCCO'; }
            else if(acc.Country_ISO_code__c == 'MC') { acc.Country_Picklist__c = 'MC - MONACO'; }
            else if(acc.Country_ISO_code__c == 'MD') { acc.Country_Picklist__c = 'MD - MOLDOVA'; }
            else if(acc.Country_ISO_code__c == 'ME') { acc.Country_Picklist__c = 'ME - MONTENEGRO'; }
            else if(acc.Country_ISO_code__c == 'MF') { acc.Country_Picklist__c = 'MF - SAINT MARTIN'; }
            else if(acc.Country_ISO_code__c == 'MG') { acc.Country_Picklist__c = 'MG - MADAGASCAR'; }
            else if(acc.Country_ISO_code__c == 'MH') { acc.Country_Picklist__c = 'MH - MARSHALL ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'MK') { acc.Country_Picklist__c = 'MK - MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF'; }
            else if(acc.Country_ISO_code__c == 'ML') { acc.Country_Picklist__c = 'ML - MALI'; }
            else if(acc.Country_ISO_code__c == 'MM') { acc.Country_Picklist__c = 'MM - MYANMAR'; }
            else if(acc.Country_ISO_code__c == 'MN') { acc.Country_Picklist__c = 'MN - MONGOLIA'; }
            else if(acc.Country_ISO_code__c == 'MO') { acc.Country_Picklist__c = 'MO - MACAO'; }
            else if(acc.Country_ISO_code__c == 'MP') { acc.Country_Picklist__c = 'MP - NORTHERN MARIANA ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'MQ') { acc.Country_Picklist__c = 'MQ - MARTINIQUE'; }
            else if(acc.Country_ISO_code__c == 'MR') { acc.Country_Picklist__c = 'MR - MAURITANIA'; }
            else if(acc.Country_ISO_code__c == 'MS') { acc.Country_Picklist__c = 'MS - MONTSERRAT'; }
            else if(acc.Country_ISO_code__c == 'MT') { acc.Country_Picklist__c = 'MT - MALTA'; }
            else if(acc.Country_ISO_code__c == 'MU') { acc.Country_Picklist__c = 'MU - MAURITIUS'; }
            else if(acc.Country_ISO_code__c == 'MV') { acc.Country_Picklist__c = 'MV - MALDIVES'; }
            else if(acc.Country_ISO_code__c == 'MW') { acc.Country_Picklist__c = 'MW - MALAWI'; }
            else if(acc.Country_ISO_code__c == 'MX') { acc.Country_Picklist__c = 'MX - MEXICO'; }
            else if(acc.Country_ISO_code__c == 'MY') { acc.Country_Picklist__c = 'MY - MALAYSIA'; }
            else if(acc.Country_ISO_code__c == 'MZ') { acc.Country_Picklist__c = 'MZ - MOZAMBIQUE'; }
            else if(acc.Country_ISO_code__c == 'NA') { acc.Country_Picklist__c = 'NA - NAMIBIA'; }
            else if(acc.Country_ISO_code__c == 'NC') { acc.Country_Picklist__c = 'NC - NEW CALEDONIA'; }
            else if(acc.Country_ISO_code__c == 'NE') { acc.Country_Picklist__c = 'NE - NIGER'; }
            else if(acc.Country_ISO_code__c == 'NF') { acc.Country_Picklist__c = 'NF - NORFOLK ISLAND'; }
            else if(acc.Country_ISO_code__c == 'NG') { acc.Country_Picklist__c = 'NG - NIGERIA'; }
            else if(acc.Country_ISO_code__c == 'NI') { acc.Country_Picklist__c = 'NI - NICARAGUA'; }
            else if(acc.Country_ISO_code__c == 'NL') { acc.Country_Picklist__c = 'NL - NETHERLANDS'; }
            else if(acc.Country_ISO_code__c == 'NO') { acc.Country_Picklist__c = 'NO - NORWAY'; }
            else if(acc.Country_ISO_code__c == 'NP') { acc.Country_Picklist__c = 'NP - NEPAL'; }
            else if(acc.Country_ISO_code__c == 'NR') { acc.Country_Picklist__c = 'NR - NAURU'; }
            else if(acc.Country_ISO_code__c == 'NU') { acc.Country_Picklist__c = 'NU - NIUE'; }
            else if(acc.Country_ISO_code__c == 'NZ') { acc.Country_Picklist__c = 'NZ - NEW ZEALAND'; }
            else if(acc.Country_ISO_code__c == 'OM') { acc.Country_Picklist__c = 'OM - OMAN'; }
            else if(acc.Country_ISO_code__c == 'PA') { acc.Country_Picklist__c = 'PA - PANAMA'; }
            else if(acc.Country_ISO_code__c == 'PE') { acc.Country_Picklist__c = 'PE - PERU'; }
            else if(acc.Country_ISO_code__c == 'PF') { acc.Country_Picklist__c = 'PF - FRENCH POLYNESIA'; }
            else if(acc.Country_ISO_code__c == 'PG') { acc.Country_Picklist__c = 'PG - PAPUA NEW GUINEA'; }
            else if(acc.Country_ISO_code__c == 'PH') { acc.Country_Picklist__c = 'PH - PHILIPPINES'; }
            else if(acc.Country_ISO_code__c == 'PK') { acc.Country_Picklist__c = 'PK - PAKISTAN'; }
            else if(acc.Country_ISO_code__c == 'PL') { acc.Country_Picklist__c = 'PL - POLAND'; }
            else if(acc.Country_ISO_code__c == 'PM') { acc.Country_Picklist__c = 'PM - SAINT PIERRE AND MIQUELON'; }
            else if(acc.Country_ISO_code__c == 'PN') { acc.Country_Picklist__c = 'PN - PITCAIRN'; }
            else if(acc.Country_ISO_code__c == 'PR') { acc.Country_Picklist__c = 'PR - PUERTO RICO'; }
            else if(acc.Country_ISO_code__c == 'PS') { acc.Country_Picklist__c = 'PS - PALESTINIAN TERRITORY, OCCUPIED'; }
            else if(acc.Country_ISO_code__c == 'PT') { acc.Country_Picklist__c = 'PT - PORTUGAL'; }
            else if(acc.Country_ISO_code__c == 'PW') { acc.Country_Picklist__c = 'PW - PALAU'; }
            else if(acc.Country_ISO_code__c == 'PY') { acc.Country_Picklist__c = 'PY - PARAGUAY'; }
            else if(acc.Country_ISO_code__c == 'QA') { acc.Country_Picklist__c = 'QA - QATAR'; }
            else if(acc.Country_ISO_code__c == 'RE') { acc.Country_Picklist__c = 'RE - RÉUNION'; }
            else if(acc.Country_ISO_code__c == 'RO') { acc.Country_Picklist__c = 'RO - ROMANIA'; }
            else if(acc.Country_ISO_code__c == 'RS') { acc.Country_Picklist__c = 'RS - SERBIA'; }
            else if(acc.Country_ISO_code__c == 'RU') { acc.Country_Picklist__c = 'RU - RUSSIAN FEDERATION'; }
            else if(acc.Country_ISO_code__c == 'RW') { acc.Country_Picklist__c = 'RW - RWANDA'; }
            else if(acc.Country_ISO_code__c == 'SA') { acc.Country_Picklist__c = 'SA - SAUDI ARABIA'; }
            else if(acc.Country_ISO_code__c == 'SB') { acc.Country_Picklist__c = 'SB - SOLOMON ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'SC') { acc.Country_Picklist__c = 'SC - SEYCHELLES'; }
            else if(acc.Country_ISO_code__c == 'SD') { acc.Country_Picklist__c = 'SD - SUDAN'; }
            else if(acc.Country_ISO_code__c == 'SE') { acc.Country_Picklist__c = 'SE - SWEDEN'; }
            else if(acc.Country_ISO_code__c == 'SG') { acc.Country_Picklist__c = 'SG - SINGAPORE'; }
            else if(acc.Country_ISO_code__c == 'SH') { acc.Country_Picklist__c = 'SH - SAINT HELENA'; }
            else if(acc.Country_ISO_code__c == 'SI') { acc.Country_Picklist__c = 'SI - SLOVENIA'; }
            else if(acc.Country_ISO_code__c == 'SJ') { acc.Country_Picklist__c = 'SJ - SVALBARD AND JAN MAYEN'; }
            else if(acc.Country_ISO_code__c == 'SK') { acc.Country_Picklist__c = 'SK - SLOVAKIA'; }
            else if(acc.Country_ISO_code__c == 'SL') { acc.Country_Picklist__c = 'SL - SIERRA LEONE'; }
            else if(acc.Country_ISO_code__c == 'SM') { acc.Country_Picklist__c = 'SM - SAN MARINO'; }
            else if(acc.Country_ISO_code__c == 'SN') { acc.Country_Picklist__c = 'SN - SENEGAL'; }
            else if(acc.Country_ISO_code__c == 'SO') { acc.Country_Picklist__c = 'SO - SOMALIA'; }
            else if(acc.Country_ISO_code__c == 'SR') { acc.Country_Picklist__c = 'SR - SURINAME'; }
            else if(acc.Country_ISO_code__c == 'ST') { acc.Country_Picklist__c = 'ST - SAO TOME AND PRINCIPE'; }
            else if(acc.Country_ISO_code__c == 'SV') { acc.Country_Picklist__c = 'SV - EL SALVADOR'; }
            else if(acc.Country_ISO_code__c == 'SY') { acc.Country_Picklist__c = 'SY - SYRIAN ARAB REPUBLIC'; }
            else if(acc.Country_ISO_code__c == 'SZ') { acc.Country_Picklist__c = 'SZ - SWAZILAND'; }
            else if(acc.Country_ISO_code__c == 'TC') { acc.Country_Picklist__c = 'TC - TURKS AND CAICOS ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'TD') { acc.Country_Picklist__c = 'TD - CHAD'; }
            else if(acc.Country_ISO_code__c == 'TF') { acc.Country_Picklist__c = 'TF - FRENCH SOUTHERN TERRITORIES'; }
            else if(acc.Country_ISO_code__c == 'TG') { acc.Country_Picklist__c = 'TG - TOGO'; }
            else if(acc.Country_ISO_code__c == 'TH') { acc.Country_Picklist__c = 'TH - THAILAND'; }
            else if(acc.Country_ISO_code__c == 'TJ') { acc.Country_Picklist__c = 'TJ - TAJIKISTAN'; }
            else if(acc.Country_ISO_code__c == 'TK') { acc.Country_Picklist__c = 'TK - TOKELAU'; }
            else if(acc.Country_ISO_code__c == 'TL') { acc.Country_Picklist__c = 'TL - TIMOR-LESTE'; }
            else if(acc.Country_ISO_code__c == 'TM') { acc.Country_Picklist__c = 'TM - TURKMENISTAN'; }
            else if(acc.Country_ISO_code__c == 'TN') { acc.Country_Picklist__c = 'TN - TUNISIA'; }
            else if(acc.Country_ISO_code__c == 'TO') { acc.Country_Picklist__c = 'TO - TONGA'; }
            else if(acc.Country_ISO_code__c == 'TR') { acc.Country_Picklist__c = 'TR - TURKEY'; }
            else if(acc.Country_ISO_code__c == 'TT') { acc.Country_Picklist__c = 'TT - TRINIDAD AND TOBAGO'; }
            else if(acc.Country_ISO_code__c == 'TV') { acc.Country_Picklist__c = 'TV - TUVALU'; }
            else if(acc.Country_ISO_code__c == 'TW') { acc.Country_Picklist__c = 'TW - TAIWAN, PROVINCE OF CHINA'; }
            else if(acc.Country_ISO_code__c == 'TZ') { acc.Country_Picklist__c = 'TZ - TANZANIA, UNITED REPUBLIC OF'; }
            else if(acc.Country_ISO_code__c == 'UA') { acc.Country_Picklist__c = 'UA - UKRAINE'; }
            else if(acc.Country_ISO_code__c == 'UG') { acc.Country_Picklist__c = 'UG - UGANDA'; }
            else if(acc.Country_ISO_code__c == 'UM') { acc.Country_Picklist__c = 'UM - UNITED STATES MINOR OUTLYING ISLANDS'; }
            else if(acc.Country_ISO_code__c == 'US') { acc.Country_Picklist__c = 'US - UNITED STATES'; }
            else if(acc.Country_ISO_code__c == 'UY') { acc.Country_Picklist__c = 'UY - URUGUAY'; }
            else if(acc.Country_ISO_code__c == 'UZ') { acc.Country_Picklist__c = 'UZ - UZBEKISTAN'; }
            else if(acc.Country_ISO_code__c == 'VA') { acc.Country_Picklist__c = 'VA - HOLY SEE (VATICAN CITY STATE)'; }
            else if(acc.Country_ISO_code__c == 'VC') { acc.Country_Picklist__c = 'VC - SAINT VINCENT AND THE GRENADINES'; }
            else if(acc.Country_ISO_code__c == 'VE') { acc.Country_Picklist__c = 'VE - VENEZUELA'; }
            else if(acc.Country_ISO_code__c == 'VG') { acc.Country_Picklist__c = 'VG - VIRGIN ISLANDS, BRITISH'; }
            else if(acc.Country_ISO_code__c == 'VI') { acc.Country_Picklist__c = 'VI - VIRGIN ISLANDS, U.S.'; }
            else if(acc.Country_ISO_code__c == 'VN') { acc.Country_Picklist__c = 'VN - VIET NAM'; }
            else if(acc.Country_ISO_code__c == 'VU') { acc.Country_Picklist__c = 'VU - VANUATU'; }
            else if(acc.Country_ISO_code__c == 'WF') { acc.Country_Picklist__c = 'WF - WALLIS AND FUTUNA'; }
            else if(acc.Country_ISO_code__c == 'WS') { acc.Country_Picklist__c = 'WS - SAMOA'; }
            else if(acc.Country_ISO_code__c == 'WW') { acc.Country_Picklist__c = 'WW - WORLDWIDE'; }
            else if(acc.Country_ISO_code__c == 'YE') { acc.Country_Picklist__c = 'YE - YEMEN'; }
            else if(acc.Country_ISO_code__c == 'YT') { acc.Country_Picklist__c = 'YT - MAYOTTE'; }
            else if(acc.Country_ISO_code__c == 'ZA') { acc.Country_Picklist__c = 'ZA - SOUTH AFRICA'; }
            else if(acc.Country_ISO_code__c == 'ZM') { acc.Country_Picklist__c = 'ZM - ZAMBIA'; }
            else if(acc.Country_ISO_code__c == 'ZW') { acc.Country_Picklist__c = 'ZW - ZIMBABWE'; }
        
        }
     i++;
     }
    }