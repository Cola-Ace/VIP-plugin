static char _colorNames[][] = {"{normal}", "{dark_red}",    "{pink}",      "{green}",
                               "{yellow}", "{light_green}", "{light_red}", "{grey}",
                               "{orange}", "{light_blue}",  "{dark_blue}", "{purple}"};
static char _colorCodes[][] = {"\x01", "\x02", "\x03", "\x04", "\x05", "\x06",
                               "\x07", "\x08", "\x09", "\x0B", "\x0C", "\x0E"};

static AdminFlag _flagsCodes[][] = {Admin_RCON, Admin_Chat, Admin_Slay, Admin_Generic, Admin_Reservation, Admin_Unban, Admin_Ban,
															 Admin_Custom4, Admin_Password, Admin_Custom3, Admin_Custom2, Admin_Cheats, Admin_Convars, Admin_Changemap,
															 Admin_Config, Admin_Custom5, Admin_Vote, Admin_Custom1, Admin_Kick, Admin_Custom6, Admin_Root};

stock void Colorize(char[] msg, int size, bool stripColor = false) {
  for (int i = 0; i < sizeof(_colorNames); i++) {
    if (stripColor)
      ReplaceString(msg, size, _colorNames[i], "\x01", false);  // replace with white
    else
      ReplaceString(msg, size, _colorNames[i], _colorCodes[i], false);
  }
}

stock bool IsValidClient(int client) {
  return client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client);
}

stock bool IsPlayer(int client) {
  return IsValidClient(client) && !IsFakeClient(client);
}

stock bool IsAdmin(int client){
	return CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC, false);
}

stock int GetIndexFromString(const char[] str, const char[] find_str){
	int len = strlen(str);
	for (int i = 0; i < len; i++){
		if (StrEqual(str[i], find_str)){
			return i;
		}
	}
	return -1;
}

stock AdminFlag GetFlagsFromName(const char[] name){
	return _flagsCodes[GetIndexFromString("mjfbaedrlqpnhgiskoctz", name)];
}

stock void SetClientFlags(int client){
	KeyValues kv = new KeyValues("Flags");
	char Path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, Path, sizeof(Path), "configs/vip_flags.cfg");
	kv.ImportFromFile(Path);
	char flags[32];
	if (kv.JumpToKey("Flags")){
		kv.GetString("flags", flags, sizeof(flags));
	}
	for (int i = 0; i < strlen(flags); i++){
		AddUserFlags(client, GetFlagsFromName(flags[i]));
	}
}