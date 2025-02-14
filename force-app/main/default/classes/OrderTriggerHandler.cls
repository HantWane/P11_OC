
public class OrderTriggerHandler {
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