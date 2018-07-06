@isTest(SeeAllData = true)
private class SplitStatusControllerTest {

    static testMethod void myUnitTest() {
        SplitStatusController c = new SplitStatusController();
        c.loadAll();
        c.getRenderButtons();
        c.getETA1();
        c.getETA2();
		c.explain(null, null);        
		c.explain('(0)', null);        
		c.explain(null, '(1)');        
		c.explain(null, '(2)');        
		c.explain(null, '(3)');        
		c.explain(null, '(4)');        
		c.explain(null, '(5)');        
		c.explain(null, 'OTHER');
		        
		c.explain('(1)', null);        
		c.explain('(1)', '(1)');        
		c.explain('(1)', '(2)');        
		c.explain('(1)', '(3)');        
		c.explain('(1)', '(4)');        
		c.explain('(1)', '(5)');        
		c.explain('(1)', 'OTHER');
		        
		c.explain('(2)', null);        
		c.explain('(2)', '(1)');        
		c.explain('(2)', '(2)');        
		c.explain('(2)', '(3)');        
		c.explain('(2)', '(4)');        
		c.explain('(2)', '(5)');        
		c.explain('(2)', 'OTHER');
		        
		c.explain('(3)', null);        
		c.explain('(3)', '(1)');        
		c.explain('(3)', '(2)');        
		c.explain('(3)', '(3)');        
		c.explain('(3)', '(4)');        
		c.explain('(3)', '(5)');        
		c.explain('(3)', 'OTHER');
		        
		c.explain('(4)', null);        
		c.explain('(4)', '(1)');        
		c.explain('(4)', '(2)');        
		c.explain('(4)', '(3)');        
		c.explain('(4)', '(4)');        
		c.explain('(4)', '(5)');        
		c.explain('(4)', 'OTHER');
		        
		c.explain('(5)', null);        
		c.explain('(5)', '(1)');        
		c.explain('(5)', '(2)');        
		c.explain('(5)', '(3)');        
		c.explain('(5)', '(4)');        
		c.explain('(5)', '(5)');        
		c.explain('(5)', 'OTHER');
		        
		c.explain('(6)', null);        
		c.explain('(6)', '(1)');        
		c.explain('(6)', '(2)');        
		c.explain('(6)', '(3)');        
		c.explain('(6)', '(4)');        
		c.explain('(6)', '(5)');        
		c.explain('(6)', 'OTHER');
		        
		c.explain('(7)', null);        
		c.explain('(7)', '(1)');        
		c.explain('(7)', '(2)');        
		c.explain('(7)', '(3)');        
		c.explain('(7)', '(4)');        
		c.explain('(7)', '(5)');        
		c.explain('(7)', 'OTHER');
		        
		SplitStatusController.SplitStatusLine sl = new SplitStatusController.SplitStatusLine();
		
        c.startFirstBatch();
        c.startSecondBatch();
    }
}