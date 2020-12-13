#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <chat-processor>
#include <colorvariables>
#include <vip>
#include <restorecvars>
#include <base64>
#tryinclude <SteamWorks>
#tryinclude <eItems>
#tryinclude <csgo_weaponstickers>
#tryinclude <PTaH>

enum Color {
	Color_ChatTag = 0,
	Color_Name,
	Color_Chat
}

enum Type {
	ChatTag = 0,
	ClanTag,
	JoinMsg
}

Database g_Database = null;

ConVar gc_ChatTag;
ConVar gc_ChatTagColor;
ConVar gc_ChatColor;
ConVar gc_NameColor;
ConVar gc_JoinMsg;
ConVar gc_VIPClanTag;
ConVar gc_DisabledSticker;
ConVar gc_DamagePrint;
ConVar gc_DisconnectMsg;
ConVar gc_PreFix;
//ConVar gc_Prime;
//ConVar gc_GameTime;
//ConVar gc_EnableGameTime;

bool g_IsVIP[MAXPLAYERS + 1];
bool g_Change[MAXPLAYERS + 1];
bool g_ClanTag[MAXPLAYERS + 1];
bool g_ChatTag[MAXPLAYERS + 1];
bool g_JoinMsg[MAXPLAYERS + 1];
bool g_DamagePrint[MAXPLAYERS + 1];

int g_LeftDays[MAXPLAYERS + 1] = 0;

char g_Color[MAXPLAYERS + 1][Color][64];
char g_VIP[MAXPLAYERS + 1][Type][64];

#include "vip/natives.sp"
#include "vip/util.sp"

public Plugin myinfo = {
	name = "VIP System",
	author = "Xc_ace",
	description = "VIP System",
	version = "1.4",
	url = "https://cncsgo.com.cn"
}

