#if defined _vip_included
  #endinput
#endif
#define _vip_included

/*
 * Return true if client is vip.
 * @param client client index.
 * @return Return true if client is vip.
 */
native bool VIP_IsVIP(int client);

/* Print message to client.
 * @param client client index.
 * @param format message.
 */
native void VIP_Message(int client, const char[] message, any:...);

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
}
#endif