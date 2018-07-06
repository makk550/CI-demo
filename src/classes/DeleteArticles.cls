@RestResource(urlMapping='/delete-article/*')
global with sharing class DeleteArticles {
    @HttpDelete
    global static void deleteArticle() {
        RestRequest req = RestContext.request;
        KbManagement.PublishingService.deleteArchivedArticle(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
    }
}