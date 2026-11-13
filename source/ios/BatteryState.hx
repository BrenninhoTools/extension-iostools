package ios;

enum abstract BatteryState(Int) from Int to Int
{
	var UNKNOWN = 0;
	var UNPLUGGED = 1;
	var CHARGING = 2;
	var FULL = 3;
}
