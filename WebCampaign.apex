----------------------------------------------------Handler--------------------------------------------

public class WebCampaign_Handler {
    
    public static void createCampaignMember(List<Lead> ld_list)
    {
         List<CampaignMember> campMem = new List<CampaignMember>();
   		 List<Lead> ld_camp = new List<Lead>();
         List<Task> tsk = new List<Task>();
    
    for(Lead ld :ld_list)
    {
        if(ld.LeadSource == 'Web')
        {
            ld_camp.add(ld);           
        }
    }    
    Campaign camp =
    [Select Id , Name From 
     Campaign Where Name = 'Sunburn'];
    
    for(Lead ld : ld_camp)        
    {
            CampaignMember member = new CampaignMember(
			LeadId=ld.Id,
			CampaignId=camp.Id);
            member.Status = 'Ticket Taken';
			campMem.add(member);
            Task task = new Task(WhoId = ld.Id, Subject = 'Send Email', Description = 'Send email to the lead', ActivityDate = Date.today() + 7, Status = 'Not Started');
            tsk.add(task);
        
    }

    if(!tsk.isEmpty())
    {
         insert tsk;   
    }
    if(!campMem.isEmpty())
    {
        insert campMem;
    }
    }
}

    





-----------------------------------------------------------Trigger-------------------------------------

trigger WebCampaign on Lead (after insert) {
    
   WebCampaign_Handler.createCampaignMember(Trigger.new);

}
    
