@IsTest
public class ProductInstanceViewControllerTest {
  private static final Account acct = new Account(Name = 'TestAcct', GU_DUNS_NUMBER__c = '12345');

  /* ProductInstanceViewController Tests */
  @IsTest
  static void updateIsp_should_update_isp() {
    Site_Association__c site = CC_TestUtils.buildNewSite('999');
    insert site;

    Test.startTest();
    ProductInstanceViewController.updateIsp(site.Id, 123);
    Test.stopTest();

    System.assertEquals(123, [SELECT ISP__c FROM Site_Association__c WHERE Id = :site.Id].ISP__c);
  }

  @IsTest
  static void init_should_throw_error_if_account_id_is_missing() {
    ProductInstanceViewController controller = buildController();
    controller.account = null;

    Test.startTest();
    controller.init();
    Test.stopTest();

    ApexPages.Message[] errors = PageUtils.getErrorMessages();
    System.assertEquals('Account ID not provided', errors[0].getSummary());
  }

  @IsTest
  static void init_should_throw_error_if_account_id_is_invalid() {
    ProductInstanceViewController controller = buildController();
    controller.account = null;
    PageUtils.put('accountId', '123');

    Test.startTest();
    controller.init();
    Test.stopTest();

    ApexPages.Message[] errors = PageUtils.getErrorMessages();
    System.assertEquals(PageUtils.get('accountId') + ' is not a valid Account ID', errors[0].getSummary());
  }

  @IsTest
  static void init_should_throw_error_if_account_not_found() {
    ProductInstanceViewController controller = buildController();
    controller.account = null;
    PageUtils.put('accountId', CC_TestUtils.fakeId(Account.sobjectType));

    Test.startTest();
    controller.init();
    Test.stopTest();

    ApexPages.Message[] errors = PageUtils.getErrorMessages();
    System.assertEquals('Could not find Account with ID ' + PageUtils.get('accountId'), errors[0].getSummary());
  }

  @IsTest
  static void init_should_throw_error_if_account_has_no_gp_duns_number() {
    ProductInstanceViewController controller = buildController();
    controller.account.GU_DUNS_NUMBER__c = null;

    Test.startTest();
    controller.init();
    Test.stopTest();

    ApexPages.Message[] errors = PageUtils.getErrorMessages();
    System.assertEquals('There is no GP DUNS Number associated with the account.', errors[0].getSummary());
  }

  @IsTest
  static void init_should_set_title() {
    ProductInstanceViewController controller = buildController();
    setupPivs(new ProductInstanceView__x[]{}, controller);

    Test.startTest();
    controller.init();
    Test.stopTest();

    System.assertEquals('Product Instances for TestAcct - 12345', controller.pageBlockTitle);
  }

  @IsTest
  static void init_should_not_rollup_if_no_pivs_found() {
    ProductInstanceViewController controller = buildController();
    setupPivs(new ProductInstanceView__x[]{}, controller);

    Test.startTest();
    controller.init();
    Test.stopTest();

    System.assertEquals(null, controller.productInstanceRollupMap);
  }

  @IsTest
  static void init_should_rollup_pivs() {
    ProductInstanceViewController controller = buildController();

    ProductInstanceView__x[] pivs = new ProductInstanceView__x[]{
      buildPiv(),
      buildPiv(),
      buildPiv()
    };

    setupPivs(pivs, controller);
    setupSites(new Site_Association__c[]{}, controller);

    Test.startTest();
    controller.init();
    Test.stopTest();

    System.assertEquals(1, controller.productInstanceRollupMap.values().size());
    System.assertEquals(3, controller.productInstanceRollupMap.values()[0].records.size());
  }

