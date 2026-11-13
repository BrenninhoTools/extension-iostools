package ios;

enum abstract ThermalState(Int) from Int to Int
{
	var NOMINAL = 0;
	var FAIR = 1;
	var SERIOUS = 2;
	var CRITICAL = 3;
}
