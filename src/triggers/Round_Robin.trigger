trigger Round_Robin on Quote_Request__c (before update) {
for (Quote_Request__c Q : Trigger.new) {


if ( Q.OwnerId == '00G30000001BP3Q')
{

if ( Q.RR_ID__c == 0)

{ Q.OwnerId = '005300000016r4b' ; }
 {Q.RR_ID_02__c = 9999 ; }
//  { Q.Request_Status__c = 'New';} 
  
if ( Q.RR_ID__c == 1)

{ Q.OwnerId = '005300000016r3H' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 2)

{ Q.OwnerId = '005300000016r2m' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 3)

{ Q.OwnerId = '00530000000whNc' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 4)

{ Q.OwnerId = '00530000001IQdq' ; }
 {Q.RR_ID_02__c = 9999 ; } 
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 5)

{ Q.OwnerId = '005300000016r3F' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 6)

{ Q.OwnerId = '00530000000whLJ' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 7)

{ Q.OwnerId = '00530000000whMO' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 8)

{ Q.OwnerId = '005300000018Qyk' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 9)

{ Q.OwnerId = '00530000001IQdv' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 10)

{  Q.OwnerId = '005300000016r47' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

if ( Q.RR_ID__c == 11)

{ Q.OwnerId = '00530000001IQdl' ; }
 {Q.RR_ID_02__c = 9999 ; }
//    { Q.Request_Status__c = 'New';} 

}
}}