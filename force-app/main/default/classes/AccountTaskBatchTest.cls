/**
 * Test class for the AccountTaskBatch Apex batch process.
 * This class contains unit tests to verify the functionality of the batch process.
 */
@isTest
public class AccountTaskBatchTest {

    /**
     * Setup method to create test data before any test methods in the class are executed.
     * Creates test accounts and tasks for some of the accounts.
     */
    @testSetup
    static void setup() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, Active__c = false);
            testAccounts.add(acc);
        }
        insert testAccounts;

        // Create tasks for some of the accounts
        List<Task> testTasks = new List<Task>();
        for (Integer i = 0; i < 3; i++) {
            Task task = new Task(
                Subject = 'Appel de test',
                WhatId = testAccounts[i].Id,
                Status = 'Completed',
                Priority = 'Normal'
            );
            testTasks.add(task);
        }
        insert testTasks;
    }

    /**
     * Test method to verify the batch processing functionality.
     * Ensures that tasks are created for accounts without existing "appel" tasks.
     */
    @isTest
    static void testBatchProcessing() {
        // Execute the batch
        Test.startTest();
        Database.executeBatch(new AccountTaskBatch());
        Test.stopTest();

        // Verify that tasks were created for accounts without existing "appel" tasks
        List<Account> accounts = [SELECT Id, (SELECT Id FROM Tasks WHERE Subject = 'Call') FROM Account];
        Integer expectedTaskCount = 2; // Only 2 accounts should get new tasks
        Integer actualTaskCount = 0;

        for (Account acc : accounts) {
            actualTaskCount += acc.Tasks.size();
        }

        Assert.areEqual(expectedTaskCount, actualTaskCount, 'The number of tasks created is incorrect.');
    }
}