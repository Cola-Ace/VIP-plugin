#include <sourcemod>
#include "include/vip.inc"
#tryinclude "include/c5_pug.inc"

public Plugin myinfo = {
	name = "VIP System - Extrusion",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void VIP_OnClientPutInServer(int client, VIPState state){
	bool c5_pug = false;
	#if defined _c5_pug_included
	c5_pug = true;
	#endif
	if (c5_pug ? C5_PUG_IsWarmup():true && state != VIPState_NoVIP && GetRealClientCount() >= 10){
		RandomKick();
	}
}

stock void RandomKick(){
	ArrayList list = new ArrayList(2);
	for (int i = 0; i < MaxClients; i++){
		if (IsPlayer(i) && !VIP_IsVIP(i) && !IsAdmin(i)) list.Push(i);
	}
	KickClient(list.Get(GetRandomInt(0, list.Length - 1)), "你被会员挤了");
}