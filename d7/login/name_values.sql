/*
Navicat MySQL Data Transfer

Source Server         : test
Source Server Version : 50525
Source Host           : localhost:3306
Source Database       : 1000y

Target Server Type    : MYSQL
Target Server Version : 50525
File Encoding         : 65001

Date: 2014-11-16 13:50:58
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `name_values`
-- ----------------------------
DROP TABLE IF EXISTS `name_values`;
CREATE TABLE `name_values` (
  `c_Id` int(11) NOT NULL AUTO_INCREMENT,
  `c_account` varchar(50) NOT NULL,
  `c_CharName` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_bin DEFAULT NULL,
  `c_charserver` varchar(50) NOT NULL,
  `c_Logindate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `c_BoLock` int(11) NOT NULL DEFAULT '0',
  `c_equipinfo` varchar(255) DEFAULT NULL,
  `c_logintime` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`c_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=gb2312;

-- ----------------------------
-- Records of name_values
-- ----------------------------
INSERT INTO `name_values` VALUES ('17', 'e123456', 'sxxxxx', '战斗服', '2014-11-16 09:09:39', '0', null, null);
INSERT INTO `name_values` VALUES ('18', 'e123456', 'twosxxxxx', '战斗服', '2014-11-16 09:10:01', '0', null, null);
INSERT INTO `name_values` VALUES ('19', 'e123456', 'xfsdfsdf', '战斗服', '2014-11-16 09:11:14', '0', null, null);
INSERT INTO `name_values` VALUES ('20', 'e123456', 'xfsdfsdfg', '战斗服', '2014-11-16 09:11:17', '0', null, null);
INSERT INTO `name_values` VALUES ('21', 'e123456', 'wfdsfs', '战斗服', '2014-11-16 09:11:20', '1', null, null);
INSERT INTO `name_values` VALUES ('22', 'v123456', 'xxxxx', '战斗服', '2014-11-16 12:05:12', '1', null, '2014/11/16 12:05:12');
INSERT INTO `name_values` VALUES ('23', 'v123456', 'sdfsdff', '战斗服', '2014-11-16 13:25:08', '0', null, '2014/11/16 13:25:08');
