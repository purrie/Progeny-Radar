
DetectedAgent(integer count)
{
	status = ALARM_NONE;
	while(count --> 0)
	{
		key id = llDetectedKey(count);
		if(IsOnWhitelist(id))
			jump continue;
		else if(status < ALARM_PRESENCE)
			status = ALARM_PRESENCE;
			
		vector myPos = llGetPos();
		vector otherPos = llDetectedPos(count);
		float distance = llVecDist(myPos, otherPos);
		if(distance <= PR_ALARM)
		{
			status = ALARM_INTRUSION;
			jump out;
		}
		
		@continue;
	}
	@out;
	
	UpdateStatus();
}
integer IsOnWhitelist(key id)
{
	integer c = llGetListLength(whitelist);
	while(c --> 0)
	{
		key wl = llList2Key(whitelist, c);
		if(id == wl)
			return TRUE;
	}
	return FALSE;
}
ClearAlarm()
{
	status = ALARM_NONE;
	UpdateStatus();
}
UpdateStatus()
{
	if(lastStatus == status)
		return;
	lastStatus = status;
	llMessageLinked(LINK_SET, status, "", NULL_KEY);
	
	switch(status)
	{
		case ALARM_NONE:
			llSetTimerEvent(0);
			break;
		case ALARM_PRESENCE:
			llSetTimerEvent(ALARM_PING_INTERVAL);
			break;
		case ALARM_INTRUSION:
			llSetTimerEvent(ALARM_PING_INTERVAL * 0.5);
			break;
		default:
			break;
	}
}
Alarm()
{
	switch(status)
	{
		case ALARM_NONE:
			ClearAlarm();
			break;
		case ALARM_PRESENCE:
			if(IsUnmuted())
				llPlaySound(noticeSound, 1.0);
			break;
		case ALARM_INTRUSION:
			if(IsUnmuted())
				llPlaySound(alarmSound, 1.0);
			break;
		default:
			break;
	}
}
integer IsUnmuted()
{
	return llGetTime() > silenceTimer;
}
SilenceOn()
{
	silenceTimer = PR_MUTE_TIMER;
	llResetTime();
	llOwnerSay("Radar muted");
}
SilenceOff()
{
	silenceTimer = 0;
	llOwnerSay("Radar unmuted");
}
