trigger OrderTrigger on Order (after delete) {
    if (Trigger.isAfter && Trigger.isDelete) {
        OrderTriggerHandler.handleAfterDelete(Trigger.old);
    }
}