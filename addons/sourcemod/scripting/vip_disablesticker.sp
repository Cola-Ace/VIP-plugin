#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <vip>
#include <csgo_weaponstickers>
#include <eItems>
#include <PTaH>

public Plugin myinfo = {
	name = "VIP System - Disable Sticker",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	AddCommandListener(Command_Buy, "buy");
	HookEvent("player_spawn", Hook_PlayerSpawn);
}

public Action Hook_PlayerSpawn(Event event, const char [] name, bool dontBroadcast){
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!VIP_IsVIP(client)){
		CreateTimer(0.0, Timer_RemoveSticker, client);
	}
}

public Action Command_Buy(int client, const char [] command, int args){
	if (!VIP_IsVIP(client)){
		CreateTimer(0.0, Timer_RemoveSticker, client);
	}
}

public Action Timer_RemoveSticker(Handle timer, int client){
	if (IsPlayer(client)){
		RemoveSticker(client);
	}
}

void RemoveSticker(int client){
	int primary = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	int pistol = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	
	if (primary != -1){
		int PrimarySlots = eItems_GetWeaponStickersSlotsByWeapon(primary);
		for (int i = 0; i <= PrimarySlots; i++){
			CS_SetWeaponSticker(client, primary, i, 0, 0.0);
		}
	}
	if (pistol != -1){
		int PistolSlots = eItems_GetWeaponStickersSlotsByWeapon(pistol);
		for (int i = 0; i <= PistolSlots; i++){
			CS_SetWeaponSticker(client, pistol, i, 0, 0.0);
		}
	}
}