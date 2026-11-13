package ios;

enum abstract AppState(Int) from Int to Int
{
	var ACTIVE = 0;
	var INACTIVE = 1;
	var BACKGROUND = 2;
}
