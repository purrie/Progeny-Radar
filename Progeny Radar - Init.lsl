

Init()
{
	llSensorRepeat("", NULL_KEY, AGENT, PR_RANGE, PI, PR_PING_RATE);
	RequestWhitelist();
}

LoadWhitelist(list data)
{
	whitelist = [];
	integer i = llGetListLength(data);
	llOwnerSay("Loading whitelist with " + (string) i + " entries");
	while(i --> 0)
		whitelist += (key)llList2String(data, i);
}
RequestWhitelist()
{
    string post = llGetObjectDesc();
	if(llSubStringIndex(post, "http") != 0)
	{
		llOwnerSay("Warning! No access to whitelist!");
		return;
	}
    list params = 
    [
        HTTP_METHOD, "GET",
        HTTP_MIMETYPE, "application/x-www-form-urlencoded;charset=utf-8",
		HTTP_BODY_MAXLENGTH, 16384
    ];
    string body = "";
	
    llHTTPRequest(post, params, body);
}