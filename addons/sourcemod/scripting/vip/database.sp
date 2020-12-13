#define SQL_CreatePerks \
"CREATE TABLE IF NOT EXISTS `vipPerks` \
(\
	`authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
	`chatTag` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
  	`tagColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
  	`nameColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
  	`chatColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
  	`joinMsg` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
);"

#define SQL_CreateUsers \
"CREATE TABLE IF NOT EXISTS `vipUsers` \
	`authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '', \
  	`expireStamp` int(11) NOT NULL, \
);"

#define SQL_CreateCode \
"CREATE TABLE If NOT EXISTS `vipCode` \
	`VIPKEY` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL, \
  	`DAYS` int(10) NOT NULL, \
);"

void CreateDatabasePerks(){
	char query[256];
	Format(query, sizeof(query), SQL_CreatePerks);
	g_Database.Query(SQL_CheckForErrors, query);
	Format(query, sizeof(query), SQL_CreateUsers);
	g_Database.Query(SQL_CheckForErrors, query);
	Format(query, sizeof(query), SQL_CreateCode);
	g_Database.Query(SQL_CheckForErrors, query);
}