public void OnPluginStart(){
	RegConsoleCmd("sm_vip", Command_VIP);
	
	gc_ChatTag = CreateConVar("sm_vip_chat_tag", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_ChatTagColor = CreateConVar("sm_vip_chat_tag_color", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_VIPClanTag = CreateConVar("sm_vip_private_clan_tag", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_ChatColor = CreateConVar("sm_vip_chat_color", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_NameColor = CreateConVar("sm_vip_name_color", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_JoinMsg = CreateConVar("sm_vip_join_msg", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_DisabledSticker = CreateConVar("sm_vip_disable_sticker", "0", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_DamagePrint = CreateConVar("sm_vip_damage_print", "0", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_DisconnectMsg = CreateConVar("sm_vip_disconnect_msg", "1", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	gc_PreFix = CreateConVar("sm_vip_prefix", "[{green}VIP{normal}]", "Message Prefix");
	//gc_Prime = CreateConVar("sm_vip_prime_only", "0", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	//gc_EnableGameTime = CreateConVar("sm_vip_enable_gametime", "0", "0 - disabled , 1 - enable", _, true, 0.0, true, 1.0);
	//gc_GameTime = CreateConVar("sm_vip_gametime", "30", "Only players who have reached the length of time are allowed to enter");
	AutoExecConfig(false, "vip");
	
	char szError[512];
	g_Database = SQL_Connect("vip", true, szError, sizeof(szError));
	if (g_Database == null)
	{
		SetFailState("Can't connect to database, Error: %s", szError);
	}
	g_Database.SetCharset("utf8mb4");

	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say2");
	AddCommandListener(Command_Say, "say_team");
	AddCommandListener(Command_Buy, "buy");
	ExecuteAndSaveCvars("sourcemod/vip.cfg");
	HookEvent("player_spawn", Hook_PlayerSpawn);
	HookEvent("player_hurt", Hook_PlayerHurt);
	
	KeyValues kv = new KeyValues("VIP");
	char Path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, Path, sizeof(Path), "configs/vip_command.cfg");
	kv.ImportFromFile(Path);
	if (kv.GotoFirstSubKey()){
		char command[64];
		do {
			kv.GetString("command", command, sizeof(command));
			AddCommandListener(Command_Sticker, command);
		} while (kv.GotoNextKey());
	}
}

public Action Hook_PlayerHurt(Event event, const char [] command, int args){
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (VIP_IsVIP(attacker) && gc_DamagePrint.BoolValue && g_DamagePrint[attacker]){
		VIP_Message(attacker, "你对 \x04%N\x01 造成了 \x04%i\x01 点伤害", victim, GetEventInt(event, "dmg_health"));
	}
}

public Action Command_Buy(int client, const char [] command, int args){
	if (!VIP_IsVIP(client) && gc_DisabledSticker.BoolValue){
		CreateTimer(0.0, Timer_RemoveSticker, client);
	}
}

public Action Timer_RemoveSticker(Handle timer, int client){
	if (IsValidClient(client)){
		RemoveSticker(client);
	}
}

public Action Command_Sticker(int client, const char [] command, int args)
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

public Action Hook_PlayerSpawn(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (VIP_IsVIP(client) && gc_VIPClanTag.BoolValue){
		CS_SetClientClanTag(client, "✧VIP✧");
	}
	if (!VIP_IsVIP(client) && gc_DisabledSticker.BoolValue){
		CreateTimer(0.0, Timer_RemoveSticker, client);
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

public void OnClientPutInServer(int client)
{
	if (IsValidClient(client)){
		char query[256];
		FormatEx(query, sizeof(query), "SELECT * FROM vipUsers WHERE authId='%s'", GetAuthId(client));
		g_Database.Query(SQL_CheckVIP, query, client);
	}
}

public void OnClientDisconnect(int client)
{
	if (VIP_IsVIP(client)){
		char query[256];
		FormatEx(query, sizeof(query), "UPDATE vipPerks SET chatTag='%s' WHERE authId='%s'", g_VIP[client][ChatTag], GetAuthId(client));
		g_Database.Query(SQL_CheckForErrors, query);
		FormatEx(query, sizeof(query), "UPDATE vipPerks SET joinMsg='%s' WHERE authId='%s'", g_VIP[client][JoinMsg], GetAuthId(client));
		g_Database.Query(SQL_CheckForErrors, query);
		FormatEx(query, sizeof(query), "UPDATE vipPerks SET tagColor='%s' WHERE authId='%s'", g_Color[client][Color_ChatTag], GetAuthId(client))
		g_Database.Query(SQL_CheckForErrors, query);
		FormatEx(query, sizeof(query), "UPDATE vipPerks SET nameColor='%s' WHERE authId='%s'", g_Color[client][Color_Name], GetAuthId(client))
		g_Database.Query(SQL_CheckForErrors, query);
		FormatEx(query, sizeof(query), "UPDATE vipPerks SET chatColor='%s' WHERE authId='%s'", g_Color[client][Color_Chat], GetAuthId(client))
		g_Database.Query(SQL_CheckForErrors, query);
		int damagePrint;
		if (g_DamagePrint[client]){
			damagePrint = 1;
		} else {
			damagePrint = 0;
		}
		FormatEx(query, sizeof(query), "UPDATE vipPerks SET damagePrint='%i' WHERE authId='%s'", damagePrint, GetAuthId(client));
		g_Database.Query(SQL_CheckForErrors, query);
		if (gc_DisconnectMsg.BoolValue){
			SetHudTextParams(-1.0, 0.1, 7.0, 0, 255, 150, 255, 2, 6.0, 0.1, 0.2);
			for (int i = 0; i < MaxClients; i++){
				if (IsValidClient(i)){
					ShowHudText(i, 0, "VIP %N 退出了服务器...", client);
				}
			}
		}
	}
	g_IsVIP[client] = false;
	g_Change[client] = false;
}

public void SQL_GetChatTag(Database db, DBResultSet results, const char [] error, int client){
	if (results.FetchRow()){
		results.FetchString(0, g_VIP[client][ChatTag], sizeof(g_VIP));
	}
}

public void SQL_GetJoinMsg(Database db, DBResultSet results, const char [] error, int client){
	if (results.FetchRow()){
		results.FetchString(0, g_VIP[client][JoinMsg], sizeof(g_VIP));
	}
}

public void SQL_GetNameColor(Database db, DBResultSet results, const char [] error, int client){
	if (results.FetchRow()){
		results.FetchString(0, g_Color[client][Color_Name], sizeof(g_Color));
	}
}

public void SQL_GetTagColor(Database db, DBResultSet results, const char [] error, int client){
	if (results.FetchRow()){
		results.FetchString(0, g_Color[client][Color_ChatTag], sizeof(g_Color));
	}
}

public void SQL_GetChatColor(Database db, DBResultSet results, const char [] error, int client){
	if (results.FetchRow()){
		results.FetchString(0, g_Color[client][Color_Chat], sizeof(g_Color));
	}
}

public void SQL_GetDamagePrint(Database db, DBResultSet results, const char [] error, int client){
	if (results.FetchRow()){
		int damagePrint = results.FetchInt(0);
		if (damagePrint == 1){
			g_DamagePrint[client] = true;
		} else {
			g_DamagePrint[client] = false;
		}
	}
}

public Action Command_Say(int client, const char [] command, int argc){
	char args[256];
	GetCmdArg(1, args, sizeof(args));
	if (g_JoinMsg[client] || g_ChatTag[client] || g_ClanTag[client]){
		if (StrEqual(args, "-1") == true){
			VIP_Message(client, "你已经取消设置");
			g_JoinMsg[client] = false;
			g_ChatTag[client] = false;
			g_ClanTag[client] = false;
			return Plugin_Stop;
		}
		if (StrEqual(args, "null") == true){
			Format(args, sizeof(args), "");
		}
		if (g_JoinMsg[client]){
			g_JoinMsg[client] = false;
			Format(g_VIP[client][JoinMsg], sizeof(g_VIP), args);
			VIP_Message(client, "你已成功修改你的进服提示为 \x02%s", args);
		} else {
			g_ChatTag[client] = false;
			Format(g_VIP[client][ChatTag], sizeof(g_VIP), args);
			VIP_Message(client, "你已成功修改你的聊天前缀为 \x02%s", args);
		}
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public void SQL_CheckVIP(Database db, DBResultSet results, const char[] error, int client)
{
	if (results.FetchRow()){
		int Stamp = results.FetchInt(1);
		int NowStamp = GetTime();
		if (Stamp < NowStamp){
			g_IsVIP[client] = false;
			char query[256];
			FormatEx(query, sizeof(query), "DELETE FROM vipUsers WHERE authId='%s'", GetAuthId(client))
			g_Database.Query(SQL_CheckForErrors, query);
		}
		else {
			g_IsVIP[client] = true;
			g_LeftDays[client] = (Stamp - NowStamp) / 86400;
		}
		ShowVIPInfo(client);
	}
	else {
		g_IsVIP[client] = false;
		/*
		if (gc_Prime.BoolValue){
			CheckPrime(client);
		}*/
	}
}

public Action CP_OnChatMessage(int& client, ArrayList recipients, char[] flagstring, char[] name, char[] message, bool & processcolors, bool & removecolors)
{
	if (VIP_IsVIP(client)){
		if (StrEqual(g_Color[client][Color_Name], "") == false){
			if (StrEqual(g_Color[client][Color_Name], "rgb") == true){
				StripQuotes(name);
				char rgb[256];
				RGB(name, rgb, sizeof(rgb));
				Format(name, MAXLENGTH_NAME, rgb);
			}
			else {
				Format(name, MAXLENGTH_NAME, "%s%s", g_Color[client][Color_Name], name);
			}
		}
		else {
			Format(name, MAXLENGTH_NAME, "\x01%s", name);
		}
		if (StrEqual(g_VIP[client][ChatTag], "") == false){
			if (StrEqual(g_Color[client][ChatTag], "") == false && StrEqual(g_Color[client][ChatTag], "null") == false){
				if (StrEqual(g_Color[client][ChatTag], "rgb") == true){
					char tag[64];
					char rgb[256];
					Format(tag, sizeof(tag), "[%s]", g_VIP[client][ChatTag]);
					StripQuotes(tag);
					RGB(tag, rgb, sizeof(rgb));
					Format(name, MAXLENGTH_NAME, "%s %s", rgb, name);
				}
				else {
					Format(name, MAXLENGTH_NAME, "%s[%s] %s", g_Color[client][Color_ChatTag], g_VIP[client][ChatTag], name);
				}
			}
			else {
				Format(name, MAXLENGTH_NAME, "[%s] %s", g_VIP[client][ChatTag], name);
			}
		}
		if (StrEqual(g_Color[client][Color_Chat], "") == false){
			if (StrEqual(g_Color[client][Color_Chat], "rgb") == true){
				StripQuotes(message);
				char rgb[256];
				RGB(message, rgb, sizeof(rgb));
				Format(message, MAXLENGTH_MESSAGE, rgb);
			}
			else {
				Format(message, MAXLENGTH_MESSAGE, "%s%s", g_Color[client][Color_Chat], message);
			}
		}
		Colorize(name, MAXLENGTH_NAME);
		Colorize(message, MAXLENGTH_MESSAGE);
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public Action Command_VIP(int client, int args)
{
	char key[256];
	GetCmdArg(1, key, sizeof(key));
	if (StrEqual(key, "") == false){
		VIPKEY(client, key);
		return Plugin_Stop;
	}
	else {
		char query[256];
		FormatEx(query, sizeof(query), "SELECT DAYS FROM vipPrivateCode WHERE authId='%s'", GetAuthId(client));
		g_Database.Query(SQL_PrivateCode, query, client);
		if (VIP_IsVIP(client)){
			Menus_Main(client);
		}
		else {
			VIP_Message(client, "你不是VIP");
		}
	}
	return Plugin_Continue;
}

public void SQL_PrivateCode(Database db, DBResultSet results, const char [] error, int client)
{
	if (results.FetchRow()){
		char query[256];
		int days = results.FetchInt(0);
		char Stamp[64];
		char NewStamp[64];
		Format(Stamp, sizeof(Stamp), "%i", GetTime() + (days * 86400));
		Format(NewStamp, sizeof(NewStamp), "%i", GetTime() + ((days+g_LeftDays[client]) * 86400));
		if (VIP_IsVIP(client)){
			FormatEx(query, sizeof(query), "UPDATE vipUsers SET expireStamp='%s' WHERE authId='%s'", NewStamp, GetAuthId(client));
			g_LeftDays[client] += days;
		} else {
			FormatEx(query, sizeof(query), "INSERT INTO vipUsers (authId, expireStamp) VALUES ('%s', '%s')", GetAuthId(client), Stamp);
			g_LeftDays[client] = days;
			RegClientPerks(client);
		}
		g_Database.Query(SQL_CheckForErrors, query);
		g_IsVIP[client] = true;
		VIP_Message(client, "检测到你有一张未使用的卡密，已自动兑换，卡密天数：%i", days);
		FormatEx(query, sizeof(query), "DELETE FROM vipPrivateCode WHERE authId='%s'", GetAuthId(client));
		g_Database.Query(SQL_CheckForErrors, query);
	}
}

void VIPKEY(int client, const char [] key)
{
	char query[256];
	FormatEx(query, sizeof(query), "SELECT DAYS FROM vipCode WHERE VIPKEY='%s'", key);
	g_Database.Query(SQL_VIPKEY, query, client);
	FormatEx(query, sizeof(query), "DELETE FROM vipCode WHERE VIPKEY='%s'", key);
	g_Database.Query(SQL_CheckForErrors, query);
}

public void SQL_VIPKEY(Database db, DBResultSet results, const char [] error, int client)
{
	if (results.FetchRow()){
		int days = results.FetchInt(0);
		if (days > 0){
			char Stamp[64];
			char NewStamp[64];
			Format(Stamp, sizeof(Stamp), "%i", GetTime() + (days * 86400));
			Format(NewStamp, sizeof(NewStamp), "%i", GetTime() + ((days+g_LeftDays[client]) * 86400));
			char query[256];
			if (VIP_IsVIP(client)){
				FormatEx(query, sizeof(query), "UPDATE vipUsers SET expireStamp='%s' WHERE authId='%s'", NewStamp, GetAuthId(client));
			} else {
				FormatEx(query, sizeof(query), "INSERT INTO vipUsers (authId, expireStamp) VALUES ('%s', '%s')", GetAuthId(client), Stamp);
				RegClientPerks(client);
			}
			g_Database.Query(SQL_CheckForErrors, query);
			VIP_Message(client, "你的VIP已兑换成功，天数为 %i 天", days);
			g_IsVIP[client] = true;
			g_LeftDays[client] += days;
		}
	} else {
		VIP_Message(client, "卡密不存在");
	}
}

void RegClientPerks(int client){
	char query[256];
	FormatEx(query, sizeof(query), "INSERT INTO vipPerks (authId) VALUES ('%s')", GetAuthId(client));
	g_Database.Query(SQL_CheckForErrors, query);
}

public int Handler_Main(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		switch(select){
			case 0:ChatTagChange(client);
			case 1:ChatColorChange(client);
			case 2:ChatTagColorChange(client);
			case 3:NameColorChange(client);
			case 4:JoinMessageChange(client);
			case 5:DamagePrint(client);
		}
	}
}

public int Handler_ChatTagMain(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		menu.GetItem(select, g_Color[client][Color_ChatTag], sizeof(g_Color));
	}
}

public int Handler_ChatMain(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		menu.GetItem(select, g_Color[client][Color_Chat], sizeof(g_Color));
	}
}

public int Handler_NameMain(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		menu.GetItem(select, g_Color[client][Color_Name], sizeof(g_Color));
	}
}

void ChatTagChange(int client){
	g_Change[client] = true;
	g_ChatTag[client] = true;
	VIP_Message(client, "请输入你想要更改的聊天前缀 输入 \x02-1\x01 取消，输入 \x02null\x01为空");
}

void ChatTagColorChange(int client){
	Menu menu = new Menu(Handler_ChatTagMain);
	menu.SetTitle("选择聊天前缀颜色");
	menu.AddItem("{normal}", "默认");
	menu.AddItem("{dark_red}", "红色");
	menu.AddItem("{pink}", "粉色");
	menu.AddItem("{green}", "绿色");
	menu.AddItem("{yellow}", "黄色");
	menu.AddItem("{light_green}", "亮绿色");
	menu.AddItem("{light_red}", "亮红色");
	menu.AddItem("{grey}", "灰色");
	menu.AddItem("{orange}", "橙色");
	menu.AddItem("{light_blue}", "亮蓝色");
	menu.AddItem("{dark_blue}", "深蓝色");
	menu.AddItem("{purple}", "紫色");
	menu.AddItem("rgb", "RGB");
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	menu.Display(client, MENU_TIME_FOREVER);
}

void ChatColorChange(int client){
	Menu menu = new Menu(Handler_ChatMain);
	menu.SetTitle("选择聊天颜色");
	menu.AddItem("{normal}", "默认");
	menu.AddItem("{dark_red}", "红色");
	menu.AddItem("{pink}", "粉色");
	menu.AddItem("{green}", "绿色");
	menu.AddItem("{yellow}", "黄色");
	menu.AddItem("{light_green}", "亮绿色");
	menu.AddItem("{light_red}", "亮红色");
	menu.AddItem("{grey}", "灰色");
	menu.AddItem("{orange}", "橙色");
	menu.AddItem("{light_blue}", "亮蓝色");
	menu.AddItem("{dark_blue}", "深蓝色");
	menu.AddItem("{purple}", "紫色");
	menu.AddItem("rgb", "RGB");
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	menu.Display(client, MENU_TIME_FOREVER);
}

void NameColorChange(int client){
	Menu menu = new Menu(Handler_NameMain);
	menu.SetTitle("选择名字颜色");
	menu.AddItem("{normal}", "默认");
	menu.AddItem("{dark_red}", "红色");
	menu.AddItem("{pink}", "粉色");
	menu.AddItem("{green}", "绿色");
	menu.AddItem("{yellow}", "黄色");
	menu.AddItem("{light_green}", "亮绿色");
	menu.AddItem("{light_red}", "亮红色");
	menu.AddItem("{grey}", "灰色");
	menu.AddItem("{orange}", "橙色");
	menu.AddItem("{light_blue}", "亮蓝色");
	menu.AddItem("{dark_blue}", "深蓝色");
	menu.AddItem("{purple}", "紫色");
	menu.AddItem("rgb", "RGB");
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	menu.Display(client, MENU_TIME_FOREVER);
}

void DamagePrint(int client){
	if (g_DamagePrint[client]){
		g_DamagePrint[client] = false;
	} else {
		g_DamagePrint[client] = true;
	}
	Menus_Main(client);
}

void JoinMessageChange(int client){
	g_Change[client] = true;
	g_JoinMsg[client] = true;
	VIP_Message(client, "请输入你想要更改的进服提示 输入 \x02-1\x01 取消，输入 \x02null\x01为空");
}

void Menus_Main(int client)
{
	Menu menu = new Menu(Handler_Main);
	menu.SetTitle("[VIP] 主菜单\n距离过期还有 %i 天", g_LeftDays[client]);
	menu.AddItem("chat tag", "更改聊天前缀", gc_ChatTag.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("chat color", "更改聊天颜色", gc_ChatColor.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("chat tag color", "更改聊天前缀颜色", gc_ChatTagColor.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("name color", "更改名字颜色", gc_NameColor.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("join msg", "更改进服提示", gc_JoinMsg.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	char damage[64];
	Format(damage, sizeof(damage), "[%s] 伤害播报", g_DamagePrint[client] ? "√" : "X");
	menu.AddItem("damage print", damage, gc_DamagePrint.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public void SQL_CheckForErrors(Database db, DBResultSet results, const char[] error, any data)
{
	if (!StrEqual(error, ""))
	{
		LogError("Database error, %s", error);
		return;
	}
}
/*
void CheckPrime(int client){
	if (k_EUserHasLicenseResultDoesNotHaveLicense == SteamWorks_HasLicenseForApp(client, 624820)){
		KickClient(client, "只有优先状态的用户可以进入服务器 | VIP可解除限制");
	} else {
		if (gc_EnableGameTime.BoolValue){
			CheckGameTime(client);
		}
	}
}

void CheckGameTime(int client){
	char url[512];
	char steamid[64];
	GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
	Format(url, sizeof(url), "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=%s&steamid=%s&appids_filter[0]=730", "key", steamid);
	Handle request = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, url);
	SteamWorks_SetHTTPRequestContextValue(request, GetClientUserId(client));
	SteamWorks_SetHTTPCallbacks(request, HttpCallBack);
	SteamWorks_SendHTTPRequest(request);
}

public int HttpCallBack(Handle request, bool Failure, bool RequestSuccessful, EHTTPStatusCode StatusCode, int userid){
	int client = GetClientOfUserId(userid);
	if (!RequestSuccessful || StatusCode != k_EHTTPStatusCode200OK){
		return;
	}
	char content[1024];
    response.GetContent(content, response.ContentLength + 1);

    Regex regex = new Regex("(?<=\"playtime_forever\":).*?(?=,)");
    if (regex.Match(content) > 0)
    {
        char client_time[128];
        regex.GetSubString(0, client_time, sizeof(client_time));
        
        int hour = StringToInt(client_time) / 60;
        LogMessage("player: %N, time: %d", client, hour);

        if (hour < gc_GameTime.IntValue)
        {
            KickClient(client, "游戏时间不满300小时或资料不公开 | VIP可解除限制 | Q群:760586300");
        }
    }
    else
    {
        KickClient(client, "游戏时间不满300小时或资料不公开 | VIP可解除限制 | Q群:760586300");
    }
}*/

char GetAuthId(int client){
	char steamid[64];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	return steamid;
}

void RGB(const char[] source, char[] buffer, int size)
{
	static char color[][] = {
			"\x01",
			"\x02",
			"\x03",
			"\x04",
			"\x05",
			"\x06",
			"\x07",
			"\x08",
			"\x09",
			"\x10",
			"\x0A",
			"\x0B",
			"\x0C",
			"\x0E",
			"\x0F"
	};

	int last = 0;
	int len = strlen(source) + 1;
	for(int i = 1; i < len; i++)
	{
		if (i == len || (source[i] & 0xc0) != 0x80)
		{
			char temp[5];
			strcopy(temp, i - last + 1, source[last]);
			Format(buffer, size, "%s%s%s", buffer, color[GetRandomInt(0, sizeof(color) - 1)], temp);
			last = i;
		}
	}
}

bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || IsFakeClient(client)){
		return false;
	}
	return true;
}

void ShowVIPInfo(int client){
	char query[256];
	FormatEx(query, sizeof(query), "SELECT chatTag FROM vipPerks WHERE authId='%s'", GetAuthId(client));
	g_Database.Query(SQL_GetChatTag, query, client);
	FormatEx(query, sizeof(query), "SELECT JoinMsg FROM vipPerks WHERE authId='%s'", GetAuthId(client));
	g_Database.Query(SQL_GetJoinMsg, query, client);
	FormatEx(query, sizeof(query), "SELECT tagColor FROM vipPerks WHERE authId='%s'", GetAuthId(client));
	g_Database.Query(SQL_GetTagColor, query, client);
	FormatEx(query, sizeof(query), "SELECT nameColor FROM vipPerks WHERE authId='%s'", GetAuthId(client));
	g_Database.Query(SQL_GetNameColor, query, client);
	FormatEx(query, sizeof(query), "SELECT chatColor FROM vipPerks WHERE authId='%s'", GetAuthId(client));
	g_Database.Query(SQL_GetChatColor, query, client);
	FormatEx(query, sizeof(query), "SELECT damagePrint FROM vipPerks WHERE authId='%s'", GetAuthId(client));
	g_Database.Query(SQL_GetDamagePrint, query, client);
	SetHudTextParams(-1.0, 0.1, 7.0, 0, 255, 150, 255, 2, 6.0, 0.1, 0.2);
	for (int i = 0; i < MaxClients; i++){
		if (IsValidClient(i)){
			ShowHudText(i, 0, "VIP %N 正在连接服务器...\n%s", client, g_VIP[client][JoinMsg]);
		}
	}
}