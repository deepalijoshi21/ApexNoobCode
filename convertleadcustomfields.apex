public class convertcheck_handler {
    
   public static Map<Id, Map<String, Id>> ldConvert(List<Lead> ld_list)
{
    List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
    Map<Id, Map<String, Id>> resultMap = new Map<Id, Map<String, Id>>();

    for (Lead lead : ld_list) {
        if (lead.Converted__c == true && lead.IsConverted == false) {
            Database.LeadConvert lc = new Database.LeadConvert();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            lc.setLeadId(lead.Id);
            lc.setDoNotCreateOpportunity(true);
            leadConverts.add(lc);
        }
    }
    if (!leadConverts.isEmpty()) {
        List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
        for (Database.LeadConvertResult result : results) {
            if (result.isSuccess()) {
                Map<String, Id> innerMap = new Map<String, Id>();
                innerMap.put('LeadId', result.getLeadId());
                innerMap.put('AccountId', result.getAccountId());
                innerMap.put('ContactId', result.getContactId());
                resultMap.put(result.getLeadId(), innerMap);
            }
        }
        putLeadIdInAcc(resultMap);
    }
    return resultMap;
    
}

    public static void putLeadIdInAcc(Map<Id, Map<String, Id>> resultMap) {
        
        List<Account> upAcc = new List<Account>();
        List<Contact> upCon = new List<Contact>();
        
        for (Id leadId : resultMap.keySet()) {
            Map<String, Id> innerMap = resultMap.get(leadId);
           // Id LeadId = leadId;
            Id LdId = innerMap.get('LeadId');
            Id AccId = innerMap.get('AccountId');
            Id CId = innerMap.get('ContactId');
            System.debug('Lead Id: ' + LdId + ' Account Id: ' + AccId  + ' Contact Id: ' + CId);
            
            Account acc = new Account();
            acc.id=AccId;
            acc.Lead_field__c = LdId;
            upAcc.add(acc);
            
            Contact con = new Contact();
            con.id=CId;
            con.Lead_field__c = LdId;
            upCon.add(con);
            
        }
        update upAcc;
        update upCon;
    }
  }
        
   -----------------------------------------------------------------------Trigger-----------------------------------------------------
   
trigger leadScoreCustomTrigger on Lead (before insert, before update) {
    

      
}
  
