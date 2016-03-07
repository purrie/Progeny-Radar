#include "Defines.lsl"

integer status;

ClearAlarm()
{
	llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_COLOR, ALL_SIDES, <1,1,1>, 1, PRIM_GLOW, ALL_SIDES, 0  ]);
	llSetTimerEvent(0);
}
Alarm()
{
	float delta = llSin(llGetTime() * status / ALARM_PING_INTERVAL);
	llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_COLOR, ALL_SIDES, <1, 1-delta, 1-delta>, 1, PRIM_GLOW, ALL_SIDES, delta * 0.25 + 0.25]);
}
default
{
	link_message(integer sender, integer num, string str, key id)
	{
		switch(num)
		{
			case ALARM_NONE:
				ClearAlarm();
				break;
			case ALARM_PRESENCE:
			case ALARM_INTRUSION:
				status = num;
				llSetTimerEvent(0.1);
				break;
			default:
				break;
		}
	}
	timer()
	{
		Alarm();
	}
	attach(key id)
	{
		ClearAlarm();
	}
}