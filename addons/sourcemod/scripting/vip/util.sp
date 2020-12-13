#include <cstrike>
#include <sdktools>

#if !defined PLUGIN_VERSION
#define PLUGIN_VERSION "1.4"
#endif

#define MAX_INTEGER_STRING_LENGTH 16
#define MAX_FLOAT_STRING_LENGTH 32

static char _colorNames[][] = {"{NORMAL}", "{DARK_RED}",    "{PINK}",      "{GREEN}",
                               "{YELLOW}", "{LIGHT_GREEN}", "{LIGHT_RED}", "{GRAY}",
                               "{ORANGE}", "{LIGHT_BLUE}",  "{DARK_BLUE}", "{PURPLE}"};
static char _colorCodes[][] = {"\x01", "\x02", "\x03", "\x04", "\x05", "\x06",
                               "\x07", "\x08", "\x09", "\x0B", "\x0C", "\x0E"};

stock void Colorize(char[] msg, int size, bool stripColor = false) {
  for (int i = 0; i < sizeof(_colorNames); i++) {
    if (stripColor)
      ReplaceString(msg, size, _colorNames[i], "\x01");  // replace with white
    else
      ReplaceString(msg, size, _colorNames[i], _colorCodes[i]);
  }
}