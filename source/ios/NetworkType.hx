package ios;

enum abstract NetworkType(Int) from Int to Int
{
	var NONE = 0;
	var WIFI = 1;
	var CELLULAR = 2;
	var WIRED = 3;
	var OTHER = 4;
}
