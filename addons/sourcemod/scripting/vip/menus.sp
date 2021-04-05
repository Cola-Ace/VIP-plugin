void Menus_Main(int client)
{
	Menu menu = new Menu(Handler_Main);
	menu.SetTitle("[VIP] 主菜单\n距离过期还有 %i 天", g_LeftDays[client]);
	menu.AddItem("chat tag", "更改聊天前缀", gc_ChatTag.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("chat color", "更改聊天颜色", gc_ChatColor.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("chat tag color", "更改聊天前缀颜色", gc_ChatTagColor.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("name color", "更改名字颜色", gc_NameColor.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("join msg", "更改进服提示", gc_JoinMsg.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("clantag", "开关VIP组名", gc_VIPClanTag.BoolValue ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

void ChatTagColorChange(int client){
	Menu menu = new Menu(Handler_ChatTagMain);
	menu.SetTitle("选择聊天前缀颜色");
	menu.AddItem("{normal}", "默认");
	menu.AddItem("{dark_red}", "红色");
	menu.AddItem("{pink}", "粉色");
	menu.AddItem("{green}", "绿色");
	menu.AddItem("{yellow}", "黄色");
	menu.AddItem("{light_green}", "亮绿色");
	menu.AddItem("{light_red}", "亮红色");
	menu.AddItem("{grey}", "灰色");
	menu.AddItem("{orange}", "橙色");
	menu.AddItem("{light_blue}", "亮蓝色");
	menu.AddItem("{dark_blue}", "深蓝色");
	menu.AddItem("{purple}", "紫色");
	menu.AddItem("rgb", "RGB");
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	menu.Display(client, MENU_TIME_FOREVER);
}

void ChatColorChange(int client){
	Menu menu = new Menu(Handler_ChatMain);
	menu.SetTitle("选择聊天颜色");
	menu.AddItem("{normal}", "默认");
	menu.AddItem("{dark_red}", "红色");
	menu.AddItem("{pink}", "粉色");
	menu.AddItem("{green}", "绿色");
	menu.AddItem("{yellow}", "黄色");
	menu.AddItem("{light_green}", "亮绿色");
	menu.AddItem("{light_red}", "亮红色");
	menu.AddItem("{grey}", "灰色");
	menu.AddItem("{orange}", "橙色");
	menu.AddItem("{light_blue}", "亮蓝色");
	menu.AddItem("{dark_blue}", "深蓝色");
	menu.AddItem("{purple}", "紫色");
	menu.AddItem("rgb", "RGB");
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	menu.Display(client, MENU_TIME_FOREVER);
}

void NameColorChange(int client){
	Menu menu = new Menu(Handler_NameMain);
	menu.SetTitle("选择名字颜色");
	menu.AddItem("{normal}", "默认");
	menu.AddItem("{dark_red}", "红色");
	menu.AddItem("{pink}", "粉色");
	menu.AddItem("{green}", "绿色");
	menu.AddItem("{yellow}", "黄色");
	menu.AddItem("{light_green}", "亮绿色");
	menu.AddItem("{light_red}", "亮红色");
	menu.AddItem("{grey}", "灰色");
	menu.AddItem("{orange}", "橙色");
	menu.AddItem("{light_blue}", "亮蓝色");
	menu.AddItem("{dark_blue}", "深蓝色");
	menu.AddItem("{purple}", "紫色");
	menu.AddItem("rgb", "RGB");
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	menu.Display(client, MENU_TIME_FOREVER);
}

//Handler
public int Handler_ChatTagMain(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		menu.GetItem(select, g_Color[client].Color_ChatTag, sizeof(g_Color));
	}
}

public int Handler_ChatMain(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		menu.GetItem(select, g_Color[client].Color_Chat, sizeof(g_Color));
	}
}

public int Handler_NameMain(Menu menu, MenuAction action, int client, int select){
	if (action == MenuAction_Select){
		menu.GetItem(select, g_Color[client].Color_Name, sizeof(g_Color));
	}
}