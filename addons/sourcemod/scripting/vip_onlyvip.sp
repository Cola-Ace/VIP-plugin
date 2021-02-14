#include <sourcemod>
#include <vip>

public Plugin myinfo = {
	name = "VIP System - Only VIP",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void VIP_OnClientPutInServer(int client, VIPState State){
	if (!CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC, false)){
		if (State == VIPState_NoVIP)
			KickClient(client, "此服务器仅VIP可进入");
	}
}