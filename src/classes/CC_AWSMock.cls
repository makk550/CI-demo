@IsTest 
global class CC_AWSMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('/site/get-sites-for-user')) {
            res.setBody('{ "data": { "httpStatusCode": 200, "details": [ "105246", "756626", "880341", "905642", "907229" ] } }');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains('/star/get-solutions-from-star')){
            res.setBody('{ "data": { "httpStatusCode": 200, "details": [ { "sol_stat": [ "CONFIRMED" ], "sol_dist": [ "AVAILABLE" ], "sol_os": [ "DOS" ], "sol_apar": [ "RO42014" ], "title": [ "VPUR - NEED TO CLEAR DD GROUP KEY ENTRY FOR TERMID" ], "product": [ "VPE" ], "release": [ "11.0" ], "solution_number": [ "45" ], "upd_date_time": [ "06/17/2014    12:10:42" ] } ] } }');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains('/download-center/update-product-area')){
            res.setBody('{"data":{"httpStatusCode":200,"details":["Success"]}}');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains('/products/get-entitled-ca-products-for-user-v2')){
            res.setBody('{ "data": { "httpStatusCode": 200, "details": [ { "products": [ { "product": "ACCUCHECK", "site_ids": [ 105246, 580185 ] } ], "siteIdList": [ 105246, 905642 ] } ] } }');
            res.setStatusCode(200);
            return res;
        }else if(req.getEndpoint().contains('entitled.commonstack.io/entitlements/user')){
            res.setBody('{"entitlements": [ { "topsproductcode": "PMCID99000", "supportsiteids": [ "00000123456" ], "sfdcaccountid": "0013000000HQXhHAAX", "name": "CA Agile Central Unlimited Edition SaaS ", "instanceid": "I0040246402000025201610160725155779950", "roles": [], "software_type": "saas", "status": "active", "materialid": "AGCUNL990","entitlement_type": "paid" }],"username": "336931","id": "336931","user_deleted": false,"user_disabled": false}');
            res.setStatusCode(200);
            return res;
        }else if(req.getEndpoint().contains('csocognitotoken?flag=true')){
            res.setBody('{"token": "eyJraWQiOiJ2XC9sTHpGWnRBZjQxeVcrV2d3TDZKRjQ0SmlwcnVQdCtTU1wvVndTWFpabFk9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI2NGM5OGE1ZS05MWM0LTRlZjEtODFmYS02NTE2YjlmOGRkMjUiLCJhdWQiOiI3bmRoNzdmazJzdTFqOXM1NTRhdDZnOWhsNyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJldmVudF9pZCI6IjYzNDRlNTBiLWRiNTItMTFlNy1iNTA3LTgzOTQwYjdiZTdjNyIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNTEyNjUzMjU1LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9qRWx4eEpIbTMiLCJjb2duaXRvOnVzZXJuYW1lIjoiY3NvYXBpdXNlciIsImV4cCI6MTUxMjY1Njg1NSwiaWF0IjoxNTEyNjUzMjU1LCJlbWFpbCI6InBvcm1hMDlAY2EuY29tIn0.ZbMM2cIVRtYiOuzePpGGZssdYvJdXyPJyWEiewRCzIYAYg-qxS-lEPaCOnF90zcstHL_PP2NNhNlUem4tHFoF0bb57rFLggbeXZC9dRLQyIPMM769Qht7SMChLjuS_EBTLDmZdUbHCGNswBxW2m6C0uPjgdAsf5DopSBHE6qbVlGzs618QXP8lszZXH2FVT9Z_emYqikBhKY-f-5E7mGCcokUOi73Nlfg2o092NFThvc4ugUlP-GrGYhB4JteM4S14DJvGIeAUEA-Crh7yFGoTKRYnClTrkhIxqdq5rbFVPr2w67bELj1I5zXgBfYyTCwciuWXwoM8DS7lqBjDxo9Q" }');
            res.setStatusCode(200);
            return res;
        }else if(req.getEndpoint().contains('salesforce.com/services/oauth2/token')){
            res.setBody('{"access_token": "00D1k0000004YH4!AQoAQCR5bWOOHTBJbxpncrzJPrl2Or1r3hHnewiq4vQaUUJ_KwghjP6HilIzyHx24mOIXx6cmLq59SZyq1cuVCnd57rRbYwK","instance_url": "https://ca--FSB2.cs78.my.salesforce.com","id": "https://test.salesforce.com/id/00D1k0000004YH4EAM/005a000000CdzlLAAR","token_type": "Bearer","issued_at": "1512653781562","signature": "JTdKkDt8i92hDZv/VRVE5n2rtcO/WjKkVRKh4YbsO/0="}');
            res.setStatusCode(200);
            return res;
        }else if(req.getEndpoint().contains('salesforce.com/services/apexrest/casecomments')){
            res.setBody('{"access_token": "00D1k0000004YH4!AQoAQCR5bWOOHTBJbxpncrzJPrl2Or1r3hHnewiq4vQaUUJ_KwghjP6HilIzyHx24mOIXx6cmLq59SZyq1cuVCnd57rRbYwK","instance_url": "https://ca--FSB2.cs78.my.salesforce.com","id": "https://test.salesforce.com/id/00D1k0000004YH4EAM/005a000000CdzlLAAR","token_type": "Bearer","issued_at": "1512653781562","signature": "JTdKkDt8i92hDZv/VRVE5n2rtcO/WjKkVRKh4YbsO/0="}');
            res.setStatusCode(200);
            return res;
        }

        return null;
    }
}