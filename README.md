## Salesforce Batch Processing for Account Task Creation
## Overview
This Salesforce project utilizes an Apex batch process to automate the creation of tasks for inactive accounts that do not have a task with "appel" in the subject. The batch process identifies these accounts and creates a new task with specific details for each eligible account.

## Features
Identify Inactive Accounts: The batch process identifies accounts where the Active__c field is set to false.
Task Creation: For each inactive account without a task containing "appel" in the subject, a new task is created with the subject "Call".
Automation: The process can be scheduled to run regularly, ensuring that inactive accounts are proactively followed up.

## Components
Apex Class: AccountTaskBatch
start Method: Defines the SOQL query to retrieve inactive accounts without specific tasks.
execute Method: Creates a new task for each eligible account.
finish Method: Performs actions after all batches are processed (currently, logs a debug message).

## Installation and Configuration
Deploy the Code:
Deploy the AccountTaskBatch class to your Salesforce organization.
Ensure that custom fields (such as Active__c) exist on the Account object.

Schedule the Batch:
To run the batch manually, use an anonymous script in the Developer Console:
Id batchProcessId = Database.executeBatch(new AccountTaskBatch());
To schedule the batch, create a scheduler class or use a third-party scheduling solution.

## Testing
Manual Tests: Run the batch and verify that tasks are created as expected.
Unit Tests: Write unit tests to automate the validation of the batch process.

## Maintenance
Monitoring: Regularly monitor logs and batch results to ensure it is functioning correctly.
Optimization: Adjust batch size and optimize queries to efficiently manage resources.

## Contributing
Contributions are welcome! If you have suggestions or improvements, please submit a pull request.

## Contact
For any questions or suggestions, please contact [Your Name] at [antoine.marez@gmail.com].