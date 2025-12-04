/*
Navicat MySQL Data Transfer

Source Server         : test
Source Server Version : 50525
Source Host           : localhost:3306
Source Database       : 1000y

Target Server Type    : MYSQL
Target Server Version : 50525
File Encoding         : 65001

Date: 2014-11-09 09:37:28
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `account1000y`
-- ----------------------------
DROP TABLE IF EXISTS `account1000y`;
CREATE TABLE `account1000y` (
  `account` varchar(50) CHARACTER SET gb2312 NOT NULL,
  `password` varchar(50) CHARACTER SET gb2312 NOT NULL,
  `char1` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `char2` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `char3` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `char4` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `char5` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `ipaddr` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `username` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `birth` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `telephone` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `makedate` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `lastdate` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `address` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `email` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `nativenumber` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `masterkey` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `ptname` varchar(50) CHARACTER SET gb2312 DEFAULT NULL,
  `ptnativenumber` varchar(50) CHARACTER SET gb2312 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of account1000y
-- ----------------------------
INSERT INTO `account1000y` VALUES ('c123456', 'c123456', 'hhhhhhhh:战斗服', '测试角色二:战斗服', '', '', '', '127.0.0.1', 'asfsa', '', '123456789', '2014/11/9', '2014/11/9', '', 'dsfasdf@fasdf.com', '230119198810100234', 'dfasdff', 'asfsa', '230119198810100234');
