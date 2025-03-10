/**
 * Test class for the AccountTaskScheduler.
 * This class contains unit tests to verify the functionality of the AccountTaskScheduler,
 * ensuring that the batch job is scheduled and executed correctly.
 */
@isTest
public class AccountTaskSchedulerTest {

    /**
     * Test method to verify the scheduling and execution of the AccountTaskBatch job.
     * This test ensures that the scheduler correctly schedules the batch job and that it can be unscheduled properly.
     */
    @isTest
    static void testScheduler() {
        // Use DataFactory for create Account
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account acc = DataFactory.createAccount('Test Account ' + i);
            testAccounts.add(acc);
        }

        // Create tasks for accounts
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

        // Create an instance of the scheduler
        AccountTaskScheduler scheduler = new AccountTaskScheduler();

        // Start the test context
        Test.startTest();

        // Schedule the job
        String cronExpression = '0 0 8 ? * 2#1';
        String jobId = System.schedule('Test Account Task Scheduler', cronExpression, scheduler);

        // Stop the test context to ensure the async job is executed
        Test.stopTest();

        // Verify that the job was scheduled successfully
        List<CronTrigger> triggers = [SELECT Id, CronJobDetail.Name, State
                                      FROM CronTrigger
                                      WHERE Id = :jobId];

        Assert.areEqual(1, triggers.size(), 'One cron trigger should be created.');
        Assert.areEqual('Test Account Task Scheduler', triggers[0].CronJobDetail.Name, 'Job name should match.');
        Assert.areEqual('WAITING', triggers[0].State, 'Job state should be WAITING.');

        // Unschedule the job to clean up
        System.abortJob(jobId);

        // Verify that the job was unscheduled successfully
        triggers = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
        Assert.areEqual(0, triggers.size(), 'No cron triggers should exist after aborting the job.');
    }
}