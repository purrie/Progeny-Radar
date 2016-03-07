#define NOTE_PARSE LoadWhitelist
#define NOTE_LOADED FinishWhitelist
#include "Library/Notecards.lsl"

Init()
{
	llSensorRepeat("", NULL_KEY, AGENT, PR_RANGE, PI, PR_PING_RATE);
	NOTE_StartLoad(PR_SETTINGS);
}

LoadWhitelist(string data)
{
	whitelist += (key)data;
}
FinishWhitelist()
{
}
