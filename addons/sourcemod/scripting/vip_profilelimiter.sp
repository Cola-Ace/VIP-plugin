#include <sourcemod>
#include <system2>
#include <regex>
#include <restorecvars>
#include <vip>

ConVar g_cTime;
ConVar g_cAPIKey;
ConVar g_cMessage;

public Plugin myinfo = {
	name = "VIP System - Profile Limiter",
	author = "Bone & Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	g_cTime = CreateConVar("sm_vip_profile_time", "200", "");
	g_cAPIKey = CreateConVar("sm_vip_apikey", "", "Web API Key");
	g_cMessage = CreateConVar("sm_vip_profile_message", "游戏时间不满200小时或资料不公开 | VIP可解除限制 | Q群:", "Kick Message");
	AutoExecConfig(true, "vip_profilelimiter");
	ExecuteAndSaveCvars("sourcemod/vip_profilelimiter.cfg");
}

public void VIP_OnClientPutInServer(int client, VIPState State)
{
	if (State == VIPState_NoVIP && IsPlayer(client))
	{
		CheckTime(client);
	}
}

void CheckTime(int client)
{
	char auth[64];
	GetClientAuthId(client, AuthId_SteamID64, auth, sizeof(auth));
	char key[128];
	g_cAPIKey.GetString(key, sizeof(key));
	char url[256];
	FormatEx(url, sizeof(url), "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=%s&steamid=%s&appids_filter[0]=730", key, auth);
    
	System2HTTPRequest httpRequest = new System2HTTPRequest(HttpResponseCallback, url);
	httpRequest.Any = GetClientUserId(client);
	httpRequest.GET();
}

public int HttpResponseCallback(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method)
{
	int client = GetClientOfUserId(request.Any);

	if (!success || response.StatusCode != 200 || !IsPlayer(client))
	{
		return;
	}

    // 获取body
	char[] content = new char[response.ContentLength + 1];
	response.GetContent(content, response.ContentLength + 1);
	
	char message[512];
	g_cMessage.GetString(message, sizeof(message));
	Regex regex = new Regex("(?<=\"playtime_forever\":).*?(?=,)");
	if (regex.Match(content) > 0)
	{
		char time[128];
		regex.GetSubString(0, time, sizeof(time));
        
		int hour = StringToInt(time) / 60;
		LogMessage("player: %N, time: %d", client, hour);
		
		if (hour < g_cTime.IntValue)
		{
			KickClient(client, message);
		}
	} else {
		KickClient(client, message);
	}
    
	delete request;
}