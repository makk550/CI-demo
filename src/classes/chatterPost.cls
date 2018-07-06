public class chatterPost{

public static void mentionTextPost(Id RecordId, Id userToMentionId, String postText) { 

    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = 'Hello ';
    messageInput.messageSegments.add(textSegment);

    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
    mentionSegment.id = userToMentionId;
    messageInput.messageSegments.add(mentionSegment);

    textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = postText;
    messageInput.messageSegments.add(textSegment);

    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
    input.body = messageInput;
    input.subjectId = RecordId;
    system.debug('input>'+input+'processing');
    
    try{
       ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, RecordId, input, null);
       //ConnectApi.ChatterFeeds.postFeedElement(null,input, null); 
    }
    catch(Exception e){
       system.debug('e>'+e);
       throw e;
    }
    system.debug('feed done');
  }  
  
  
public static void postFeedbackPoll(Id RecordId, Id userToMentionId) { 


    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

    ConnectApi.TextSegmentInput textSegmentPoll = new ConnectApi.TextSegmentInput();
    textSegmentPoll.text = 'Hello ';
    messageInput.messageSegments.add(textSegmentPoll);

    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
    mentionSegment.id = userToMentionId;
    messageInput.messageSegments.add(mentionSegment);
  
      
    // add the text segment
    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();

    textSegment.text = 'Are you satisfied with our Service? If you are dissatisfied please a comment so that we can get back to you.';
    messageInput.messageSegments.add(textSegment);
    
    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
    feedItemInput.body = messageInput;
    feedItemInput.subjectId = RecordId;
    
    // add the attachment
    String[] choices = new List<String>{'Satisfied','Dis-satisfied'};
    ConnectApi.PollAttachmentInput linkIn = new ConnectApi.PollAttachmentInput();
    linkIn.pollChoices = choices;
    feedItemInput.attachment = linkIn;
    
    // post it!
    ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, RecordId, feedItemInput, null);
       
  }
}