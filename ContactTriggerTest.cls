/**
 * Created by viktorshishlo on 5/7/21.
 */
@IsTest
public with sharing class ContactTriggerTest {

    @IsTest static void testCreateCaseForNewContact() {
        Account acc = new Account(Name='vik', OwnerId=UserInfo.getUserId());
        insert acc;

        List<Contact> contacts = new List<Contact>{
                new Contact(LastName='vik', Contact_Level__c='Primary', AccountId=acc.Id),
                new Contact(LastName='vik2', Contact_Level__c='Secondary'),
                new Contact(LastName='vik3', Contact_Level__c='Tertiary')
        };
        insert contacts;
        List<Case> cases = [SELECT Id, Priority, OwnerId FROM Case WHERE ContactId =: contacts[0].Id];
        System.assertEquals(acc.OwnerId, cases[0].OwnerId);
        System.assertEquals(1, cases.size());
        System.assertEquals('High', cases[0].Priority);

        List<Case> cases2 = [SELECT Id, Priority FROM Case WHERE ContactId =: contacts[1].Id];
        System.assertEquals(1, cases2.size());
        System.assertEquals('Medium', cases2[0].Priority);

        List<Case> cases3 = [SELECT Id, Priority FROM Case WHERE ContactId =: contacts[2].Id];
        System.assertEquals(1, cases3.size());
        System.assertEquals('Low', cases3[0].Priority);
    }

}