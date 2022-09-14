function onCreate() {
	// PlayState.settingsCache();
	FlxG.sound.play(Paths.sound('ANGRY'));
	PlayState.getDialogue('roses');
	PlayState.schoolIntro(PlayState.doof);
}