
DetectedAgent(integer count)
{
	status = ALARM_NONE;
	ClearVampires();
	while(count --> 0)
	{
		key id = llDetectedKey(count);
		if(DetectProgeny(id) == FALSE)
			jump continue;
			
		AddVampire(id);
		if(IsOnWhitelist(id))
			jump continue;
			
		vector myPos = llGetPos();
		vector otherPos = llDetectedPos(count);
		float distance = llVecDist(myPos, otherPos);
		
		if(distance <= PR_PRESENCE)
			status = ALARM_PRESENCE;
			
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
	ClearVampires();
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
integer DetectProgeny(key avatar)
{
	list attachedNames = [];
	list attachedUUIDs = llGetAttachedList(avatar);
	integer i = llGetListLength(attachedUUIDs);
	
	while(i --> 0)
	{
		key uuid = llList2Key(attachedUUIDs, i);
		list temp = llGetObjectDetails(uuid, [OBJECT_NAME]);
		string name = llList2String(temp, 0);
		
		if(llSubStringIndex(name, EVIL_NAME) >= 0)
		{
			return TRUE;
		}
	}
	return FALSE;
}