package ios;

enum abstract AudioCategory(Int) from Int to Int
{
	var AMBIENT = 0;
	var SOLO_AMBIENT = 1;
	var PLAYBACK = 2;
	var RECORD = 3;
	var PLAY_AND_RECORD = 4;
}
