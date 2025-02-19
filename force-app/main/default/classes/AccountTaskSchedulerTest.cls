@isTest
public class AccountTaskSchedulerTest {

    @isTest
    static void testScheduler() {
        // Utiliser DataFactory pour créer des données de test
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account acc = DataFactory.createAccount('Test Account ' + i);
            testAccounts.add(acc);
        }

        // Créer des tâches pour certains des comptes
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

        System.assertEquals(1, triggers.size(), 'One cron trigger should be created.');
        System.assertEquals('Test Account Task Scheduler', triggers[0].CronJobDetail.Name, 'Job name should match.');
        System.assertEquals('WAITING', triggers[0].State, 'Job state should be WAITING.');

        // Unschedule the job to clean up
        System.abortJob(jobId);

        // Verify that the job was unscheduled successfully
        triggers = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(0, triggers.size(), 'No cron triggers should exist after aborting the job.');
    }
}
