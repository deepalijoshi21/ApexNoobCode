---------------------------------------------------------Handler--------------------------------

public class OppRenewHandler {
       
    public static void createNewOpportunity(List<Opportunity> OppList , List<Opportunity> OppListOld , String Action)
    {
        List<Opportunity> ren_opp_List = new List<Opportunity>();
        
        Id recordTypeId;
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Renewal' LIMIT 1];
		recordTypeId = rt.Id;
        
        System.debug('----------------------' + Action + '-----------------------');
        System.debug('Record Id =====>' + recordTypeId);
        System.debug('New =========>' + OppList);
        System.debug('Old =========>' + OppListOld);
        
        for(Opportunity opp : OppList)
        {
            if(opp.StageName == 'Closed Won')
            {
                Opportunity renew = opp.clone();               
                renew.Name = opp.Name + ' Renewed';
                renew.CloseDate = renew.CloseDate.addDays(30);
                renew.RecordTypeId = recordTypeId;
                renew.StageName = 'Renewal';
                ren_opp_List.add(renew);
                
                System.debug('Cloned Id =========> ' +renew);
                
            }
              
        }
        
        	if(!ren_opp_List.isEmpty()) {
        	insert ren_opp_List;
    }
        
   

 	}
        
}


-------------------------------------------------Trigger----------------------------------------------

trigger OppRenew on Opportunity (after insert , after update) {
    
    if(Trigger.IsInsert)
    {
        OppRenewHandler.createNewOpportunity(Trigger.new , Trigger.old , 'Insert');
        
    }
        if(Trigger.IsUpdate)
    {
        OppRenewHandler.createNewOpportunity(Trigger.new , Trigger.old , 'Update' );
        
    }
    
   
}



