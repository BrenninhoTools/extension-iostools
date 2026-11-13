package ios;

enum abstract PermissionStatus(Int) from Int to Int
{
	var NOT_DETERMINED = 0;
	var DENIED = 1;
	var AUTHORIZED = 2;
	var RESTRICTED = 3;
	var LIMITED = 4;
	var UNSUPPORTED = 5;
}
