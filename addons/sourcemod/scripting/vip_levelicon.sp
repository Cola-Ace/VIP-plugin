#include <sourcemod>
#include <sdktools>
#include <vip>
#include <sdkhooks>
#include <restorecvars>

int g_iOffset;

ConVar gc_VIP;
ConVar gc_OP;

public Plugin myinfo = {
	name = "VIP System - Level Icon",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

public void OnPluginStart(){
	gc_VIP = CreateConVar("sm_vip_image_vip", "1", "VIP Image Index");
	gc_OP = CreateConVar("sm_vip_image_op", "2", "OP Image Index");
	AutoExecConfig(true, "vip_levelicon");
	ExecuteAndSaveCvars("sourcemod/vip_levelicon.cfg");
	g_iOffset = FindSendPropInfo("CCSPlayerResource", "m_nPersonaDataPublicLevel");
}

public void OnMapStart(){
	char url[256];
	Format(url, sizeof(url), "materials/panorama/images/icons/xp/level%i.png", gc_VIP.IntValue);
	AddFileToDownloadsTable(url);
	Format(url, sizeof(url), "materials/panorama/images/icons/xp/level%i.png", gc_OP.IntValue);
	AddFileToDownloadsTable(url);
	SDKHook(GetPlayerResourceEntity(), SDKHook_ThinkPost, OnThinkPost);
}

public void OnThinkPost(int m_iEntity){
	int m_iLevelTemp[MAXPLAYERS+1] = 0;
	GetEntDataArray(m_iEntity, g_iOffset, m_iLevelTemp, MAXPLAYERS + 1);
	for(int i = 1; i <= MaxClients; i++)
	{
		if (VIP_IsVIP(i)){
			if(gc_VIP.IntValue != m_iLevelTemp[i]){
				SetEntData(m_iEntity, g_iOffset + (i * 4), gc_VIP.IntValue);
			}
		}
		else {
			SetEntData(m_iEntity, g_iOffset + (i * 4), -1);
		}
		if (CheckCommandAccess(i, "sm_admin", ADMFLAG_GENERIC, false)){
			if(gc_OP.IntValue != m_iLevelTemp[i]){
				SetEntData(m_iEntity, g_iOffset + (i * 4), gc_OP.IntValue);
			}
		}
	}
}