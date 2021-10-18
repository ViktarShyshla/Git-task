/**
 * Created by viktorshishlo on 4/13/21.
 */
public with sharing class ContactController {
    @AuraEnabled
    public static List<Contact> getContactList(String strConName, String sortField, Boolean isAsc) {
            strConName = '%' + strConName + '%';
        String query = 'SELECT Id, Name, Email, AccountId, Account.Name, OwnerId, Owner.Name, CreatedBy.Name, CreatedDate, Contact_Level__c ' +
                'FROM Contact ' +
                'WHERE Name LIKE :strConName';]

        if(!String.isEmpty(sortField)) {
            query += ' ORDER BY ' + sortField + (isAsc ? ' ASC ' : ' DESC ');
        }
        return Database.query(query);
    }

    @AuraEnabled
    public static void deleteContact(String contactId) {
        List<Contact> contacts = [
                SELECT Id, (
                        SELECT Id
                        FROM Cases
                ), (
                        SELECT Id
                        FROM Opportunities
                )
                FROM Contact
                WHERE Id =: contactId
        ];

        if (contacts.isEmpty()) {
            return;
        }

        List<SObject> objects = new List<SObject>();

        objects.addAll(contacts[0].Cases);
        objects.addAll(contacts[0].Opportunities);

        delete objects;
        delete contacts;
    }
}