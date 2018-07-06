/*
SFDC CRM 7.1 req - 644  
req description - Have system auto generate the overlay codes based on a “lookup” table that concatenatess 
the quota code, territory (combo of territory and quota code would equal overlay code.

Trigger overview - on Insert/update of TAQ ORG Approved records auto populate the overlay codes 
for Quota 1, Quota 2 and Quota 3 by referencing the Overlay code mapping table custom object.

This requirement is for NA only and works for certain plan types (stored in overlay codes object)
Developed by Heena - Accenture IDC on 3 Sept 2010
*/

trigger CA_TAQ_OverlayCodesMapping on TAQ_Organization_Approved__c (before insert, before update) {
}