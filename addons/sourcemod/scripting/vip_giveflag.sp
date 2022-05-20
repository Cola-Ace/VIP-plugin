#include <sourcemod>
#include "include/vip.inc"
#include "include/restorecvars.inc"

#pragma semicolon 1
#pragma newdecls required

ConVar g_cFlags;

AdminFlag g_aAdminFlags[26];

public Plugin myinfo = {
	name = "VIP System - Extrusion",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	g_cFlags = CreateConVar("sm_vip_flags", "a", "Admin flags");
	AutoExecConfig(true, "vip_giveflag");
	g_aAdminFlags = GetFlags();
	ExecuteAndSaveCvars("sourcemod/vip_giveflag.cfg");
}

public void VIP_OnClientPutInServer(int client, VIPState state){
	if (state != VIPState_NoVIP && !IsAdmin(client)){
		GiveFlags(client);
	}
}

public void OnClientDisconnect(int client){
	if (VIP_IsVIP(client) && !IsAdmin(client)){
		RemoveFlags(client);
	}
}

stock void GiveFlags(int client){
	char flags[32];
	g_cFlags.GetString(flags, sizeof(flags));
	for (int i = 0; i < strlen(flags); i++){
		AddUserFlags(client, g_aAdminFlags[flags[i] - 'a']);
	}
}

stock void RemoveFlags(int client){
	char flags[32];
	g_cFlags.GetString(flags, sizeof(flags));
	for (int i = 0; i < strlen(flags); i++){
		RemoveUserFlags(client, g_aAdminFlags[flags[i] - 'a']);
	}
}

stock AdminFlag GetFlags(){
	AdminFlag FlagLetters[26];
	
	FlagLetters['a'-'a'] = Admin_Reservation;
	FlagLetters['b'-'a'] = Admin_Generic;
	FlagLetters['c'-'a'] = Admin_Kick;
	FlagLetters['d'-'a'] = Admin_Ban;
	FlagLetters['e'-'a'] = Admin_Unban;
	FlagLetters['f'-'a'] = Admin_Slay;
	FlagLetters['g'-'a'] = Admin_Changemap;
	FlagLetters['h'-'a'] = Admin_Convars;
	FlagLetters['i'-'a'] = Admin_Config;
	FlagLetters['j'-'a'] = Admin_Chat;
	FlagLetters['k'-'a'] = Admin_Vote;
	FlagLetters['l'-'a'] = Admin_Password;
	FlagLetters['m'-'a'] = Admin_RCON;
	FlagLetters['n'-'a'] = Admin_Cheats;
	FlagLetters['o'-'a'] = Admin_Custom1;
	FlagLetters['p'-'a'] = Admin_Custom2;
	FlagLetters['q'-'a'] = Admin_Custom3;
	FlagLetters['r'-'a'] = Admin_Custom4;
	FlagLetters['s'-'a'] = Admin_Custom5;
	FlagLetters['t'-'a'] = Admin_Custom6;
	FlagLetters['z'-'a'] = Admin_Root;
	
	return FlagLetters;
}