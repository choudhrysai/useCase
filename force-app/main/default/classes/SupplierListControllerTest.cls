/**
 * @File Name          : SupplierListControllerTest.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 5/30/2020, 7:04:04 PM
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    5/30/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
@isTest
public class SupplierListControllerTest{
	@TestSetup
	static void makeData(){
		Profile profileData = [SELECT Id
		                       FROM Profile
		                       WHERE Name = 'Standard User'];
		User standardUser = new User(Alias = 'dummy', Email = 'dfgsfdghfghfgh@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Test User', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profileData.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'dfgsfdghfghfgh@testorg.com', IsActive = true);
		insert standardUser;
		Account acc = new Account(Name = 'Test Account', BillingCity = 'Houston', BillingLatitude = 29.7383743, BillingLongitude =  - 95.411732, BillingStreet = '2031-2001 W Alabama St', BillingPostalCode = '77098', BillingState = 'TX', BillingCountry = 'USA');
		insert acc;
		Supplier__c s = new Supplier__c(Name = 'Supplier 1', City__c = 'Houston', Street__C = '101 St', Country__c = 'USA', State__C = 'TX', Location__Latitude__s = 29.7534237, Location__Longitude__s =  - 95.1853992);
		insert s;
	}

	@IsTest
	static void getSuppliersTest(){
		User u = [SELECT Id
		          FROM User
		          WHERE Email = 'dfgsfdghfghfgh@testorg.com'
		          LIMIT 1];
		Account acc = [SELECT Id
		               FROM Account
		               Limit 1];
		Test.startTest();
		System.runAs(u){
			List<SupplierListController.SupplierWrapper> wrapperList = SupplierListController.getSuppliers(acc.Id);
			System.assertEquals(1, wrapperList.size());
		}
		Test.stopTest();
	}
}