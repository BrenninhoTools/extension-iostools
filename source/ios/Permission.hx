package ios;

enum abstract Permission(Int) from Int to Int
{
	var CAMERA = 0;
	var MICROPHONE = 1;
	var PHOTOS = 2;
	var PHOTOS_ADD_ONLY = 3;
	var NOTIFICATIONS = 4;
}
