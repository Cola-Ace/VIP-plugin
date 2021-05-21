#if defined _vip_included
  #endinput
#endif
#define _vip_included

#define PLUGIN_VERSION "1.7.9"

/*
	Update Log:
	- 1.7.9:
	- Fixed Database Error (Duplicate entry '' for key 'PRIMARY')
	- 1.7.8:
	- Fixed if key has space will show invalid key(just add TrimString when check key).
	- 1.7.7:
	- Fixed Join Message.
	- 1.7.6:
	- Change enum base array to enum struct.
	- Fixed Only VIP Plugin.
	- Fixed Profile Limiter Plugin.
	- Fixed if client not vip, VIP_OnClientPutInServer will not be called.
	- Fixed no VIPState_NoVIP in VIP_OnClientPutInServer.
	
	TODO:
	- Disabled Sticker without relying on other sticker plugins(always need eItems and ripext).
	- Fix VIP Flag Plugin.
	- Custom Damage Print Message.
	- More VIP Logs.
*/

#include "vip/util.sp"

enum VIPState {
	VIPState_NoVIP,
	VIPState_IsVIP,
	VIPState_IsYearVIP,
}

/*
 * Called it when client exchange vip key.
 * @param client client index.
 * @param key vip key.
 * @param days key days.
 */
forward void VIP_OnKeyExchange(int client, const char[] key, int days);

/*
 * Called it when client state changed.
 * @param client client index.
 * @param Before_State before vip state.
 * @param After_State after vip state.
 */
forward void VIP_OnClientStateChanged(int client, VIPState Before_State, VIPState After_State);

/*
 * When client put in server.
 * @param client client index.
 * @param State return client vip state.
 */
forward void VIP_OnClientPutInServer(int client, VIPState State);

/*
 * Return true if client is vip.
 * @param client client index.
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
 * @param client client index.
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