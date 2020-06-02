/**
 * @File Name          : CaseTriggerHandler.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/2/2020, 7:58:58 AM
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    5/31/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class CaseTriggerHandler implements TriggerHandlerInterface{
	private static boolean runBeforeInsert = true;
	private static boolean runAfterInsert = true;
	private static boolean runBeforeUpdate = true;
	private static boolean runAfterUpdate = true;
	private static boolean runBeforeDelete = true;
	private static boolean runAfterDelete = true;
	private static boolean runAfterUnDelete = true;
	public void beforeInsert(List<sObject> newList){
		if (runBeforeInsert){
			runBeforeInsert = false;
		}
	}

	public void afterInsert(List<sObject> newList, Map<Id, sObject> newMap){
		if (runAfterInsert){
			runAfterInsert = false;
		}
	}

	public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap){
		if (runBeforeUpdate){
			runBeforeUpdate = false;
		}
	}

	public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap){
		if (runAfterUpdate){
			runAfterUpdate = false;
			CaseTriggerHelper helper = new CaseTriggerHelper();
			Set<Id> accountIdSet = new set<Id>();
			//Converting the maps from <Id,Sobject> => <Id,Case>
			Map<Id, Case> caseNewMap = (Map<Id, Case>)newMap;
			Map<Id, Case> caseOldMap = (Map<Id, Case>)oldMap;
			//Iterating through the list of cases
			for (Case cs : (List<Case>)newList){
				if (caseNewMap.get(cs.Id).Satisfaction_Score__c != caseOldMap.get(cs.Id).Satisfaction_Score__c && cs.AccountId != null){
					accountIdSet.add(cs.AccountId);
				}
			}
			//CAlling the helper method to check the score and update
			if (accountIdSet != null && !accountIdSet.isEmpty()){
				helper.updateAverageSatisfactionScore(accountIdSet);
			}
		}
	}

	public void beforeDelete(List<sObject> oldList, Map<Id, sObject> oldMap){
		if (runBeforeDelete){
			runBeforeDelete = false;
		}
	}

	public void afterDelete(List<sObject> oldList, Map<Id, sObject> oldMap){
		if (runAfterDelete){
			runAfterDelete = false;
		}
	}

	public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap){
		if (runAfterUnDelete){
			runAfterUnDelete = false;
		}
	}
}