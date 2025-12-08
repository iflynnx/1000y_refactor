/*
Navicat MySQL Data Transfer

Source Server         : test
Source Server Version : 50525
Source Host           : localhost:3306
Source Database       : 1000y

Target Server Type    : MYSQL
Target Server Version : 50525
File Encoding         : 65001

Date: 2014-11-16 13:50:52
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `pt_user`
-- ----------------------------
DROP TABLE IF EXISTS `pt_user`;
CREATE TABLE `pt_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '默认',
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
  `Block` bit(1) NOT NULL DEFAULT b'0' COMMENT '为1代表封停',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17509 DEFAULT CHARSET=gb2312;

-- ----------------------------
-- Records of pt_user
-- ----------------------------
INSERT INTO `pt_user` VALUES ('17506', '0', 'e123456', 'd123456', 'fadfds@dfasdf.com', '', '123456789', 'asdfasdf', '230119198011230567', 'fasdfasdf', 'fasdfasdf', '0000-00-00 00:00:00', '0.00', '0', null, '2014/11/16', null, '127.0.0.1', '');
INSERT INTO `pt_user` VALUES ('17507', '0', 'sfsdfsfd', 'aaaaaaaaaaaa', 'dfsd@fddsf.com', '', '123456789', 'sadfsdf', '230119198011140567', 'fdsfasdf', 'fdsfasdf', '0000-00-00 00:00:00', '0.00', '0', null, '0', null, '127.0.0.1', '');
INSERT INTO `pt_user` VALUES ('17508', '0', 'v123456', 'v123456', 'dfsdf@fsfd.com', '', '123456789', 'asdfdsfs', '230119198011140567', 'fdsasdf', 'fdsasdf', '0000-00-00 00:00:00', '0.00', '0', null, '2014/11/16', null, '127.0.0.1', '');
