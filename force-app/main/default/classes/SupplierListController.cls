/**
 * @File Name          : supplierListController.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 5/30/2020, 7:02:06 PM
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    5/29/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class SupplierListController{
	//Wrapped class to hold both supplier object and distance information
	public class SupplierWrapper{
		@AuraEnabled
		public Supplier__C supplier;
		@AuraEnabled
		public Decimal distance;
	}

	//Method whichh provides the details to the Lighting web compoanent
	//Retunrs List of wrapper object containing Supplier and coresponding distance
	@AuraEnabled(cacheable = true)
	public static List<SupplierWrapper> getSuppliers(String accountId){
		List<SupplierWrapper> supplierWrapperList = new List<SupplierWrapper>();
		if (accountId != null){
			Account accountRecord = [SELECT Id, Name, BillingCity, BillingLatitude, BillingLongitude, BillingStreet, BillingPostalCode, BillingState, BillingCountry
			                         FROM Account
			                         WHERE Id = :accountId
			                         LIMIT 1];
			
			for (Supplier__C supplier : [SELECT Id, Name, City__c, Location__Longitude__s, Location__Latitude__s, Country__c, PostalCode__c, State__c, Street__c
			                             FROM Supplier__C
			                             WHERE City__c = :accountRecord.BillingCity
			                             ORDER BY Name]){
				SupplierWrapper wrapperObject = new SupplierWrapper();
				//Finding the distnce between Supplier and Acount
				Location fromLocation = Location.newInstance(accountRecord.BillingLatitude, accountRecord.BillingLongitude);
				Location toLocation = Location.newInstance(supplier.Location__Latitude__s, supplier.Location__Longitude__s);
				if (isValidLocation(fromLocation) && isValidLocation(toLocation)){
					wrapperObject.distance = Decimal.valueOf(Location.getDistance(fromLocation, toLocation, 'km')).setscale(1);
				}
				wrapperObject.supplier = supplier;
				supplierWrapperList.add(wrapperObject);
			}
		}
		return supplierWrapperList;
	}
	//utility method to check if the record has vaid location details
	private static Boolean isValidLocation(Location loc){
		return (loc.latitude != null && loc.longitude != null);
	}
}