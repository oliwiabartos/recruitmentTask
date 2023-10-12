trigger UpdateHasCustomerOnContactChange on Contact (after update) {
    ContactTriggerHandler.handleContactChange(Trigger.new, Trigger.oldMap);
}