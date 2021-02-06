#include <sourcemod>
#include <updater>
#include <vip>

public Plugin myinfo = {
	name = "VIP System - Auto Update",
	author = "Xc_ace",
	description = "VIP System",
	version = PLUGIN_VERSION,
	url = "https://github.com/Cola-Ace/VIP-Plugin"
}

#define UPDATE_URL "https://www.sqtool.xyz/plugin/update/update.txt"

public void OnPluginStart()
{
    if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL)
    }
}

public void OnLibraryAdded(const char []name)
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL)
    }
}