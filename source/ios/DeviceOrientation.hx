package ios;

enum abstract DeviceOrientation(Int) from Int to Int
{
	var UNKNOWN = 0;
	var PORTRAIT = 1;
	var PORTRAIT_UPSIDE_DOWN = 2;
	var LANDSCAPE_LEFT = 3;
	var LANDSCAPE_RIGHT = 4;
	var FACE_UP = 5;
	var FACE_DOWN = 6;
}
