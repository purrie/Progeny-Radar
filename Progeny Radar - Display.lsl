ClearVampires()
{
	llSetText("", <1,1,1>, 1);
}
AddVampire(key id)
{
	string text = llList2String(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_TEXT]), 0);
	text += "\n" + llGetUsername(id);
	llSetText(text, <1,1,1>, 1);
}