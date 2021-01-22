public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("VIP_IsVIP", Native_IsVip);
	CreateNative("VIP_Message", Native_Message);
	CreateNative("VIP_MessageToAll", Native_MessageToAll);
	CreateNative("VIP_GetClientDays", Native_GetClientDays);
	
	RegPluginLibrary("vip");
	
	return APLRes_Success;
}

public int Native_GetClientDays(Handle plugin, int numParams){
	int client = GetNativeCell(1);
	if (!VIP_IsVIP(client))
		return -1;
	return g_LeftDays[client];
}

public int Native_Message(Handle plugin, int numParams){
	int client = GetNativeCell(1);
	if (client != 0 && (!IsClientConnected(client) || !IsClientInGame(client)))
		return;
	char buffer[512];
	int byte = 0;
	FormatNativeString(0, 2, 3, sizeof(buffer), byte, buffer);
	char prefix[64];
	gc_PreFix.GetString(prefix, sizeof(prefix));
	char finalmsg[1024];
	Format(finalmsg, sizeof(finalmsg), "%s %s", prefix, buffer);
	if (client == 0){
		Colorize(finalmsg, sizeof(finalmsg), false);
		PrintToConsole(client, finalmsg);
	} else {
		Colorize(finalmsg, sizeof(finalmsg));
		PrintToChat(client, finalmsg);
	}
}

public int Native_MessageToAll(Handle plugin, int numParams){
	char buffer[512];
	int byte = 0;
	FormatNativeString(0, 2, 3, sizeof(buffer), byte, buffer);
	char prefix[64];
	gc_PreFix.GetString(prefix, sizeof(prefix));
	char finalmsg[1024];
	Format(finalmsg, sizeof(finalmsg), "%s %s", prefix, buffer);
	Colorize(finalmsg, sizeof(finalmsg));
	PrintToChatAll(finalmsg);
}

public int Native_IsVip(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (g_IsVIP[client] == true){
		return true;
	}
	return false;
}