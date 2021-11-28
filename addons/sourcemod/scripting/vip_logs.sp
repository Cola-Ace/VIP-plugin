#include <sourcemod>
#include <vip>

Database g_Database = null;

char ThisServerIP[64];

public Plugin myinfo = {
	name = "VIP System - Logs",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	char error[512];
	g_Database = SQL_Connect("vip", true, error, sizeof(error));
	if (g_Database == null)
	{
		SetFailState("Can't connect to database, Error: %s", error);
	}
	g_Database.SetCharset("utf8mb4");
	
	int hostip = FindConVar("hostip").IntValue;
	Format(ThisServerIP, sizeof(ThisServerIP), "%i.%i.%i.%i:%i", hostip >>> 24, hostip >> 16 & 0xFF, hostip >> 8 & 0xFF, hostip & 0xFF, FindConVar("hostport").IntValue);
}

public void VIP_OnKeyExchange(int client, const char[] key, int days){
	char query[512];
	char auth[64];
	char msg[256];
	GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
	Format(msg, sizeof(msg), "使用卡密:%s | 天数:%i", key, days);
	Format(query, sizeof(query), "INSERT INTO vipLogs (authId, name, ip, timeStamp, action) VALUES ('%s', '%N', '%s', '%i', '%s')", auth, client, ThisServerIP, GetTime(), msg);
	g_Database.Query(SQL_CheckForErrors, query);
}

public void SQL_CheckForErrors(Database db, DBResultSet results, const char[] error, any data)
{
	if (!StrEqual(error, ""))
	{
		LogError("Database error, %s", error);
		return;
	}
}