package ios;

enum abstract NotificationFeedback(Int) from Int to Int
{
	var SUCCESS = 0;
	var WARNING = 1;
	var ERROR = 2;
}
