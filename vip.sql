SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for vipCode
-- ----------------------------
DROP TABLE IF EXISTS `vipCode`;
CREATE TABLE `vipCode`  (
  `VIPKEY` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `DAYS` int(10) NOT NULL DEFAULT 30,
  PRIMARY KEY (`VIPKEY`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for vipLogs
-- ----------------------------
DROP TABLE IF EXISTS `vipLogs`;
CREATE TABLE `vipLogs`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4715 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for vipPerks
-- ----------------------------
DROP TABLE IF EXISTS `vipPerks`;
CREATE TABLE `vipPerks`  (
  `authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `chatTag` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `tagColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `nameColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `chatColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `joinMsg` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `clanTag` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`authId`) USING BTREE,
  UNIQUE INDEX `authId`(`authId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for vipPrivateCode
-- ----------------------------
DROP TABLE IF EXISTS `vipPrivateCode`;
CREATE TABLE `vipPrivateCode`  (
  `authId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `DAYS` int(30) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for vipUsers
-- ----------------------------
DROP TABLE IF EXISTS `vipUsers`;
CREATE TABLE `vipUsers`  (
  `authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `expireStamp` int(11) NOT NULL,
  `year` int(1) NOT NULL,
  PRIMARY KEY (`authId`) USING BTREE,
  UNIQUE INDEX `authId`(`authId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

SET FOREIGN_KEY_CHECKS = 1;
