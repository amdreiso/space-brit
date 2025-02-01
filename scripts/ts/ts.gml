function ts(stringID){
	if (stringID > array_length(TranslationData[Settings.language]) || stringID < 0) return;
	
	try {
		return TranslationData[Settings.language, stringID];
	} catch (err) {
		show_debug_message($"StringID: '{stringID}' doesn't exist in {ts(0)}");
		return TranslationData[LANGUAGE.English, stringID];
	}
}