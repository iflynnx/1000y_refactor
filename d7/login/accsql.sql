/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50528
Source Host           : localhost:3306
Source Database       : game_db

Target Server Type    : MYSQL
Target Server Version : 50528
File Encoding         : 65001

Date: 2014-11-12 17:07:59
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
  `c_Logindate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `c_BoLock` int(11) NOT NULL DEFAULT '0',
  `c_equipinfo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`c_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=26243 DEFAULT CHARSET=gb2312;

-- ----------------------------
-- Table structure for `pt_user`
-- ----------------------------
DROP TABLE IF EXISTS `pt_user`;
CREATE TABLE `pt_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT '0',
  `username` varchar(255) NOT NULL,
  `PassWord` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Emailbind` bit(1) DEFAULT b'0',
  `Telephone` varchar(64) NOT NULL,
  `RealName` varchar(64) NOT NULL,
  `IdCard` varchar(64) NOT NULL,
  `PassQuestion` varchar(255) NOT NULL,
  `PassAnswer` varchar(255) NOT NULL,
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `baLance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `dianQuan` int(11) NOT NULL DEFAULT '0',
  `liushuiId` varchar(255) DEFAULT NULL,
  `logintime` varchar(255) DEFAULT NULL,
  `icon` int(11) DEFAULT NULL COMMENT '改密标记',
  `Regip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17504 DEFAULT CHARSET=gb2312;
