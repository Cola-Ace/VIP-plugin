#include <sourcemod>
#include "include/vip.inc"
#include "include/restorecvars.inc"
#tryinclude "include/c5_pug.inc"

#pragma semicolon 1
#pragma newdecls required

ConVar g_cMaxPlayers;

public Plugin myinfo = {
	name = "VIP System - Extrusion",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	g_cMaxPlayers = CreateConVar("sm_vip_extrusion_maxplayers", "10", "Max Players in Game");
	AutoExecConfig(true, "vip_extrusion");
	ExecuteAndSaveCvars("sourcemod/vip_extrusion.cfg");
}

public void VIP_OnClientPutInServer(int client, VIPState state){
	bool warmup = true;
	#if defined _c5_pug_included
	warmup = C5_PUG_IsWarmup();
	#endif
	if (warmup && state != VIPState_NoVIP && GetRealClientCount() >= g_cMaxPlayers.IntValue){
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