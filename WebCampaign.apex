----------------------------------------------------Handler--------------------------------------------

public class WebCampaign_Handler {
    
    public static void createCampaignMember(List<Lead> ld_list)
    {
         List<CampaignMember> campMem = new List<CampaignMember>();
   		   List<Lead> ld_camp = new List<Lead>();
           
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
        if(ld.LeadSource == 'Web')
        {
            CampaignMember member = new CampaignMember(
			LeadId=ld.Id,
			CampaignId=camp.Id);
      member.Status = 'Ticket Taken';
			campMem.add(member);

        }
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
    
