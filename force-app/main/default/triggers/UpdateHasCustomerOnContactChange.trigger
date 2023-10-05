trigger UpdateHasCustomerOnContactChange on Contact (after update) {
    List<Account> accountsToUpdate = new List<Account>();

    for (Contact updatedContact : Trigger.new) {
        // Get the old Contact record
        Contact oldContact = Trigger.oldMap.get(updatedContact.Id);

        // if 'Contact Type' has changed to 'Customer'
        if (updatedContact.ContactType__c == 'Customer' && oldContact.ContactType__c != 'Customer') {
            // Retrieve the related Account
            Account relatedAccount = [SELECT Id, HasCustomer__c FROM Account WHERE Id = :updatedContact.AccountId LIMIT 1];
            
            // Update 'Has Customer' to true on the Account
            if (relatedAccount != null) {
                relatedAccount.HasCustomer__c = true;
                accountsToUpdate.add(relatedAccount);
            }
        }
        // Contact Type is not 'Customer'
        else if (oldContact.ContactType__c == 'Customer' && updatedContact.ContactType__c != 'Customer') {
            // Retrieve the related Account
            Account relatedAccount = [SELECT Id, HasCustomer__c FROM Account WHERE Id = :updatedContact.AccountId LIMIT 1];
            
            // Update 'Has Customer' to false
            if (relatedAccount != null) {
                relatedAccount.HasCustomer__c = false;
                accountsToUpdate.add(relatedAccount);
            }
        }
    }
    // Update the Account records
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}