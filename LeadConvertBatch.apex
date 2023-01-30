public class BatchLeadConvert implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([Select Id , Name , Status From Lead Where IsConverted = False]);
    }
    
    public void execute(Database.BatchableContext bc , List<Lead> Leads)
    {
       List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        for(Lead lead : Leads)
        {
            lead.Status = 'Closed - Converted';
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setConvertedStatus(lead.Status);
            lc.setLeadId(lead.Id);
            lc.setDoNotCreateOpportunity(false);
            
            leadConverts.add(lc);           
        }
        Database.convertLead(leadConverts);
    }
    
    public void finish(Database.BatchableContext bc)
    {
        System.debug('Batch Finish');
    }

}
