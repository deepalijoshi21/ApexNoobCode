---------------------------------------------------------Handler--------------------------------

public class OppRenewHandler {
       
    public static void createNewOpportunity(List<Opportunity> OppList , Map<Id,Opportunity> OppOldMap , String Action)
    {
        List<Opportunity> ren_opp_List = new List<Opportunity>();
        
        Id recordTypeId;
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Renewal' LIMIT 1];
		recordTypeId = rt.Id;
        
        System.debug('----------------------' + Action + '-----------------------');
        System.debug('Record Id =====>' + recordTypeId);
        System.debug('New =========>' + OppList);
        System.debug('Old =========>' + OppOldMap);
        
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
        
        try{
                 for(Opportunity opp : OppList)
            {
                 if(OppOldMap.get(opp.Id) != null)
                 {
                     Opportunity oldOpp = OppOldMap.get(opp.Id);
                                 
           		 if(!ren_opp_List.isEmpty() && oldOpp.StageName != opp.StageName)
                 {
        		 insert ren_opp_List;
   			     } 
                 }
                
            }   
            
        }
        
        catch(exception ex)
        {
            System.debug('Exception =======>' + ex);
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



