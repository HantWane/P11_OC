/**
 * Trigger for the Order object that executes after delete operations.
 * This trigger invokes the OrderTriggerHandler to update related Account records
 * when an Order is deleted.
 */
trigger OrderTrigger on Order (after delete) {
    /**
     * Checks if the trigger context is after delete.
     * If true, calls the handleAfterDelete method in OrderTriggerHandler to process the deleted orders.
     */
    if (Trigger.isAfter && Trigger.isDelete) {
        OrderTriggerHandler.handleAfterDelete(Trigger.old);
    }
}