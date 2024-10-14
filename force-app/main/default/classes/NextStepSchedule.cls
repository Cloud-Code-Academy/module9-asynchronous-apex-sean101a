/*
 * NextStepSchedule Class Description:
 * 
 * The NextStepSchedule class is tailored to schedule the execution of the NextStepBatch class in Salesforce.
 * By implementing the Schedulable interface, it allows administrators or developers to define specific intervals at which the batch job should run, automating the process of updating the Next Step field for Account and Opportunity objects.
 * Helpful Link: https://help.salesforce.com/s/articleView?id=sf.emergency_response_admin_surveys_apex_job.htm&type=5
 * 
 * Benefits of using Scheduled Apex:
 * 
 * 1. Automated Execution: Scheduled Apex allows for automatic execution of classes at specified intervals, eliminating the need for manual triggers.
 * 2. CRON Expressions: Provides the ability to define complex schedules using CRON expressions, catering to almost any scheduling requirement.
 * 3. Resource Management: Running tasks during off-peak hours can help in balancing the load on Salesforce servers, ensuring smoother operations during business hours.
 * 4. Recurring Jobs: Suitable for tasks that need to occur daily, weekly, monthly, or based on any other consistent interval.
 * 5. Chain Jobs: After one scheduled job finishes, it can be set to trigger another job, allowing for chaining of operations.
 * 6. Monitoring & Control: Administrators can monitor, pause, or stop scheduled jobs via the Salesforce interface.
 * 
 * For a deeper understanding and best practices, refer to the official Salesforce documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
 * Trailhead Module: https://trailhead.salesforce.com/content/learn/modules/asynchronous_apex/async_apex_scheduled
 * 
 * Note: To make full use of this class, ensure that the NextStepBatch class is implemented and operational.
 */
public with sharing class NextStepSchedule implements Schedulable {

    /*
     * This method is invoked when the scheduled job runs.
     * It executes the NextStepBatch using the Database.executeBatch method.
     */
    public void execute(SchedulableContext sc) {
        // Create an instance of the NextStepBatch class
        NextStepBatch batch = new NextStepBatch(); 

        // Execute the batch job
        Database.executeBatch(batch);
    }

    /*
     * To schedule this class, you can do so using the Salesforce Setup, 
     * or programmatically by running the following code in the Developer Console:
     * 
     * String cronExp = '0 0 12 * * ?'; // Example CRON expression for daily execution at noon
     * NextStepSchedule scheduleJob = new NextStepSchedule();
     * System.schedule('Daily NextStepBatch Job', cronExp, scheduleJob);
     */
}