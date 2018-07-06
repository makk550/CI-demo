global class CC_SearchItService implements I {
  public interface I {
    SearchItResults doSearch(String title, Id productName);
  }

  @TestVisible
  private String sourceId { get; set; }

  @TestVisible
  private String[] selectProperties = new String[]{
    'Products',
    'ContentSource',
    'Title',
    'Path',
    'CATOPSPublishUrlOWSMTXT',
    'ConfluenceURL',
    'HitHighlightedSummary',
    'CADOCDESC',
    'ProductVersions',
    'Size',
    'FileType',
    'TypeOfContent',
    'LastModifiedTime'
  };

	public CC_SearchItService() {
		sourceId = CC_Settings.searchDotCaDotComSourceId;
	}

  public SearchItResults doSearch(String title, Id productId) {
    String productName;
    SCKBProductMap__c[] kbProducts = [SELECT KB_Product_Name__c FROM SCKBProductMap__c WHERE SCProduct__c = :productId];
    String caProductName = [SELECT Name FROM CA_Product_Controller__c WHERE Id = :productId].Name;
    if (kbProducts.size() > 0) {
      productName = kbProducts[0].KB_Product_Name__c;
    } 
    String endpoint = buildSearchEndpoint(title, productName, caProductName);
    String jsonResult = callSearchIt(endpoint);
    SearchItArticle[] articles = parseResults(jsonResult);
    return new SearchItResults(articles, title, productName, caProductName);
  }

  @TestVisible
  private String callSearchIt(String endpoint) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setMethod('GET');
    req.setHeader('Accept', 'application/json; odata=verbose');
    log.info(req);
    HttpResponse res = http.send(req);
    String data = res.getBody();
    log.info(data);
    return data;
  }

  @TestVisible
  private String buildSearchEndpoint(String title, String productName, String caProductName) {

    // test query: https://search.ca.com/_api/search/query?QueryTemplatePropertiesUrl='spfile://webroot/queryparametertemplate.xml'&sourceid='8fdba11a-c566-4ec0-9b8d-48224cd6a0b2'&rankingmodelid='97cbcebd-037c-4346-9bc4-582d8c560204'&rowlimit=5&selectproperties='Products,ContentSource,Title,Path,CATOPSPublishUrlOWSMTXT,ConfluenceURL,HitHighlightedSummary,CADOCDESC,ProductVersions,Size,FileType,TypeOfContent,LastModifiedTime'&querytext='login'&refinementFilters='or%28Products%3A%C7%82%C7%82434120312054617065204d616e6167656d656e74%2C+Products%3A%C7%82%C7%82434120312054415045204d414e4147454d454e54%29'
    String[] params = new String[]{
      'QueryTemplatePropertiesUrl=\'spfile://webroot/queryparametertemplate.xml\'',
      'sourceid=\'' + this.sourceId + '\'',
      'rankingmodelid=\'97cbcebd-037c-4346-9bc4-582d8c560204\'',
      'rowlimit=5',
      'selectproperties=\'' + String.join(this.selectproperties, ',') + '\'',
      'querytext=\'' + EncodingUtil.urlEncode(title, 'UTF-8') + '\''
    };
    String refinementFilter = 'Products:ǂǂ' + EncodingUtil.convertToHex(Blob.valueOf(caProductName));
    if (productName != null) {
      refinementFilter = 'or(Products:ǂǂ' + EncodingUtil.convertToHex(Blob.valueOf(productName)) + ', Products:ǂǂ' + EncodingUtil.convertToHex(Blob.valueOf(caProductName)) + ')';
    }
    params.add('refinementFilters=\'' + EncodingUtil.urlEncode(refinementFilter, 'UTF-8') + '\'');
    return 'callout:search_ca_com?' + String.join(params, '&');
  }

  private SearchItArticle[] parseResults(String jsonResult) {
    JSONParser parser = JSON.createParser(jsonResult);
    CC_Utils.navigateToPath(parser, 'd.query.PrimaryQueryResult.RelevantResults.Table.Rows.results');
    SearchResult[] results = (SearchResult[])parser.readValueAs(List<SearchResult>.class);
    return convertResultsToArticles(results);
  }


  @TestVisible
  private SearchItArticle[] convertResultsToArticles(SearchResult[] results) {
    SearchItArticle[] articles = new SearchItArticle[]{};
    for (SearchResult result : results) {
      SearchItArticle article = new SearchItArticle(result.Cells.results);
      articles.add(article);
    }
    return articles;
  }

  //@TestVisible
  //private static void parseCell(SearchItArticle article, ResultCell cell) {
  //  article.put(cell.Key, cell.Value);
  //  if (cell.Value == null) {
  //    return;
  //  }
  //  if (cell.Key == 'Title') {
  //    article.title = cell.Value;
  //  } else if (cell.Key == 'CATOPSPublishUrlOWSMTXT') {
  //    article.url = cell.Value;
  //  } else if (cell.Key == 'ConfluenceURL') {
  //    article.url = cell.Value;
  //  } else if (cell.Key == 'Path' && article.url == null) {
  //    article.url = cell.Value;
  //  } else if (cell.Key == 'HitHighlightedSummary') {
  //    article.snippet = cleanseSnippet(cell.Value);
  //  //} else if (cell.Key == 'CADOCDESC' && TypeOfContent == 'Knowledge Base Articles') {
  //  //  article.snippet = cleanseSnippet(cell.Value);
  //  } else if (cell.Key == 'Products') {
  //    article.products = cell.Value;
  //  } else if (cell.Key == 'ContentSource') {
  //    article.contentSource = cell.Value;
  //  } else if (cell.Key == 'ProductVersions') {
  //    article.productVersions = cell.Value;
  //  } else if (cell.Key == 'Size') {
  //    article.fileSize = Long.valueOf(cell.Value);
  //  } else if (cell.Key == 'FileType') {
  //    article.fileType = cell.Value;
  //  } else if (cell.Key == 'TypeOfContent') {
  //    article.typeOfContent = cell.Value;
  //  } else if (cell.Key == 'LastModifiedTime') {
  //    article.lastModifiedTime = DateTime.valueOf(cell.Value.replace('T', ' '));
  //  }
  //}

  global class SearchItResults {
    public SearchItArticle[] articles {get; private set;}
    public Map<String, String> searchParameters {get; private set;}
    global SearchItResults(SearchItArticle[] articles, String queryText, String productName, String caProductName) {
      this.articles = articles;
      this.searchParameters = new Map<String, String> {
        'queryText' => queryText,
        'productName' => productName,
        'caProductName' => caProductName
      };
    }
  }

  global class SearchItArticle {
    public String url {get; set;}
    public String title {get; private set;}
    public String snippet {get; private set;}
    public String contentSource {get; private set;}
    public String products {get; private set;}
    public String productVersions {get; private set;}
    public Long fileSize {get; private set;}
    public String fileType {get; private set;}
    public String typeOfContent {get; private set;}
    public DateTime lastModifiedTime {get; private set;}

    public SearchItArticle() {}
    public SearchItArticle(List<ResultCell> cells) {
      Map<String, String> parsedCells = new Map<String, String>();
      for (ResultCell cell : cells) {
        parsedCells.put(cell.Key, cell.Value);
      }
      this.processCells(parsedCells);
    }

    @TestVisible
    private void processCells(Map<String, String> parsedCells) {
      this.title = parsedCells.get('Title');
      if (parsedCells.get('CATOPSPublishUrlOWSMTXT') != null) {
        this.url = parsedCells.get('CATOPSPublishUrlOWSMTXT');
      } else if (parsedCells.get('ConfluenceURL') != null) {
        this.url = parsedCells.get('ConfluenceURL');
      } else {
        this.url = parsedCells.get('Path');
      }
      this.typeOfContent = parsedCells.get('TypeOfContent');

      if (parsedCells.get('HitHighlightedSummary') != null) {
        this.snippet = this.cleanseSnippet(parsedCells.get('HitHighlightedSummary'));
      }
      if (this.typeOfContent == 'Knowledge Base Articles' && parsedCells.get('CADOCDESC') != null) {
        this.snippet = this.cleanseSnippet(parsedCells.get('CADOCDESC'));
      }

      this.products = parsedCells.get('Products');
      this.contentSource = parsedCells.get('ContentSource');
      this.productVersions = parsedCells.get('ProductVersions');
      if (parsedCells.get('Size') != null) {
        this.fileSize = Long.valueOf(parsedCells.get('Size'));
      }
      this.fileType = parsedCells.get('FileType');
      
      if (parsedCells.get('LastModifiedTime') != null) {
        this.lastModifiedTime = DateTime.valueOf(parsedCells.get('LastModifiedTime').replace('T', ' '));
      }
    }

    @TestVisible
    private String cleanseSnippet(String inputSnippet) {
      return inputSnippet
        .replaceAll('&lt;(?!&gt;).*?&gt;','')
        .unescapeHtml4()
        .replace('<ddd/>', '<b>...</b>')
        .replace('<c0>', '<b>')
        .replace('</c0>', '</b>')
        .replace('\\r\\n', '<br/>');
    }

  }

  public class SearchResult {
    public ResultCells Cells;
  }

  public class ResultCells {
    public List<ResultCell> results;
  }

  public class ResultCell {
    public String Key;
    public String Value;
    public ResultCell(String key, String value) {
      this.Key = key;
      this.Value = value;
    }
  }
}