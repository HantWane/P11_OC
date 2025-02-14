/**
 * Test class for the OrderTriggerHandler Apex class.
 * Contains unit tests to verify the functionality of the trigger handler methods.
 */
@isTest
public class OrderTriggerHandlerTest {

    /**
     * Setup method to create test data before any test methods in the class are executed.
     * Creates test accounts and orders using the DataFactory utility class.
     */
    @testSetup
    static void setup() {
        // Create test accounts using DataFactory
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account acc = DataFactory.createAccount('Test Account ' + i);
            acc.Active__c = true;
            update acc;
            testAccounts.add(acc);
        }

        // Create test orders for the accounts using DataFactory
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 3; i++) {
            Order order = DataFactory.createOrder(testAccounts[i].Id, 'Draft', Date.today(), 0.0);
            testOrders.add(order);
        }
    }

    /**
     * Test method to verify the handleAfterDelete method in OrderTriggerHandler.
     * Ensures that the Active__c field on related Accounts is updated correctly after an Order is deleted.
     */
    @isTest
    static void testHandleAfterDelete() {
        // Retrieve the test accounts and orders
        List<Account> accounts = [SELECT Id, Active__c FROM Account];
        List<Order> orders = [SELECT Id, AccountId FROM Order];

        // Delete one order to trigger the handler
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