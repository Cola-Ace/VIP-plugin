#include <sourcemod>
#include <vip>

public Plugin myinfo = {
	name = "VIP System - Command Disable",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	KeyValues kv = new KeyValues("VIP");
	char Path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, Path, sizeof(Path), "configs/vip_command.cfg");
	kv.ImportFromFile(Path);
	if (kv.GotoFirstSubKey()){
		char command[64];
		do {
			kv.GetString("command", command, sizeof(command));
			AddCommandListener(Command_Disabled, command);
		} while (kv.GotoNextKey());
	}
}

public Action Command_Disabled(int client, const char [] command, int args)
{
	if (!IsValidClient(client)){
		return Plugin_Stop;
	}
	if (!VIP_IsVIP(client)){
		VIP_Message(client, "你不是VIP，无法使用此指令");
		return Plugin_Stop;
	}
	return Plugin_Continue;
}