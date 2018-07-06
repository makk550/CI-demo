@RestResource(urlMapping='/embedded-images')
global with sharing class EmbeddedImages {
    @HttpPost
    global static String getEmbeddedImage(String url){
        PageReference pageReference = new PageReference(url);
        Blob imageBlob = pageReference.getContent();
        return EncodingUtil.base64Encode(imageBlob);
    }
}