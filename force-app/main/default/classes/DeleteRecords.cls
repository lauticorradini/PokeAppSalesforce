global class DeleteRecords implements Database.Batchable<sObject>{

	global Database.querylocator start(Database.BatchableContext BC)
	{
		string query  = 'Select Id from Pokemon__c';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Pokemon__c> scope){
		delete scope;
	}

	global void finish(Database.BatchableContext BC){
	}
}