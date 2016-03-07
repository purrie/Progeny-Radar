#include "Defines.lsl"
#include "Progeny Radar - Variables.lsl"
#include "Progeny Radar - Functions.lsl"
#include "Progeny Radar - Init.lsl"

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
	dataserver(key queryID, string data)
	{
		NOTE_LoadQuery(queryID, data);
	}
}


