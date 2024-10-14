/*
 * NextStepFuture Class Description:
 * 
 * Question 1: Create a future method that updates all account and opportunities next step to 'Meeting in the future'
 * Question 2: Create a method that inserts a big deal opportunity and updates the user role name to 'CRO'
 * 
 * Benefits of using future methods:
 * 
 * 1. Asynchronous Processing: Allows long-running operations to be handled in the background, freeing up resources.
 * 2. Governor Limit Management: Asynchronous methods have a separate set of limits, providing more flexibility.
 * 3. User Experience Enhancement: Improves responsiveness in user interfaces by offloading processes to the background.
 * 4. Mixed DML Operations Handling: Helps overcome Mixed DML errors by allowing updates on setup and non-setup objects.
 * 5. Enhanced Integration Capabilities: Useful for making callouts to external systems without blocking the user interaction.
 * 
 * For more detailed information, refer to the official Salesforce documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_invoking_future_methods.htm
 * 
 * Note: The class below contains placeholders for implementing a future method to update accounts and opportunities.
 *       The accompanying test class 'AsynchronousTest' should also be updated to test this method.
 */
public with sharing class NextStepFuture {

    /*
     * Future method to update all account and opportunities' next step to 'Meeting in the future'
     */
    @future
    public static void updateAllNextStep() {
        List<Account> accountsToUpdate = [SELECT Id, Next_Step__c FROM Account WHERE Next_Step__c != 'Meeting in the future'];
        List<Opportunity> oppsToUpdate = [SELECT Id, NextStep FROM Opportunity WHERE NextStep != 'Meeting in the future'];
        
        // Update accounts' custom field "Next_Step__c"
        for (Account acc : accountsToUpdate) {
            acc.Next_Step__c = 'Meeting in the future';
        }

        // Update opportunities' standard field "NextStep"
        for (Opportunity opp : oppsToUpdate) {
            opp.NextStep = 'Meeting in the future';
        }

        // Perform DML operations
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }

    /*
     * Method to insert a big deal opportunity and trigger the role update
     */
    public static void createDealAndUpdateRole() {
        // Insert big deal opportunity
        Opportunity bigDeal = new Opportunity();
        insertBigDeal(bigDeal);

        // Call a future method to update user role asynchronously to avoid MIXED_DML_OPERATION
        updateUserRoleToCRO();
    }

    // Helper method to insert big deal
    private static void insertBigDeal(Opportunity opp) {
        opp.Amount = 1000000;
        opp.Name = 'Big Deal';
        opp.StageName = 'Closed Won'; 
        opp.CloseDate = Date.today();
        
        insert opp;
    }

    /*
     * Future method to update user role to 'CRO' to avoid MIXED_DML_OPERATION
     */
    @future
    public static void updateUserRoleToCRO() {
        UserRole[] roles = [SELECT Id, Name FROM UserRole WHERE Id = :UserInfo.getUserRoleId() OR Name = 'CRO' LIMIT 1];
        updateUserRoleName(roles);
    }

    // Helper method to update role name
    private static void updateUserRoleName(UserRole[] roles){
        UserRole role;
        if (roles.isEmpty()) {
            role = new UserRole();
            role.Name = 'CRO';
            // Set other role fields if needed
        } else {
            role = roles[0];
        }

        role.Name = 'CRO';

        upsert role;
    }
}