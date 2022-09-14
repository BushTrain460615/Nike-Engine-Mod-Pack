function onCreate() {
	// PlayState.settingsCache();
	PlayState.getDialogue('thorns'); /* gets dialogue for this song aka thornsDialogue.txt, Can be change to like
	PlayState.getDialogue('shit'); and it will try to get dialogue file: shitDialogue, but there needs to be a folder
	called shit with the dialogue text file in it*/
	PlayState.schoolIntro(PlayState.doof);
}