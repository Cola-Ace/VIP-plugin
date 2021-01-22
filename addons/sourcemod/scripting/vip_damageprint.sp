#include <sourcemod>
#include <vip>

public Plugin myinfo = {
	name = "VIP System - Damage Print",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	HookEvent("player_hurt", Event_PlayerHurt);
}

public Action Event_PlayerHurt(Event event, const char [] name, bool dontBroadcast){
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (VIP_IsVIP(attacker)){
		VIP_Message(attacker, "你对 {GREEN}%N{NORMAL} 造成了 {GREEN}%i{NORMAL} 点伤害", victim, GetEventInt(event, "dmg_health"));
	}
}