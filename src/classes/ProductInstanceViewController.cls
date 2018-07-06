public with sharing class ProductInstanceViewController {

  /* Remote Actions */
  @RemoteAction
  public static void updateIsp(Id siteId, Integer isp) {
    new UpdateIspController().execute(siteId, isp);
    //update new Site_Association__c(Id = siteId, ISP__c = isp);
  }

  /* Public Properties */
  public String pageBlockTitle {get;set;}

  public String debugMessage {get;set;}

  public ProductInstanceRollup[] data { get { 
    return sorter.sort();
  }}

  public ProductInstanceStats[] statsByProduct { get {
    return buildStatsByProduct(productInstanceRollupMap.values());
  }}

  public Boolean hasData { get{
    return productInstanceRollupMap != null && productInstanceRollupMap.values().size() > 0;
  }}

  /* Private Properties */
  @TestVisible
  private Account account {get;set;}

  @TestVisible
  private Selector soqlSelector {get {
    if (soqlSelector == null) {
      soqlSelector = new Selector();
    }  
    return soqlSelector;
  }set;}

  @TestVisible
  private Map<String, ProductInstanceRollup> productInstanceRollupMap {get;set;}

  @TestVisible
  private SortDirection sortDir {get;set {
    sortDir = value;
    sorter = null;
  }}

  @TestVisible
  private SortColumn sortCol {get;set {
    sortCol = value;
    sorter = null;
  }}

  private InsertionSorter sorter {get {
    if (sorter == null) {
      sorter = new InsertionSorter(this.productInstanceRollupMap.values(), this.sortDir, this.sortCol);
    }
    return sorter;
  }set;}

  /* ctor */
	public ProductInstanceViewController() {
	}

  /* Public Methods */
  public void init() {
    if (account == null) {
      String acctId = PageUtils.get('accountId');
      if (acctId == null) {
        PageUtils.addError('Account ID not provided');
        return;
      }
      try {
        account = soqlSelector.selectAccountById(acctId);
      } catch (Exception ex) {
        PageUtils.addError(acctId + ' is not a valid Account ID');
        return;
      }
      if (account == null){
        PageUtils.addError('Could not find Account with ID ' + acctId);
        return;
      }
    }
    String dunsgp = account.GU_DUNS_NUMBER__c;
    if (String.isBlank(dunsgp)) {
      PageUtils.addError('There is no GP DUNS Number associated with the account.');
      return;
    }

    pageBlockTitle = 'Product Instances for ' + account.Name + ' - ' + dunsgp;
    
    ProductInstanceView__x[] pivs = soqlSelector.selectPivsByGpDunsNumber(dunsgp);

    if (pivs.size() > 0) {
      productInstanceRollupMap = createRollupMap(pivs);
    }
  }

  public void sortByInstanceName() {
    sortBy(SortColumn.INSTANCE_NAME);
  }
  public void sortBySite() {
    sortBy(SortColumn.SITE_NAME);
  }
  public void sortByProductInstanceId() {
    sortBy(SortColumn.PRODUCT_INSTANCE_ID);
  }
  public void sortByStatus() {
    sortBy(SortColumn.STATUS);
  }
  public void sortByProduct() {
    sortBy(SortColumn.PRODUCT_NAME);
  }
  public void sortByPaidSeats() {
    sortBy(SortColumn.PAID_SEATS);
  }
  public void sortByUnpaidSeats() {
    sortBy(SortColumn.UNPAID_SEATS);
  }
  public void sortByIsp() {
    sortBy(SortColumn.ISP);
  }
  public void sortByPenetration() {
    sortBy(SortColumn.PENETRATION);
  }
  public void sortByStartDate() {
    sortBy(SortColumn.START_DATE);
  }
  public void sortByEndDate() {
    sortBy(SortColumn.END_DATE);
  }

  /* Private Methods */
  @TestVisible
  private Map<String, ProductInstanceRollup> createRollupMap(ProductInstanceView__x[] pivs) {
    Map<String, ProductInstanceRollup> rollupMap = new Map<String, ProductInstanceRollup>();
    // create rollup map
    for (ProductInstanceView__x piv : pivs) {
      String rollupKey = piv.product_instance_id__c+piv.name__c;
      ProductInstanceRollup rollup = new ProductInstanceRollup();
      if (rollupMap.containsKey(rollupKey)){
        rollup = rollupMap.get(rollupKey);
      }
      rollup.addRecord(piv);
        system.debug('------roll up in for------'+rollup);
      rollupMap.put(rollupKey, rollup);
    }
    // rollup data
    for (ProductInstanceRollup rollup : rollupMap.values()) {
      rollup.rollup();
    }

    // collect site ids
    Set<String> siteIds = new Set<String>();
    for (ProductInstanceRollup rollup : rollupMap.values()) {
      siteIds.add(String.valueOf(rollup.caSiteId));
    }
    // create map of sites by ca site id
    Map<Long, Site_Association__c> siteMap = new Map<Long, Site_Association__c>();
    for (Site_Association__c site : soqlSelector.selectSitesBySapSiteId(siteIds)) {
      siteMap.put(Long.valueOf(site.SAP_Site_ID__c), site);
    }
    // add site records to rollup
    for (ProductInstanceRollup rollup : rollupMap.values()) {
      if (siteMap.containsKey(rollup.caSiteId)) {
        rollup.siteRecord = siteMap.get(rollup.caSiteId);
      } else {
        rollup.siteRecord = new Site_Association__c();
      }
    }

    // add product contacts report id
    Report productInstanceContactsReport = soqlSelector.selectProductInstanceContactsReport();
    if (productInstanceContactsReport != null) {
      for (ProductInstanceRollup rollup : rollupMap.values()) {
        rollup.contactsReportId = productInstanceContactsReport.Id;
          
      }
    }
	system.debug('-----prod inst roll up map------'+rollupMap);
    return rollupMap;
  }

  @TestVisible
  private ProductInstanceStats[] buildStatsByProduct(ProductInstanceRollup[] data) {
    Map<String, ProductInstanceStats> statsMap = new Map<String, ProductInstanceStats>();
    for (ProductInstanceRollup rollup : data) {
      if (rollup.status != 'active') continue;
      ProductInstanceStats prodStats = statsMap.get(rollup.productName);
      if (prodStats == null) {
        prodStats = new ProductInstanceStats(rollup.productName);
      }
      prodStats.addRecord(rollup);
      statsMap.put(rollup.productName, prodStats);
    }
    return statsMap.values();
  }

  private void sortBy(SortColumn col) {
    if (sortCol == col) {
      sortDir = (sortDir == SortDirection.SORT_ASC ? SortDirection.SORT_DESC : SortDirection.SORT_ASC);
    } else {
      sortCol = col;
      sortDir = SortDirection.SORT_ASC;
    }
  }
  
  /* Helper Classes */
  public enum SortColumn {PRODUCT_INSTANCE_ID, INSTANCE_ID, STATUS, INSTANCE_NAME, SITE_ID, SITE_NAME, PRODUCT_NAME, START_DATE, END_DATE, PAID_SEATS, UNPAID_SEATS, ISP, PENETRATION}
  public enum SortDirection {SORT_ASC, SORT_DESC}

  public class InsertionSorter {

    public ProductInstanceRollup[] data;
    public SortDirection sortDir;
    public SortColumn sortCol;
    public Boolean isSorted {get;set;}

    public InsertionSorter(ProductInstanceRollup[] data, SortDirection sortDir, SortColumn sortCol) {
      this.data = data;
      if (sortDir != null && sortCol != null) {
        this.sortDir = sortDir;
        this.sortCol = sortCol;
        this.isSorted = false;
      } else {
        this.isSorted = true;
      }
    }

    // sort data using insertion sort algorithm
    public ProductInstanceRollup[] sort() {
      if (isSorted) {
        return data;
      }
      Integer n = data.size();
      for (Integer i = 1; i < n; i++) {
        for (Integer j = i; j > 0; j--) {
          if (shouldExchange(data[j], data[j-1])) {
            exchange(j, j-1);
          }
        }
      }
      isSorted = true;
      return data;
    }

    @TestVisible
    private Boolean shouldExchange(ProductInstanceRollup right, ProductInstanceRollup left) {

      ProductInstanceRollup current = right;
      ProductInstanceRollup previous = left;
      if (sortDir == SortDirection.SORT_DESC) {
        current = left; previous = right;
      }

      // PI ID is unique - no tie breaker needed
      if (sortCol == SortColumn.PRODUCT_INSTANCE_ID) {
        return current.productInstanceId.compareTo(previous.productInstanceId) < 0;
      }

      Decimal sortOrdinal = 0;
      if (sortCol == SortColumn.INSTANCE_ID) {
        sortOrdinal = current.instanceId.compareTo(previous.instanceId);
      }
      else if (sortCol == SortColumn.STATUS) {
        sortOrdinal = current.status.compareTo(previous.status);
      }
      else if (sortCol == SortColumn.INSTANCE_NAME) {
        sortOrdinal = current.instanceName.compareTo(previous.instanceName);
      }
      else if (sortCol == SortColumn.SITE_ID) {
        sortOrdinal = current.caSiteId - previous.caSiteId;
      }
      else if (sortCol == SortColumn.SITE_NAME) {
        sortOrdinal = current.siteName.compareTo(previous.siteName);
      }
      else if (sortCol == SortColumn.PRODUCT_NAME) {
        sortOrdinal = current.productName.compareTo(previous.productName);
      }
      else if (sortCol == SortColumn.START_DATE) {
        DateTime currentDate = current.minStartDate == null ? DateTime.newInstance(0) : current.minStartDate;
        DateTime prevDate = previous.minStartDate == null ? DateTime.newInstance(0) : previous.minStartDate;
        sortOrdinal = currentDate.getTime() - prevDate.getTime();
      }
      else if (sortCol == SortColumn.END_DATE) {
        DateTime currentDate = current.maxEndDate == null ? DateTime.newInstance(0) : current.maxEndDate;
        DateTime prevDate = previous.maxEndDate == null ? DateTime.newInstance(0) : previous.maxEndDate;
        sortOrdinal = currentDate.getTime() - prevDate.getTime();
      }
      else if (sortCol == SortColumn.PAID_SEATS) {
        sortOrdinal = current.paidSeats - previous.paidSeats;
      }
      else if (sortCol == SortColumn.UNPAID_SEATS) {
        sortOrdinal = current.unpaidSeats - previous.unpaidSeats;
      }
      else if (sortCol == SortColumn.ISP) {
        sortOrdinal = current.isp - previous.isp;
      }
      else if (sortCol == SortColumn.PENETRATION) {
        sortOrdinal = current.penetration - previous.penetration;
      }

      // use a unique key as a tie breaker in order to get true reverse
      if (sortOrdinal == 0) {
        return current.productInstanceId.compareTo(previous.productInstanceId) < 0;
      }
      return sortOrdinal < 0;
    }

    private void exchange(Integer a, Integer b) {
      ProductInstanceRollup temp = data[a];
      data[a] = data[b];
      data[b] = temp;
    }
  }

  // view model that rolls up Productinstance view by product instance id
  public class ProductInstanceRollup {
    public ProductInstanceView__x[] records {get;set;}
    public ProductInstanceView__x[] details {get{
      ProductInstanceView__x[] filteredRecords = new ProductInstanceView__x[]{};
        for (ProductInstanceView__x piv : records) {
          if (shouldDisplayMetricDetail(piv)) {
            filteredRecords.add(piv);
          }
        }
        return filteredRecords;
    }}
    public String productInstanceId {get;set;}
    public String instanceId {get;set;}
    public String instanceName {get;set;}
    public Long caSiteId {get;set;}
    public String productName {get;set;}
    public DateTime minStartDate {get;set;}
    public DateTime maxEndDate {get;set;}
    public Integer paidSeats {get;set;}
    public Integer unpaidSeats {get;set;}
    public String status {get;set;} // active, cancelled, expired, under review, unknown
    public Site_Association__c siteRecord {get;set;}
    public Id contactsReportId {get;set;}

    public String siteName {get{
      return this.siteRecord.Name + ' - ' + this.caSiteId;
    }}

    public Integer isp {get{
      if (this.siteRecord != null && this.siteRecord.ISP__c != null) {
        return Integer.valueOf(this.siteRecord.ISP__c);
      }
      return 0;
    }}

    public Integer penetration {get {
      if (isp == 0) return 0;
      return Decimal.valueOf((paidSeats + unpaidSeats) * 100).divide(isp, 0).intValue();
    }}

    public String usageLink { get {
      return '/apex/Usage_Data?instance='+this.instanceId+'&prod_instance='+this.productInstanceId+'&accName='+instanceName;
    }}

    public String caSiteLink { get {
      return '/'+siteRecord.Id;
    }}

    public String contactsReportLink { get {
      return '/'+this.contactsReportId + '?pv0=' + this.productInstanceId;
    }}

    private final Set<String> paidSeatMetrics = new Set<String>{'PaidSeats', 'paid_addon_seats', 'paid_standalone_seats', 'Paid_seats'};
    private final Set<String> unpaidpaidSeatMetrics = new Set<String>{'UnpaidSeats', 'max_ue_seats'};

    public ProductInstanceRollup() {
      this.paidSeats = 0;
      this.unpaidSeats = 0;
      this.minStartDate = Datetime.newInstance(9999, 12, 31);
      this.maxEndDate = Datetime.newInstance(0);
      this.records = new ProductInstanceView__x[]{};
    }

    public void addRecord(ProductInstanceView__x piv) {
      this.records.add(piv);
      // update header info
        
            this.productInstanceId = piv.product_instance_id__c;
            this.instanceId = piv.instance_id__c;
            this.instanceName = piv.product_detail__c;
            if (piv.ca_site_id__c.isNumeric()) {
                this.caSiteId = Long.valueOf(piv.ca_site_id__c);
            }
            this.productName = piv.name__c;
        
      
    }

    public void rollup() {
      // determine status
      Set<String> statuses = new Set<String>();
      for (ProductInstanceView__x piv : this.records) {
        statuses.add(piv.status__c);
        this.maxEndDate = (maxEndDate < piv.entitlement_end_date__c) ? piv.entitlement_end_date__c : maxEndDate;
      }
      if (statuses.contains('active')) {
        this.status = 'active';
      } else if (statuses.contains('expired')) {
        this.status = 'expired';
      } else if (statuses.contains('cancelled')) {
        this.status = 'cancelled';
      } else {
        this.status = new List<String>(statuses)[0];
      }

      for (ProductInstanceView__x piv : this.records) {
        if (this.status == piv.status__c) {
          this.rollupRecord(piv);
        }
      }
    }

    private void rollupRecord(ProductInstanceView__x piv) {
      if (this.status == 'expired' && piv.entitlement_end_date__c < maxEndDate) {
        return;
      }

      this.minStartDate = (minStartDate > piv.entitlement_start_date__c) ? piv.entitlement_start_date__c : minStartDate;

      if (piv.fulfillment_status__c == 'fulfillment complete') {
        Integer quantity = piv.quantity__c == null ? 0 : Integer.valueOf(piv.quantity__c);
        if (paidSeatMetrics.contains(piv.metric__c)) {
          this.paidSeats += quantity;
        } else if (unpaidpaidSeatMetrics.contains(piv.metric__c)) {
          this.unpaidSeats += quantity;
        }
      }
    }

    private Boolean shouldDisplayMetricDetail(ProductInstanceView__x piv) {
      // only display most recent expired details on expired rollups
      

        
      if (piv.status__c == 'expired') {
        if (piv.entitlement_end_date__c < Datetime.now().addYears(-1).addMonths(-1)) {
          return false;
        }
      }
      if (productName!=null && productName.startsWith('CA Agile Central Unlimited Edition')) {
        if (piv.metric__c != 'PaidSeats' && piv.metric__c != 'UnpaidSeats') {
          return false;
        }
      }
      return true;
    }
  }

  public class ProductInstanceStats {
    public String key {get;set;}
    public Integer count {get;set;}
    public Integer totalSeats {get{
      return totalPaidSeats + totalUnpaidSeats;  
    }}
    public Integer totalPaidSeats {get;set;}
    public Integer totalUnpaidSeats {get;set;}
    public Integer totalIsp {get;set;}
    public Integer penetration {get {
      if (totalIsp == 0) return 0;
      return Decimal.valueOf(totalSeats * 100).divide(totalIsp, 0).intValue();
    }}

    public ProductInstanceStats(String key) {
      this.key = key;
      this.count = 0;
      this.totalPaidSeats = 0;
      this.totalUnpaidSeats = 0;
      this.totalIsp = 0;
    }

    public void addRecord(ProductInstanceRollup rollup) {
      this.count++;
      this.totalPaidSeats += rollup.paidSeats;
      this.totalUnpaidSeats += rollup.unpaidSeats;
      this.totalIsp += Integer.valueOf(rollup.isp);
    }
  }

  public virtual class Selector {

    public virtual ProductInstanceView__x[] selectPivsByGpDunsNumber(String dunsgp) {
        return [SELECT 
                ca_site_id__c,
                duns__c,
                product_instance_id__c,
                instance_id__c,
                product_detail__c,
                name__c,
                entitlement_start_date__c,
                entitlement_end_date__c,
                quantity__c,
                edition__c,
                entitlement_type__c,
                software_type__c,
                metric__c,
                entitlement_id__c,tech_stack__c,                                                               
                fulfillment_status__c,fulfillment_start_date__c,last_update_time__c,sap_contract_number__c,     //Added as part of US325094
                status__c
                FROM ProductInstanceView__x 
                WHERE dunsgp__c =:dunsgp 
                AND  product_instance_id__c != NULL // NOTE: this will hide unprovisioned Idea Manager Sites...
                AND (NOT name__c LIKE '%PPM%') //PORAS01 - Excluded PPM products
                ORDER BY product_detail__c ASC, name__c ASC, product_instance_id__c ASC, entitlement_start_date__c ASC
               ];
    }

    public virtual Site_Association__c[] selectSitesBySapSiteId(Set<String> siteIds) {
      return [SELECT Id, Name, ISP__c, SAP_Site_ID__c FROM Site_Association__c WHERE SAP_Site_ID__c IN :siteIds];
    }

    public virtual Account selectAccountById(Id accountId) {
      Account[] accts = [SELECT Name, GU_DUNS_NUMBER__c FROM Account WHERE Id = :accountId];
      if (accts.size() == 0) {
        return null;
      }
      return accts[0];
    }

    public virtual Report selectProductInstanceContactsReport() {
      Report[] results = [SELECT ID FROM Report WHERE DeveloperName = 'Product_Instance_Contacts_Report'];
      if (results.size() > 0) {
        return results[0];
      }
      return null;
    }
  }

  // Allow anyone with access to this page to edit ISP.
  // 'without sharing' will override both profile security and sharing access rules.
  public without sharing class UpdateIspController {
    public void execute(Id siteId, Integer isp) {
      update new Site_Association__c(Id = siteId, ISP__c = isp);
    }
  }

  
}