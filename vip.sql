/*
 Navicat Premium Data Transfer

 Source Server         : retakes
 Source Server Type    : MySQL
 Source Server Version : 50649
 Source Host           : 106.15.91.54:3306
 Source Schema         : vip

 Target Server Type    : MySQL
 Target Server Version : 50649
 File Encoding         : 65001

 Date: 18/10/2020 23:11:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for vipCode
-- ----------------------------
DROP TABLE IF EXISTS `vipCode`;
CREATE TABLE `vipCode`  (
  `VIPKEY` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `DAYS` int(10) NOT NULL DEFAULT 30
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for vipPerks
-- ----------------------------
DROP TABLE IF EXISTS `vipPerks`;
CREATE TABLE `vipPerks`  (
  `authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `chatTag` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `tagColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `nameColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `chatColor` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `joinMsg` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`authId`) USING BTREE,
  UNIQUE INDEX `authId`(`authId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for vipPrivateCode
-- ----------------------------
DROP TABLE IF EXISTS `vipPrivateCode`;
CREATE TABLE `vipPrivateCode`  (
  `authId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `DAYS` int(30) NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for vipUsers
-- ----------------------------
DROP TABLE IF EXISTS `vipUsers`;
CREATE TABLE `vipUsers`  (
  `authId` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `expireStamp` int(11) NOT NULL,
  UNIQUE INDEX `authId`(`authId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

SET FOREIGN_KEY_CHECKS = 1;
