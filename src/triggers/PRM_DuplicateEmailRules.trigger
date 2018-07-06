trigger PRM_DuplicateEmailRules on Email_Rule__c (before insert, before update) {
		
		set<string> emailAttributes = new Set<string>();
		set<string> emailAttributes_existing = new Set<string>();
		
		for(Email_Rule__c er:Trigger.New)
		{
			
			
			string level = er.Partner_Program_Level__c;
			if(level == null) level = '';
			string dp = er.Deal_Registration_Program__c;
			if(dp <> null)  
				dp = dp.substring(0, 15) ;
			else
				dp = '';	
			
			if(er.Action__c == null)
				er.Action__c.addError('Please enter Action');
		
			if(er.Object__c == null)
				er.Object__c.addError('Please enter Object');
				
			
			if(er.Email_Capability__c.contains('Deal'))
				{
					if(er.Deal_Registration_Program__c == null)
						er.Action__c.addError('Please enter Deal Registration Program');
				
				}
			
			string emailattribute = er.Email_Capability__c + ';' + er.Action__c + ';' + dp +';' +(level.contains('Premier')?'Premier':'') +';' + (level.contains('Advanced')?'Advanced':'') +';' + (level.contains('Member')?'Member':'')  + ';' + (er.Region__c ==null?'':er.Region__c);
			if(emailAttributes.contains(emailattribute))
				er.addError('Duplicate rules with the same Capability, Action' + (er.Email_Capability__c.contains('Deal')?', Deal Registration Program, Partner Program Level':'')  + ' are not allowed');
			else
				emailAttributes.add(emailattribute);
				
		}
		
		
		email_rule__c[] ers; 
		if(Trigger.isInsert)
			ers = [select Id, Action__c, Region__c, Email_Capability__c, Partner_Program_Level__c, Deal_Registration_Program__c, Email_Rule_Attributes__c from Email_Rule__c Where Email_Rule_Attributes__c in : emailAttributes ];
		else
			ers = [select Id, Action__c, Region__c, Email_Capability__c, Partner_Program_Level__c, Deal_Registration_Program__c,  Email_Rule_Attributes__c from Email_Rule__c Where Email_Rule_Attributes__c in : emailAttributes and id not in : Trigger.New ];
				
		if(ers<> null && ers.size() > 0)
		{
			for(Email_Rule__c er:ers)
			{
			string level = er.Partner_Program_Level__c;
			if(level == null) level = '';
			string dp = er.Deal_Registration_Program__c;
			if(dp <> null)  
				dp = dp.substring(0, 15) ;
			else
				dp = '';	
				
				string emailattribute = er.Email_Capability__c + ';' + er.Action__c + ';' + dp +';' +(level.contains('Premier')?'Premier':'') +';' + (level.contains('Advanced')?'Advanced':'') +';' + (level.contains('Member')?'Member':'')+ ';' + (er.Region__c ==null?'':er.Region__c);
				emailAttributes_existing.add(emailattribute);
			}
		}	
		
		for(Email_Rule__c er:Trigger.New)
		{
			string level = er.Partner_Program_Level__c;
			if(level == null) level = '';
			string dp = er.Deal_Registration_Program__c;
			if(dp <> null)  
				dp = dp.substring(0, 15) ;
			else
				dp = '';	
			
			string emailattribute = er.Email_Capability__c + ';' + er.Action__c + ';' + dp +';' +(level.contains('Premier')?'Premier':'') +';' + (level.contains('Advanced')?'Advanced':'') +';' + (level.contains('Member')?'Member':'')+ ';' + (er.Region__c ==null?'':er.Region__c);
			if(emailAttributes_existing.contains(emailattribute))
				er.addError('Duplicate rules with the same Capability, Action' + (er.Email_Capability__c.contains('Deal')?', Deal Registration Program, Partner Program Level':'')  + ' are not allowed');
			//er.addError(emailattribute);
			
		}
		
		
}