  @IsTest
  static void sortBySite_should_sort_by_instance_name() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByInstanceName();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.INSTANCE_NAME, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortBySite_should_sort_by_site() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortBySite();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.SITE_NAME, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByProductInstanceId_should_sort_by_product_instance_id() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByProductInstanceId();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.PRODUCT_INSTANCE_ID, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByStatus_should_sort_by_status() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByStatus();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.STATUS, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByProduct_should_sort_by_product() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByProduct();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.PRODUCT_NAME, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByPaidSeats_should_sort_by_paid_seats() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByPaidSeats();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.PAID_SEATS, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByUnpaidSeats_should_sort_by_unpaid_seats() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByUnpaidSeats();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.UNPAID_SEATS, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByIsp_should_sort_by_isp() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByIsp();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.ISP, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByPenetration_should_sort_by_penetration() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByPenetration();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.PENETRATION, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByStartDate_should_sort_by_start_date() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByStartDate();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.START_DATE, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortByEndDate_should_sort_by_end_date() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = null;

    Test.startTest();
    controller.sortByEndDate();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortColumn.END_DATE, controller.sortCol);
    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_ASC, controller.sortDir);
  }

  @IsTest
  static void sortBy_should_toggle_sort_dir_when_sort_col_does_not_change() {
    ProductInstanceViewController controller = buildController();
    controller.sortCol = ProductInstanceViewController.SortColumn.END_DATE;
    controller.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;

    Test.startTest();
    controller.sortByEndDate();
    Test.stopTest();

    System.assertEquals(ProductInstanceViewController.SortDirection.SORT_DESC, controller.sortDir);
  }

  @IsTest
  static void createRollupMap_should_rollup_pivs_by_product_instance_id() {
    ProductInstanceViewController controller = buildController();
    ProductInstanceView__x[] pivs = new ProductInstanceView__x[]{
      buildPiv(new Map<String,Object>{'product_instance_id__c' => '111'}),
      buildPiv(new Map<String,Object>{'product_instance_id__c' => '111'}),
      buildPiv(new Map<String,Object>{'product_instance_id__c' => '222'})
    };
    setupSites(new Site_Association__c[]{}, controller);

    Test.startTest();
    Map<String, ProductInstanceViewController.ProductInstanceRollup> rollupMap = controller.createRollupMap(pivs);
    Test.stopTest();

    System.assertEquals(2, rollupMap.keySet().size());
    System.assert(rollupMap.keySet().contains('111ALM'));
    System.assertEquals(2, rollupMap.get('111ALM').records.size());
    System.assert(rollupMap.keySet().contains('222ALM'));
    System.assertEquals(1, rollupMap.get('222ALM').records.size());

  }

  @IsTest
  static void createRollupMap_should_enrich_rollup_with_site_record() {
    ProductInstanceViewController controller = buildController();
    ProductInstanceView__x[] pivs = new ProductInstanceView__x[]{
      buildPiv()
    };

    Site_Association__c[] sites = new Site_Association__c[]{
      new Site_Association__c(Id = CC_TestUtils.fakeId(Site_Association__c.sobjectType), 
        ISP__c = 50, 
        SAP_Site_ID__c = '111')
    };

    setupSites(sites, controller);

    Test.startTest();
    Map<String, ProductInstanceViewController.ProductInstanceRollup> rollupMap = controller.createRollupMap(pivs);
    Test.stopTest();
	

      
    ProductInstanceViewController.ProductInstanceRollup rollup = rollupMap.get('333ALM');
    System.assertEquals(sites[0], rollup.siteRecord);

  }

  @IsTest
  static void buildStatsByProduct_should_build_stats_by_product() {
    ProductInstanceViewController controller = buildController();

    ProductInstanceViewController.ProductInstanceRollup[] data = new ProductInstanceViewController.ProductInstanceRollup[] {
      buildPiRollup(new Map<String, Object>{'productName' => 'UE', 'status' => 'active', 'paidSeats' => 1, 'unpaidSeats' => 1, 'siteRecord' => new Site_Association__c(ISP__c = 1)}),
      buildPiRollup(new Map<String, Object>{'productName' => 'EE', 'status' => 'active', 'paidSeats' => 1, 'unpaidSeats' => 1, 'siteRecord' => new Site_Association__c(ISP__c = 1)}),
      buildPiRollup(new Map<String, Object>{'productName' => 'UE', 'status' => 'active', 'paidSeats' => 1, 'unpaidSeats' => 1, 'siteRecord' => new Site_Association__c(ISP__c = 1)}),
      buildPiRollup(new Map<String, Object>{'productName' => 'EE', 'status' => 'not active', 'paidSeats' => 1, 'unpaidSeats' => 1, 'siteRecord' => new Site_Association__c(ISP__c = 1)})
    };

    Test.startTest();
    ProductInstanceViewController.ProductInstanceStats[] stats = controller.buildStatsByProduct(data);
    Test.stopTest();

    System.assertEquals(2, stats.size());
    
    System.assertEquals('UE', stats[0].key);
    System.assertEquals(2, stats[0].count);
    System.assertEquals(4, stats[0].totalSeats);
    System.assertEquals(2, stats[0].totalPaidSeats);
    System.assertEquals(2, stats[0].totalUnpaidSeats);
    System.assertEquals(2, stats[0].totalIsp);
    System.assertEquals(200, stats[0].penetration);

    System.assertEquals('EE', stats[1].key);
    System.assertEquals(1, stats[1].count);
    System.assertEquals(2, stats[1].totalSeats);
    System.assertEquals(1, stats[1].totalPaidSeats);
    System.assertEquals(1, stats[1].totalUnpaidSeats);
    System.assertEquals(1, stats[1].totalIsp);
    System.assertEquals(200, stats[1].penetration);
  }

  @IsTest
  static void buildStatsByProduct_should_igmore_inactive_records() {
    ProductInstanceViewController controller = buildController();

    ProductInstanceViewController.ProductInstanceRollup[] data = new ProductInstanceViewController.ProductInstanceRollup[] {
      buildPiRollup(new Map<String, Object>{'productName' => 'EE', 'status' => 'not active', 'paidSeats' => 1, 'unpaidSeats' => 1, 'siteRecord' => new Site_Association__c(ISP__c = 1)})
    };

    Test.startTest();
    ProductInstanceViewController.ProductInstanceStats[] stats = controller.buildStatsByProduct(data);
    Test.stopTest();

    System.assertEquals(0, stats.size());
  }


  /* InsertionSorter Tests */
  @IsTest
  static void InsertionSorter_should_sort_data_asc() {
    ProductInstanceViewController.ProductInstanceRollup[] data = new ProductInstanceViewController.ProductInstanceRollup[] {
      buildPiRollup(new Map<String, Object>{'productInstanceId' => '234'}),
      buildPiRollup(new Map<String, Object>{'productInstanceId' => '345'}),
      buildPiRollup(new Map<String, Object>{'productInstanceId' => '123'})
    };

    System.assertEquals('234', data[0].productInstanceId);
    System.assertEquals('345', data[1].productInstanceId);
    System.assertEquals('123', data[2].productInstanceId);


    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(
      data, 
      ProductInstanceViewController.SortDirection.SORT_ASC,
      ProductInstanceViewController.SortColumn.PRODUCT_INSTANCE_ID
    );

    Test.startTest();
    sorter.sort();
    Test.stopTest();

    System.assertEquals('123', data[0].productInstanceId);
    System.assertEquals('234', data[1].productInstanceId);
    System.assertEquals('345', data[2].productInstanceId);
  }

  @IsTest
  static void InsertionSorter_should_sort_data_desc() {
    ProductInstanceViewController.ProductInstanceRollup[] data = new ProductInstanceViewController.ProductInstanceRollup[] {
      buildPiRollup(new Map<String, Object>{'productInstanceId' => '234'}),
      buildPiRollup(new Map<String, Object>{'productInstanceId' => '345'}),
      buildPiRollup(new Map<String, Object>{'productInstanceId' => '123'})
    };

    System.assertEquals('234', data[0].productInstanceId);
    System.assertEquals('345', data[1].productInstanceId);
    System.assertEquals('123', data[2].productInstanceId);


    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(
      data, 
      ProductInstanceViewController.SortDirection.SORT_DESC,
      ProductInstanceViewController.SortColumn.PRODUCT_INSTANCE_ID
    );

    Test.startTest();
    sorter.sort();
    Test.stopTest();

    System.assertEquals('345', data[0].productInstanceId);
    System.assertEquals('234', data[1].productInstanceId);
    System.assertEquals('123', data[2].productInstanceId);
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_product_instance_id() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.PRODUCT_INSTANCE_ID;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'productInstanceId' => '111'});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'productInstanceId' => '999'});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));
    System.assertEquals(false, sorter.shouldExchange(upper, upper));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
    System.assertEquals(false, sorter.shouldExchange(upper, upper));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_instance_id() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.INSTANCE_ID;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'instanceId' => '111'});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'instanceId' => '999'});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_status() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.STATUS;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'status' => '111'});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'status' => '999'});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_instance_name() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.INSTANCE_NAME;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'instanceName' => 'Instance 1'});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'instanceName' => 'Instance 2'});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_site_name() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.SITE_NAME;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'caSiteId' => 111, 'siteRecord' => new Site_Association__c(Name = 'Muh Site')});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'caSiteId' => 999, 'siteRecord' => new Site_Association__c(Name = 'Muh Site')});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_site_id() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.SITE_ID;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'caSiteId' => 111});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'caSiteId' => 999});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_product_name() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.PRODUCT_NAME;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'productName' => '111'});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'productName' => '999'});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_start_date() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.START_DATE;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'minStartDate' => Datetime.newInstance(0)});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'minStartDate' => Datetime.newInstance(1)});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_end_date() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.END_DATE;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'maxEndDate' => Datetime.newInstance(0)});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'maxEndDate' => Datetime.newInstance(1)});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_paid_seats() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.PAID_SEATS;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'paidSeats' => 1});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'paidSeats' => 2});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_unpaid_seats() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.UNPAID_SEATS;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'unpaidSeats' => 1});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'unpaidSeats' => 2});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_isp() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.ISP;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'siteRecord' => new Site_Association__c(ISP__c = 1)});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'siteRecord' => new Site_Association__c(ISP__c = 2)});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

  @IsTest
  static void InsertionSorter_shouldExchange_by_penetration() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.PENETRATION;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{ 'paidSeats' => 1, 'siteRecord' => new Site_Association__c(ISP__c = 2)});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{ 'paidSeats' => 2, 'siteRecord' => new Site_Association__c(ISP__c = 2)});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }

   @IsTest
  static void InsertionSorter_shouldExchange_defers_to_product_instance_id_when_equal() {
    ProductInstanceViewController.InsertionSorter sorter = new ProductInstanceViewController.InsertionSorter(null, null, null);

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_ASC;
    sorter.sortCol = ProductInstanceViewController.SortColumn.INSTANCE_ID;

    ProductInstanceViewController.ProductInstanceRollup lower = buildPiRollup(new Map<String, Object>{'productInstanceId' => '111', 'instanceId' => '111'});
    ProductInstanceViewController.ProductInstanceRollup upper = buildPiRollup(new Map<String, Object>{'productInstanceId' => '999', 'instanceId' => '111'});

    System.assertEquals(true, sorter.shouldExchange(lower, upper));
    System.assertEquals(false, sorter.shouldExchange(upper, lower));

    sorter.sortDir = ProductInstanceViewController.SortDirection.SORT_DESC;

    System.assertEquals(false, sorter.shouldExchange(lower, upper));
    System.assertEquals(true, sorter.shouldExchange(upper, lower));
  }


  /* ProductInstanceRollup Tests */
  @IsTest
  static void ProductInstanceRollup_should_set_header_info_when_adding_record() {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv());

    System.assertEquals(1, rollup.records.size());
    System.assertEquals('333', rollup.productInstanceId);
    System.assertEquals('444', rollup.instanceId);
    System.assertEquals('Site Name', rollup.instanceName);
    System.assertEquals(111L, rollup.caSiteId);
    System.assertEquals('ALM', rollup.productName);
  }

  @IsTest
  static void ProductInstanceRollup_should_rollup_details() {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'entitlement_start_date__c' => Datetime.newInstance(-10)
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'entitlement_end_date__c' => Datetime.newInstance(10)
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats'
    }));

    // add some records to ignore
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'fulfillment_status__c' => 'pending fulfillment'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'random metric'
    }));

    rollup.rollup();

    System.assertEquals(Datetime.newInstance(-10), rollup.minStartDate);
    System.assertEquals(Datetime.newInstance(10), rollup.maxEndDate);
    System.assertEquals('active', rollup.status);
    System.assertEquals(20, rollup.paidSeats);
    System.assertEquals(10, rollup.unpaidSeats);
  }

  @IsTest
  static void ProductInstanceRollup_should_calculate_penetration() {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'PaidSeats',
      'quantity__c' => 10
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats',
      'quantity__c' => 10
    }));

    rollup.rollup();

    rollup.siteRecord = new Site_Association__c(ISP__c = 100);

    System.assertEquals(20, rollup.penetration);
  }

  @IsTest
  static void ProductInstanceRollup_penetration_should_not_divide_by_zero() {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'PaidSeats',
      'quantity__c' => 10
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats',
      'quantity__c' => 10
    }));

    rollup.rollup();

    rollup.siteRecord = new Site_Association__c(ISP__c = 0);

    System.assertEquals(0, rollup.penetration);
  }

  @IsTest
  static void ProductInstanceRollup_should_filter_details_for_UE() {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'name__c' => 'CA Agile Central Unlimited Edition SaaS',
      'metric__c' => 'PaidSeats'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'name__c' => 'CA Agile Central Unlimited Edition SaaS',
      'metric__c' => 'UnpaidSeats'
    }));

    // add some records to ignore
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'name__c' => 'CA Agile Central Unlimited Edition SaaS',
      'metric__c' => 'random metric'
    }));

    System.assertEquals(2, rollup.details.size());
    System.assertEquals('PaidSeats', rollup.details[0].metric__c);
    System.assertEquals('UnpaidSeats', rollup.details[1].metric__c);
  }

  @IsTest
  static void ProductInstanceRollup_should_only_show_expired_in_last_13_months() {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    Datetime endDate = Datetime.now();
    rollup.addRecord(buildPiv());
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired',
      'entitlement_end_date__c' => endDate
    }));

    // add some records to ignore
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired',
      'entitlement_end_date__c' => Datetime.newInstance(0)
    }));

    System.assertEquals(3, rollup.records.size());
    System.assertEquals(2, rollup.details.size());
    System.assertEquals(endDate, rollup.details[1].entitlement_end_date__c);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_determine_status_active() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'active'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'cancelled'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));

    rollup.rollup();

    System.assertEquals('active', rollup.status);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_determine_status_expired() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'cancelled'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));

    rollup.rollup();

    System.assertEquals('expired', rollup.status);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_determine_status_cancelled() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'cancelled'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));

    rollup.rollup();

    System.assertEquals('cancelled', rollup.status);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_determine_status_unknown() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));

    rollup.rollup();

    System.assertEquals('unknown', rollup.status);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_only_rollup_data_that_matches_the_determined_status() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'cancelled'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'cancelled'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'unknown'
    }));

    rollup.rollup();

    System.assertEquals('expired', rollup.status);
    System.assertEquals(10, rollup.paidSeats);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_only_rollup_most_recent_expired_data() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired',
      'paidSeats' => 20
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'status__c' => 'expired',
      'entitlement_end_date__c' => Datetime.now(),
      'paidSeats' => 10
    }));

    rollup.rollup();

    System.assertEquals(2, rollup.records.size());
    System.assertEquals('expired', rollup.status);
    System.assertEquals(10, rollup.paidSeats);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_only_rollup_fulfilled_seats() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv());
    rollup.addRecord(buildPiv());
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'fulfillment_status__c' => 'fulfillment pending'
    }));

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats',
      'fulfillment_status__c' => 'fulfillment pending'
    }));

    rollup.rollup();

    System.assertEquals(20, rollup.paidSeats);
    System.assertEquals(20, rollup.unpaidSeats);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_rollup_max_ue_seats_to_unpaid_seats() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'UnpaidSeats'
    }));
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'max_ue_seats'
    }));

    rollup.rollup();

    System.assertEquals(0, rollup.paidSeats);
    System.assertEquals(20, rollup.unpaidSeats);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_rollup_paid_addon_seats_to_paid_seats() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv(new Map<String, Object> {
      'metric__c' => 'paid_addon_seats'
    }));

    rollup.rollup();

    System.assertEquals(10, rollup.paidSeats);
  }

  @IsTest
  static void ProductInstanceRollup_rollup_should_ignore_fulfillment_status_for_dates() { 
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();

    rollup.addRecord(buildPiv());
    rollup.addRecord(buildPiv(new Map<String, Object> {
      'fulfillment_status__c' => 'fulfillment pending',
      'entitlement_start_date__c' => Datetime.newInstance(-10),
      'entitlement_end_date__c' => Datetime.newInstance(10)
    }));

    rollup.rollup();

    System.assertEquals(Datetime.newInstance(-10), rollup.minStartDate);
    System.assertEquals(Datetime.newInstance(10), rollup.maxEndDate);
  }


  /* ProductInstanceStats Tests */
  @IsTest
  static void ProductInstanceStats_should_calculate_stats_for_records() {
    ProductInstanceViewController.ProductInstanceRollup rollup = buildPiRollup(new Map<String, Object> {
      'paidSeats' => 10,
      'unpaidSeats' => 20,
      'siteRecord' => new Site_Association__c(ISP__c = 100)
    });
    ProductInstanceViewController.ProductInstanceStats stats = new ProductInstanceViewController.ProductInstanceStats('my product');
    stats.addRecord(rollup);
    stats.addRecord(rollup);

    System.assertEquals('my product', stats.key);
    System.assertEquals(2, stats.count);
    System.assertEquals(20, stats.totalPaidSeats);
    System.assertEquals(40, stats.totalUnpaidSeats);
    System.assertEquals(60, stats.totalSeats);
    System.assertEquals(200, stats.totalIsp);
    System.assertEquals(30, stats.penetration);
  }

  @IsTest
  static void ProductInstanceStats_penetration_should_not_divide_by_zero() {
    ProductInstanceViewController.ProductInstanceRollup rollup = buildPiRollup(new Map<String, Object> {
      'paidSeats' => 10,
      'siteRecord' => new Site_Association__c(ISP__c = 0)
    });
    ProductInstanceViewController.ProductInstanceStats stats = new ProductInstanceViewController.ProductInstanceStats('my product');
    stats.addRecord(rollup);

    System.assertEquals(0, stats.penetration);
  }


  /* Test Helpers */
  private static ProductInstanceViewController buildController() {
    return buildController(acct, new MockSelector());
  }
  private static ProductInstanceViewController buildController(Account account, ProductInstanceViewController.Selector soqlSelector) {
    ProductInstanceViewController controller = new ProductInstanceViewController();
    controller.account = account;
    controller.soqlSelector = soqlSelector;
    return controller;
  }

  private static ProductInstanceViewController.ProductInstanceRollup buildPiRollup(Map<String, Object> data) {
    ProductInstanceViewController.ProductInstanceRollup rollup = new ProductInstanceViewController.ProductInstanceRollup();
    if (data.containsKey('records')) {
      rollup.records = (ProductInstanceView__x[])data.get('records');
    }
    if (data.containsKey('productInstanceId')) {
      rollup.productInstanceId = (String)data.get('productInstanceId');
    }
    if (data.containsKey('instanceId')) {
      rollup.instanceId = (String)data.get('instanceId');
    }
    if (data.containsKey('instanceName')) {
      rollup.instanceName = (String)data.get('instanceName');
    }
    if (data.containsKey('caSiteId')) {
      rollup.caSiteId = (Long)data.get('caSiteId');
    }
    if (data.containsKey('productName')) {
      rollup.productName = (String)data.get('productName');
    }
    if (data.containsKey('minStartDate')) {
      rollup.minStartDate = (Datetime)data.get('minStartDate');
    }
    if (data.containsKey('maxEndDate')) {
      rollup.maxEndDate = (Datetime)data.get('maxEndDate');
    }
    if (data.containsKey('paidSeats')) {
      rollup.paidSeats = (Integer)data.get('paidSeats');
    }
    if (data.containsKey('unpaidSeats')) {
      rollup.unpaidSeats = (Integer)data.get('unpaidSeats');
    }
    if (data.containsKey('status')) {
      rollup.status = (String)data.get('status');
    }
    if (data.containsKey('siteRecord')) {
      rollup.siteRecord = (Site_Association__c)data.get('siteRecord');
    }
    return rollup;
  }

  private static ProductInstanceView__x buildPiv() {
    //return buildPiv('333');
    return buildPiv(new Map<String,Object>{});
  }
  private static ProductInstanceView__x buildPiv(Map<String,Object> data) {

    ProductInstanceView__x piv = new ProductInstanceView__x();
    if (data.containsKey('ca_site_id__c')) {
      piv.ca_site_id__c = (String)data.get('ca_site_id__c');
    } else {
      piv.ca_site_id__c = '111';
    }
    if (data.containsKey('duns__c')) {
      piv.duns__c = (String)data.get('duns__c');
    } else {
      piv.duns__c = '222';
    }
    if (data.containsKey('product_instance_id__c')) {
      piv.product_instance_id__c = (String)data.get('product_instance_id__c');
    } else {
      piv.product_instance_id__c = '333';
    }
    if (data.containsKey('instance_id__c')) {
      piv.instance_id__c = (String)data.get('instance_id__c');
    } else {
      piv.instance_id__c = '444';
    }
    if (data.containsKey('product_detail__c')) {
      piv.product_detail__c = (String)data.get('product_detail__c');
    } else {
      piv.product_detail__c = 'Site Name';
    }
    if (data.containsKey('name__c')) {
      piv.name__c = (String)data.get('name__c');
    } else {
      piv.name__c = 'ALM';
    }
    if (data.containsKey('entitlement_start_date__c')) {
      piv.entitlement_start_date__c = (Datetime)data.get('entitlement_start_date__c');
    } else {
      piv.entitlement_start_date__c = Datetime.newInstance(0);
    }
    if (data.containsKey('entitlement_end_date__c')) {
      piv.entitlement_end_date__c = (Datetime)data.get('entitlement_end_date__c');
    } else {
      piv.entitlement_end_date__c = Datetime.newInstance(1);
    }
    if (data.containsKey('quantity__c')) {
      piv.quantity__c = (Decimal)data.get('quantity__c');
    } else {
      piv.quantity__c = 10;
    }
    if (data.containsKey('metric__c')) {
      piv.metric__c = (String)data.get('metric__c');
    } else {
      piv.metric__c = 'PaidSeats';
    }
    if (data.containsKey('fulfillment_status__c')) {
      piv.fulfillment_status__c = (String)data.get('fulfillment_status__c');
    } else {
      piv.fulfillment_status__c = 'fulfillment complete';
    }
    if (data.containsKey('status__c')) {
      piv.status__c = (String)data.get('status__c');
    } else {
      piv.status__c = 'active';
    }

    return piv;
  }

  private static void setupPivs(ProductInstanceView__x[] pivs, ProductInstanceViewController controller) {
    MockSelector soqlSelector = (MockSelector)controller.soqlSelector;
    soqlSelector.callLogger.recordCall(
      'selectPivsByGpDunsNumber', 
      null,
      pivs
    ); 
  }

  private static void setupSites(Site_Association__c[] sites, ProductInstanceViewController controller) {
    MockSelector soqlSelector = (MockSelector)controller.soqlSelector;
    soqlSelector.callLogger.recordCall(
      'selectSitesBySapSiteId', 
      null,
      sites
    ); 
  }

  public class MockSelector extends ProductInstanceViewController.Selector {
    public CC_MockCallRecorder callLogger { get; private set; }

    public MockSelector() {
      callLogger = new CC_MockCallRecorder();
    }

    public override ProductInstanceView__x[] selectPivsByGpDunsNumber(String dunsgp) {
      String methodName = 'selectPivsByGpDunsNumber';
      Map<String, Object> params = new Map<String, Object> {'dunsgp' => dunsgp};
      Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
      callLogger.logCall(methodName, params, returnValue);
      return (ProductInstanceView__x[])returnValue;
    }

    public override Site_Association__c[] selectSitesBySapSiteId(Set<String> siteIds) {
      String methodName = 'selectSitesBySapSiteId';
      Map<String, Object> params = new Map<String, Object> {'siteIds' => siteIds};
      Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
      callLogger.logCall(methodName, params, returnValue);
      return (Site_Association__c[])returnValue;
    }
  }
}