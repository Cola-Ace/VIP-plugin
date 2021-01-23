static char _colorNames[][] = {"{normal}", "{dark_red}",    "{pink}",      "{green}",
                               "{yellow}", "{light_green}", "{light_red}", "{grey}",
                               "{orange}", "{light_blue}",  "{dark_blue}", "{purple}"};
static char _colorCodes[][] = {"\x01", "\x02", "\x03", "\x04", "\x05", "\x06",
                               "\x07", "\x08", "\x09", "\x0B", "\x0C", "\x0E"};

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