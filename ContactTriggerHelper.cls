/**
 * Created by viktorshishlo on 5/5/21.
 */

public with sharing class ContactTriggerHelper {

    public static void createCaseForNewContact(List<Contact> newContacts) {

        Map<Id, Account> accountsByIds = new Map<Id, Account>([SELECT Id, OwnerId FROM Account]);

        for(Contact item : newContacts){
            Case cs = new Case();
            cs.ContactId = item.Id;
            cs.AccountId = item.AccountId != null ? item.AccountId : null;
            cs.Status = 'Working';
            cs.Origin = 'New Contact';
            if (cs.AccountId != null && accountsByIds.containsKey(cs.AccountId)){
                cs.OwnerId = accountsByIds.get(cs.AccountId).OwnerId;
            }
            if(item.Contact_Level__c == 'Primary'){
                cs.Priority = 'High';
            }else if (item.Contact_Level__c == 'Secondary'){
                cs.Priority = 'Medium';
            }else {
                cs.Priority = 'Low';
            }
            insert cs;
        }
    }

}