/**
 * Created by viktorshishlo on 5/6/21.
 */
@IsTest
public with sharing class ContactControllerTest {

    @TestSetup static void createData() {
        Contact con = new Contact(LastName='vik', Email='vik@vik.vik');
        insert con;
        Case cse = new Case(ContactId=con.Id);
        insert cse;
        Opportunity opp = new Opportunity(ContactId=con.Id, Name='Opportunity name', StageName='Prospecting', CloseDate=Date.today());
        insert opp;
    }

    @IsTest static void testgetListContact() {
        List<Contact> result = ContactController.getContactList('vik', 'Email',true);
        System.assertEquals('vik', result[0].Name);
    }

    @IsTest static void testDeleteContact() {
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'vik'];
        ContactController.deleteContact(con.Id);
        List<Contact> con2 = [SELECT Id FROM Contact WHERE LastName = 'vik'];
        System.assertEquals(0, con2.size());
        List<Case> cases = [SELECT Id FROM Case WHERE ContactId =: con.Id];
        System.assertEquals(0, cases.size());
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE ContactId =: con.Id];
        System.assertEquals(0, opportunities.size());
        ContactController.deleteContact(con.Id);
    }

}