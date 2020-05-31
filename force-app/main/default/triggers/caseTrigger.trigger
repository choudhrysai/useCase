/**
 * @File Name          : caseTrigger.trigger
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 5/31/2020, 1:56:08 PM
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    5/31/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
trigger caseTrigger on  Case(before insert, after insert, before update, after update, before delete, after delete, after undelete ){
	TriggerDispatcher.run(new CaseTriggerHandler());
}