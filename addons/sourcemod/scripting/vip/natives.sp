public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("VIP_IsVIP", Native_IsVip);
	CreateNative("VIP_Message", Native_Message);
	CreateNative("VIP_MessageToAll", Native_MessageToAll);
	CreateNative("VIP_GetClientDays", Native_GetClientDays);
	CreateNative("VIP_SetClientDays", Native_SetClientDays);
	CreateNative("VIP_GetClientState", Native_GetClientState);
	CreateNative("VIP_SetClientState", Native_SetClientState);
	
	RegPluginLibrary("vip");
	
	return APLRes_Success;
}

public int Native_GetClientState(Handle plugin, int numParams){
	int client = GetNativeCell(1);
	if (!IsPlayer(client))return view_as<int>(VIPState_NoVIP);
	return view_as<int>(g_State[client]);
}

public int Native_SetClientState(Handle plugin, int numParams){
	int client = GetNativeCell(1);
	if (!IsPlayer(client))return false;
	Call_StartForward(g_hOnClientStateChanged);
	Call_PushCell(client);
	Call_PushCell(g_State[client]);
	g_State[client] = GetNativeCell(2);
	Call_PushCell(g_State[client]);
	Call_Finish();
	return true;
}

public int Native_SetClientDays(Handle plugin, int numParams){
	int client = GetNativeCell(1);
	int days = GetNativeCell(2);
	if (!IsPlayer(client))return false;
	g_LeftDays[client] = days;
	if (!VIP_IsVIP(client)){
		if (days >= 365)
			VIP_SetClientState(client, VIPState_IsYearVIP);
		else
			VIP_SetClientState(client, VIPState_IsVIP);
	}
	return true;
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
	if (VIP_GetClientState(client) == VIPState_NoVIP){
		return false;
	}
	return true;
}