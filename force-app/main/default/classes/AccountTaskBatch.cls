/**
 * Batch Apex class for creating tasks on inactive accounts that do not have a task with "call" in the subject.
 * Implements the Database.Batchable interface to process records in batches.
 */
public class AccountTaskBatch implements Database.Batchable<SObject> {

    /**
     * Start method to initialize the batch process.
     * Defines the query locator to retrieve inactive accounts without specific tasks.
     *
     * @param BC The batch context.
     * @return A Database.QueryLocator object that retrieves the records to be processed.
     */
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all accounts that are inactive and do not have a task with "call" in the name
        return Database.getQueryLocator([
            SELECT Id, (SELECT Id FROM Tasks WHERE Subject LIKE '%appel%')
            FROM Account
            WHERE Active__c = false
        ]);
    }

    /**
     * Execute method to process each batch of records.
     * Creates a new task for each eligible account.
     *
     * @param BC The batch context.
     * @param scope The list of Account records to be processed in this batch.
     */
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Task> tasksToInsert = new List<Task>();

        for (Account account : scope) {
            // Check if there are no tasks with "call" in the name
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

    /**
     * Finish method to execute logic after all batches are processed.
     * Currently, it logs a debug message indicating the completion of the batch process.
     *
     * @param BC The batch context.
     */
    public void finish(Database.BatchableContext BC) {
        // Logic to execute after all batches are processed
        System.debug('Batch processing complete.');
    }
}