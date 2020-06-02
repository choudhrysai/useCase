/**
 * @File Name          : CaseTriggerHelper.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/2/2020, 8:27:17 AM
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    5/31/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class CaseTriggerHelper{
	//Helper Method to check the average score of the Accounts and udpate it
	public void updateAverageSatisfactionScore(Set<Id> accountIdSet){
		List<Account> toBeUpdatedAccounts = new List<Account>();
		//Querying the accounts and related Cases.
		List<AggregateResult> AggregateResultList = [SELECT AVG(Score__c)avg, AccountId
		                                             FROM  Case
		                                             WHERE AccountId IN :accountIdSet
		                                             GROUP BY AccountId];
		for (AggregateResult ar : AggregateResultList){
			Account acc = new Account();
			acc.Id = String.valueOf(ar.get('AccountId'));
			acc.Average_Satisfaction_Score__c = ((Decimal)ar.get('avg')).setScale(1);
			toBeUpdatedAccounts.add(acc);
		}
		//Updating the score  on account object
		if (toBeUpdatedAccounts != null && !toBeUpdatedAccounts.isEmpty()){
			update toBeUpdatedAccounts;
		}
	}
}