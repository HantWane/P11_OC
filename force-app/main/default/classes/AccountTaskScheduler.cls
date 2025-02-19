public class AccountTaskScheduler implements Schedulable {
    public void execute(SchedulableContext SC) {
        // Execute the batch job
        Database.executeBatch(new AccountTaskBatch());
    }
}