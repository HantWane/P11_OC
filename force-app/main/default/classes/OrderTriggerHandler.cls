/**
 * Handler class for managing Order-related trigger logic in Salesforce.
 */
public class OrderTriggerHandler {

    /**
     * Handles the after delete event for Orders.
     * This method updates the Active__c field on related Accounts based on the presence of Orders.
     *
     * @param deletedOrders A list of Order records that have been deleted.
     */
    public static void handleAfterDelete(List<Order> deletedOrders) {
        Set<Id> accountIds = new Set<Id>();

        // Collect all account IDs from the deleted orders
        for (Order order : deletedOrders) {
            accountIds.add(order.AccountId);
        }

        // Query all accounts with the collected account IDs
        List<Account> accountsToUpdate = [SELECT Id, Active__c, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accountIds];

        // Update the Active__c field based on the presence of orders
        for (Account account : accountsToUpdate) {
            account.Active__c = !account.Orders.isEmpty();
        }

        // Update the accounts in the database
        update accountsToUpdate;
    }
}