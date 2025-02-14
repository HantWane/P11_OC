public class AccountTaskBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all accounts that are inactive and do not have a task with "appel" in the name
        return Database.getQueryLocator([
            SELECT Id, (SELECT Id FROM Tasks WHERE Subject LIKE '%call%')
            FROM Account
            WHERE Active__c = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Task> tasksToInsert = new List<Task>();

        for (Account account : scope) {
            // Check if there are no tasks with "appel" in the name
            if (account.Tasks.isEmpty()) {
                Task newTask = new Task(
                    Subject = 'Call',
                    Status = 'Nouvelle',
                    Priority = 'Normale',
                    ActivityDate = Date.today().addDays(5),
                    WhatId = account.Id,
                    ReminderDateTime = DateTime.now().addDays(5)
                );
                tasksToInsert.add(newTask);
            }
        }

        // Insert the new tasks
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Logic to execute after all batches are processed
        System.debug('Batch processing complete.');
    }
}