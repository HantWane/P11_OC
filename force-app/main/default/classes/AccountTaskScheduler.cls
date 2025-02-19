/**
 * Scheduler class for executing the AccountTaskBatch job on a scheduled basis.
 * Implements the Schedulable interface to allow for scheduled execution of the batch job.
 */
public class AccountTaskScheduler implements Schedulable {

    /**
     * Executes the scheduled job.
     * This method is called by the Salesforce scheduler when the scheduled time is reached.
     * It initiates the execution of the AccountTaskBatch batch job.
     *
     * @param SC The SchedulableContext object that provides context for the scheduled job.
     */
    public void execute(SchedulableContext SC) {
        // Execute the batch job
        Database.executeBatch(new AccountTaskBatch());
    }
}