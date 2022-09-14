function onCreate() {
	PlayState.playCutscene('stressCutscene.mp4', false);
}

function onCutsceneComplete() {
	// PlayState.settingsCache();
}

function onDeath() {
	// PlayState.applicationPopup('Bozo!', 'Lol you died!');
}

function onSongEnd() {
	PlayState.playCutscene('kickstarterTrailer.mp4', true);
}