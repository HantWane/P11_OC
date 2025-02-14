/**
 * Test class for the OrderTrigger Apex trigger.
 * Contains unit tests to verify the functionality of the trigger when orders are deleted.
 */
@isTest
public class OrderTriggerTest {

    /**
     * Setup method to create test data before any test methods in the class are executed.
     * Creates test accounts and orders to be used in the tests.
     */
    @testSetup
    static void setup() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, Active__c = true);
            testAccounts.add(acc);
        }
        insert testAccounts;

        // Create test orders for the accounts
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 3; i++) {
            Order order = new Order(
                Name = 'Test Order ' + i,
                AccountId = testAccounts[i].Id,
                Status = 'Draft',
                EffectiveDate = Date.today()
            );
            testOrders.add(order);
        }
        insert testOrders;
    }

    /**
     * Test method to verify the behavior of the OrderTrigger when an order is deleted.
     * Ensures that the Active__c field on related Accounts is updated correctly after an Order is deleted.
     */
    @isTest
    static void testOrderDeletion() {
        // Retrieve the test accounts and orders
        List<Account> accounts = [SELECT Id, Active__c FROM Account];
        List<Order> orders = [SELECT Id, AccountId FROM Order];

        // Delete one order to trigger the OrderTrigger
        Test.startTest();
        delete orders[0];
        Test.stopTest();

        // Verify that the account's Active__c field is updated correctly
        Account accountWithRemainingOrders = [SELECT Id, Active__c FROM Account WHERE Id = :accounts[1].Id];
        Account accountWithoutOrders = [SELECT Id, Active__c FROM Account WHERE Id = :accounts[0].Id];

        Assert.areEqual(true, accountWithRemainingOrders.Active__c, 'The account with remaining orders should be active.');
        Assert.areEqual(false, accountWithoutOrders.Active__c, 'The account without orders should be inactive.');
    }
}