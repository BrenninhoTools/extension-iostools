package ios;

enum abstract DeviceIdiom(Int) from Int to Int
{
	var UNSPECIFIED = -1;
	var PHONE = 0;
	var PAD = 1;
	var TV = 2;
	var CAR_PLAY = 3;
	var MAC = 5;
	var VISION = 6;
}
