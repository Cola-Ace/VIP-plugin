#include <sourcemod>
#include <system2>
#include <regex>
#include <vip>

#define TIME_LIMIT 200

public Plugin myinfo = {
	name = "VIP System - Profile Limiter",
	author = "Bone & Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnClientPostAdminCheck(int client)
{
	if (!VIP_IsVIP(client) && IsPlayer(client))
	{
		CheckTime(client);
	}
}

void CheckTime(int client)
{
    char auth[64];
    GetClientAuthId(client, AuthId_SteamID64, auth, sizeof(auth));

    char url[256];
    FormatEx(url, sizeof(url), "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=%s&steamid=%s&appids_filter[0]=730", "key",auth);
    
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

    Regex regex = new Regex("(?<=\"playtime_forever\":).*?(?=,)");
    if (regex.Match(content) > 0)
    {
        char time[128];
        regex.GetSubString(0, time, sizeof(time));
        
        int hour = StringToInt(time) / 60;
        LogMessage("player: %N, time: %d", client, hour);

        if (hour < TIME_LIMIT)
        {
            KickClient(client, "游戏时间不满200小时或资料不公开 | VIP可解除限制 | Q群:830602863");
        }
    }
    else
    {
        KickClient(client, "游戏时间不满200小时或资料不公开 | VIP可解除限制 | Q群:830602863");
    }
    
    delete request;
}