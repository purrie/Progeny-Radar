#include "Defines.lsl"
#include "Progeny Radar - Variables.lsl"
#include "Progeny Radar - Functions.lsl"
#include "Progeny Radar - Init.lsl"
#include "Progeny Radar - Display.lsl"

default
{
	state_entry()
	{
		Init();
	}
	sensor(integer detected)
	{
		DetectedAgent(detected);
	}
	no_sensor()
	{
		ClearAlarm();
	}
	attach(key id)
	{
		if(id == NULL_KEY)
			status = ALARM_NONE;
		else
			RequestWhitelist();
		UpdateStatus();
	}
	timer()
	{
		Alarm();
	}
	touch_start(integer detected)
	{
		if(IsUnmuted())
		{
			SilenceOn();
		}
		else
		{
			SilenceOff();
		}
	}
	changed(integer change)
	{
		if(change & CHANGED_INVENTORY)
			llResetScript();
	}
    http_response( key request_id, integer status, list metadata, string body )
    {
		if(status != 200)
		{
			RequestWhitelist();
		}
		list whitelist = llParseString2List(body, [","], []);
		LoadWhitelist(whitelist);
    }
}


