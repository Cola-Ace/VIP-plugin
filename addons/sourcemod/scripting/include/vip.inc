#if defined _vip_included
  #endinput
#endif
#define _vip_included

#define PLUGIN_VERSION "1.6.3"

#include "vip/util.sp"

/*
 * When client put in server.
 *
 * @param client client index.
 * @param isvip return true if client is vip.
 */
forward void VIP_OnClientPutInServer(int client, bool isvip);

/*
 * Return true if client is vip.
 *
 * @param client client index.
 *
 * @return Return true if client is vip.
 */
native bool VIP_IsVIP(int client);

/*
 * Print message to client.
 * @param client client index.
 * @param format message.
 */
native void VIP_Message(int client, const char[] message, any:...);

/*
 * Print message to all client.
 * @param format message.
 */
native void VIP_MessageToAll(const char[] message, any:...);

/*
 * Return Client VIP Left Days.
 * 
 * @param client client index.
 *
 * @return Return left days, return -1 if client is not vip.
 */
native int VIP_GetClientDays(int client);

public SharedPlugin __plvip = 
{
	name = "vip", 
	file = "vip.smx", 
	#if defined REQUIRE_PLUGIN
	required = 1, 
	#else
	required = 0, 
	#endif
};
#if !defined REQUIRE_PLUGIN
public __pl_vip_SetNTVOptional()
{
	MarkNativeAsOptional("VIP_IsVIP");
	MarkNativeAsOptional("VIP_Message");
	MarkNativeAsOptional("VIP_MessageToAll");
	MarkNativeAsOptional("VIP_GetClientDays");
}
#endif