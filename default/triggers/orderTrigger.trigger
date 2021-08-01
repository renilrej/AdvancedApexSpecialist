/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (after update) 
{
    if(Trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
        }
    }
}

    
