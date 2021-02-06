#if defined _vip_included
  #endinput
#endif
#define _vip_included

#define PLUGIN_VERSION "1.7.4"

#include "vip/util.sp"

enum VIPState {
	VIPState_NoVIP,
	VIPState_IsVIP,
	VIPState_IsYearVIP,
}

/*
 * Called it when client exchange vip key.
 *
 * @param client client index.
 * @param key vip key.
 * @param days key days.
 */
forward void VIP_OnKeyExchange(int client, const char[] key, int days);

/*
 * Called it when client state changed.
 *
 * @param client client index.
 * @param State vip state.
 */
forward void VIP_OnClientStateChanged(int client, VIPState Before_State, VIPState After_State);

/*
 * When client put in server.
 *
 * @param client client index.
 * @param State return client vip state.
 */
forward void VIP_OnClientPutInServer(int client, VIPState State);

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
 * Set client vip days.
 * @param client client index.
 * @param days vip days.
 * @return Return true if give success.
 */
native bool VIP_SetClientDays(int client, int days);

/*
 * Get client vip state.
 * @param client client index.

 * @return Return client VIPState.
 */
native VIPState VIP_GetClientState(int client);

/*
 * Set client vip state.
 * @param client client index.
 * @param state vip state.
 * @return Return true if set success.
 */
native bool VIP_SetClientState(int client, VIPState State);

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
	MarkNativeAsOptional("VIP_SetClientDays");
	MarkNativeAsOptional("VIP_GetClientState");
	MarkNativeAsOptional("VIP_SetClientState");
}
#endif