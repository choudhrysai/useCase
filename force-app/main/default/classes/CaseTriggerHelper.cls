/**
 * @File Name          : CaseTriggerHelper.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 5/31/2020, 3:04:56 PM
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    5/31/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class CaseTriggerHelper{
    //Helper Method to check the average score of the Accounts and udpate it
	public void updateAverageSatisfactionScore(Set<Id> accountIdSet){
        List<Account> toBeUpdatedAccounts = new List<Account>();
        //Querying the accounts and related Cases.
		List<Account> accountList = [SELECT Id, Average_Satisfaction_Score__C, (
		                             SELECT Id, Satisfaction_Score__c
		                             FROM Cases)
		                             FROM Account
		                             WHERE Id In :accountIdSet];
		for (Account acc : accountList){
			if (acc.Cases != null && !acc.Cases.isEmpty()){
                //Initialising the values with value as 0
				Decimal totalScore = 0;
				Decimal caseCount = 0;
                Decimal average = 0;
                //Calculating the TotalScore and Case Count
				for ( Case cs : acc.Cases){
					if (cs.Satisfaction_Score__c != null){
						totalScore = totalScore + Integer.valueOf(cs.Satisfaction_Score__c);
						caseCount++;
					}
                }
                //Calculating the Avreage
				if (totalScore > 0){
					average = totalScore / caseCount;
                }
                //checking if the Score needs to be updated
				if (acc.Average_Satisfaction_Score__C != average){
					acc.Average_Satisfaction_Score__C = average.setScale(1);
					toBeUpdatedAccounts.add(acc);
				}
            }
            //Updating the score  on account object
			if (toBeUpdatedAccounts != null && !toBeUpdatedAccounts.isEmpty()){
				update toBeUpdatedAccounts;
			}
		}
    }
}