@IsTest
global class CalloutMock implements HttpCalloutMock {
    public HttpRequest[] requests { get; set; }
    public HttpResponse[] responses { get; set; }
    public Integer count;

    public CalloutMock(HttpResponse[] responses) {
      init(responses);
    }

    public CalloutMock(HttpResponse response) {
      init(new HttpResponse[] {response});
    }

    private void init(HttpResponse[] responses) {
      this.responses = responses;
      this.requests = new HttpRequest[]{};
      this.count = 0;
    }

    global HttpResponse respond(HttpRequest req) {
      requests.add(req);
      return responses.get(count++);
    }
  }