/*
SQLyog Ultimate - MySQL GUI v8.2 
MySQL - 5.7.13-log : Database - javafast
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`javafast` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `javafast`;

/*Table structure for table `act_evt_log` */

DROP TABLE IF EXISTS `act_evt_log`;

CREATE TABLE `act_evt_log` (
  `LOG_NR_` bigint(20) NOT NULL AUTO_INCREMENT,
  `TYPE_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TIME_STAMP_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DATA_` longblob,
  `LOCK_OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `LOCK_TIME_` timestamp NULL DEFAULT NULL,
  `IS_PROCESSED_` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`LOG_NR_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ge_bytearray` */

DROP TABLE IF EXISTS `act_ge_bytearray`;

CREATE TABLE `act_ge_bytearray` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BYTES_` longblob,
  `GENERATED_` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_BYTEARR_DEPL` (`DEPLOYMENT_ID_`),
  CONSTRAINT `act_ge_bytearray_ibfk_1` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ge_property` */

DROP TABLE IF EXISTS `act_ge_property`;

CREATE TABLE `act_ge_property` (
  `NAME_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `VALUE_` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int(11) DEFAULT NULL,
  PRIMARY KEY (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_actinst` */

DROP TABLE IF EXISTS `act_hi_actinst`;

CREATE TABLE `act_hi_actinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8_bin NOT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `CALL_PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACT_NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ACT_TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint(20) DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_ACT_INST_START` (`START_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_PROCINST` (`PROC_INST_ID_`,`ACT_ID_`),
  KEY `ACT_IDX_HI_ACT_INST_EXEC` (`EXECUTION_ID_`,`ACT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_attachment` */

DROP TABLE IF EXISTS `act_hi_attachment`;

CREATE TABLE `act_hi_attachment` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `URL_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `CONTENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_comment` */

DROP TABLE IF EXISTS `act_hi_comment`;

CREATE TABLE `act_hi_comment` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` datetime NOT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACTION_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `MESSAGE_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `FULL_MSG_` longblob,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_detail` */

DROP TABLE IF EXISTS `act_hi_detail`;

CREATE TABLE `act_hi_detail` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin NOT NULL,
  `VAR_TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int(11) DEFAULT NULL,
  `TIME_` datetime NOT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint(20) DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DETAIL_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_ACT_INST` (`ACT_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_TIME` (`TIME_`),
  KEY `ACT_IDX_HI_DETAIL_NAME` (`NAME_`),
  KEY `ACT_IDX_HI_DETAIL_TASK_ID` (`TASK_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_identitylink` */

DROP TABLE IF EXISTS `act_hi_identitylink`;

CREATE TABLE `act_hi_identitylink` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `GROUP_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_TASK` (`TASK_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_PROCINST` (`PROC_INST_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_procinst` */

DROP TABLE IF EXISTS `act_hi_procinst`;

CREATE TABLE `act_hi_procinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint(20) DEFAULT NULL,
  `START_USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `START_ACT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `END_ACT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `SUPER_PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `PROC_INST_ID_` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PRO_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_PRO_I_BUSKEY` (`BUSINESS_KEY_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_taskinst` */

DROP TABLE IF EXISTS `act_hi_taskinst`;

CREATE TABLE `act_hi_taskinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `CLAIM_TIME_` datetime DEFAULT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint(20) DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `PRIORITY_` int(11) DEFAULT NULL,
  `DUE_DATE_` datetime DEFAULT NULL,
  `FORM_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_TASK_INST_PROCINST` (`PROC_INST_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_hi_varinst` */

DROP TABLE IF EXISTS `act_hi_varinst`;

CREATE TABLE `act_hi_varinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin NOT NULL,
  `VAR_TYPE_` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int(11) DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint(20) DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `LAST_UPDATED_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_PROCVAR_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PROCVAR_NAME_TYPE` (`NAME_`,`VAR_TYPE_`),
  KEY `ACT_IDX_HI_PROCVAR_TASK_ID` (`TASK_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_id_group` */

DROP TABLE IF EXISTS `act_id_group`;

CREATE TABLE `act_id_group` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_id_info` */

DROP TABLE IF EXISTS `act_id_info`;

CREATE TABLE `act_id_info` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `USER_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `VALUE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PASSWORD_` longblob,
  `PARENT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_id_membership` */

DROP TABLE IF EXISTS `act_id_membership`;

CREATE TABLE `act_id_membership` (
  `USER_ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `GROUP_ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`USER_ID_`,`GROUP_ID_`),
  KEY `ACT_FK_MEMB_GROUP` (`GROUP_ID_`),
  CONSTRAINT `act_id_membership_ibfk_1` FOREIGN KEY (`USER_ID_`) REFERENCES `act_id_user` (`ID_`),
  CONSTRAINT `act_id_membership_ibfk_2` FOREIGN KEY (`GROUP_ID_`) REFERENCES `act_id_group` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_id_user` */

DROP TABLE IF EXISTS `act_id_user`;

CREATE TABLE `act_id_user` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `FIRST_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `LAST_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `EMAIL_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PWD_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PICTURE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_procdef_info` */

DROP TABLE IF EXISTS `act_procdef_info`;

CREATE TABLE `act_procdef_info` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `INFO_JSON_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_INFO_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_IDX_INFO_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_INFO_JSON_BA` (`INFO_JSON_ID_`),
  CONSTRAINT `act_procdef_info_ibfk_1` FOREIGN KEY (`INFO_JSON_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `act_procdef_info_ibfk_2` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_re_deployment` */

DROP TABLE IF EXISTS `act_re_deployment`;

CREATE TABLE `act_re_deployment` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  `DEPLOY_TIME_` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_re_model` */

DROP TABLE IF EXISTS `act_re_model`;

CREATE TABLE `act_re_model` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp NULL DEFAULT NULL,
  `LAST_UPDATE_TIME_` timestamp NULL DEFAULT NULL,
  `VERSION_` int(11) DEFAULT NULL,
  `META_INFO_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EDITOR_SOURCE_VALUE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EDITOR_SOURCE_EXTRA_VALUE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_MODEL_SOURCE` (`EDITOR_SOURCE_VALUE_ID_`),
  KEY `ACT_FK_MODEL_SOURCE_EXTRA` (`EDITOR_SOURCE_EXTRA_VALUE_ID_`),
  KEY `ACT_FK_MODEL_DEPLOYMENT` (`DEPLOYMENT_ID_`),
  CONSTRAINT `act_re_model_ibfk_1` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`),
  CONSTRAINT `act_re_model_ibfk_2` FOREIGN KEY (`EDITOR_SOURCE_VALUE_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `act_re_model_ibfk_3` FOREIGN KEY (`EDITOR_SOURCE_EXTRA_VALUE_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_re_procdef` */

DROP TABLE IF EXISTS `act_re_procdef`;

CREATE TABLE `act_re_procdef` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8_bin NOT NULL,
  `VERSION_` int(11) NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `HAS_START_FORM_KEY_` tinyint(4) DEFAULT NULL,
  `SUSPENSION_STATE_` int(11) DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  `HAS_GRAPHICAL_NOTATION_` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_PROCDEF` (`KEY_`,`VERSION_`,`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ru_event_subscr` */

DROP TABLE IF EXISTS `act_ru_event_subscr`;

CREATE TABLE `act_ru_event_subscr` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `EVENT_TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `EVENT_NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACTIVITY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `CONFIGURATION_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATED_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_CONFIG_` (`CONFIGURATION_`),
  KEY `ACT_FK_EVENT_EXEC` (`EXECUTION_ID_`),
  CONSTRAINT `act_ru_event_subscr_ibfk_1` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ru_execution` */

DROP TABLE IF EXISTS `act_ru_execution`;

CREATE TABLE `act_ru_execution` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PARENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `SUPER_EXEC_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `IS_ACTIVE_` tinyint(4) DEFAULT NULL,
  `IS_CONCURRENT_` tinyint(4) DEFAULT NULL,
  `IS_SCOPE_` tinyint(4) DEFAULT NULL,
  `IS_EVENT_SCOPE_` tinyint(4) DEFAULT NULL,
  `SUSPENSION_STATE_` int(11) DEFAULT NULL,
  `CACHED_ENT_STATE_` int(11) DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `LOCK_TIME_` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EXEC_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_FK_EXE_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_EXE_PARENT` (`PARENT_ID_`),
  KEY `ACT_FK_EXE_SUPER` (`SUPER_EXEC_`),
  KEY `ACT_FK_EXE_PROCDEF` (`PROC_DEF_ID_`),
  CONSTRAINT `act_ru_execution_ibfk_1` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `act_ru_execution_ibfk_2` FOREIGN KEY (`PARENT_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `act_ru_execution_ibfk_3` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `act_ru_execution_ibfk_4` FOREIGN KEY (`SUPER_EXEC_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ru_identitylink` */

DROP TABLE IF EXISTS `act_ru_identitylink`;

CREATE TABLE `act_ru_identitylink` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `GROUP_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_IDENT_LNK_GROUP` (`GROUP_ID_`),
  KEY `ACT_IDX_ATHRZ_PROCEDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_TSKASS_TASK` (`TASK_ID_`),
  KEY `ACT_FK_IDL_PROCINST` (`PROC_INST_ID_`),
  CONSTRAINT `act_ru_identitylink_ibfk_1` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `act_ru_identitylink_ibfk_2` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `act_ru_identitylink_ibfk_3` FOREIGN KEY (`TASK_ID_`) REFERENCES `act_ru_task` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ru_job` */

DROP TABLE IF EXISTS `act_ru_job`;

CREATE TABLE `act_ru_job` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `LOCK_EXP_TIME_` timestamp NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `RETRIES_` int(11) DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DUEDATE_` timestamp NULL DEFAULT NULL,
  `REPEAT_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_JOB_EXCEPTION` (`EXCEPTION_STACK_ID_`),
  CONSTRAINT `act_ru_job_ibfk_1` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ru_task` */

DROP TABLE IF EXISTS `act_ru_task`;

CREATE TABLE `act_ru_task` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DELEGATION_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PRIORITY_` int(11) DEFAULT NULL,
  `CREATE_TIME_` timestamp NULL DEFAULT NULL,
  `DUE_DATE_` datetime DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `SUSPENSION_STATE_` int(11) DEFAULT NULL,
  `TENANT_ID_` varchar(255) COLLATE utf8_bin DEFAULT '',
  `FORM_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_TASK_CREATE` (`CREATE_TIME_`),
  KEY `ACT_FK_TASK_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_TASK_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_TASK_PROCDEF` (`PROC_DEF_ID_`),
  CONSTRAINT `act_ru_task_ibfk_1` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `act_ru_task_ibfk_2` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `act_ru_task_ibfk_3` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `act_ru_variable` */

DROP TABLE IF EXISTS `act_ru_variable`;

CREATE TABLE `act_ru_variable` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint(20) DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_VARIABLE_TASK_ID` (`TASK_ID_`),
  KEY `ACT_FK_VAR_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_VAR_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_VAR_BYTEARRAY` (`BYTEARRAY_ID_`),
  CONSTRAINT `act_ru_variable_ibfk_1` FOREIGN KEY (`BYTEARRAY_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `act_ru_variable_ibfk_2` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `act_ru_variable_ibfk_3` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `crm_chance` */

DROP TABLE IF EXISTS `crm_chance`;

CREATE TABLE `crm_chance` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) DEFAULT NULL COMMENT '机会名称',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户名称',
  `sale_amount` varchar(12) DEFAULT NULL COMMENT '销售金额',
  `period_type` varchar(2) DEFAULT NULL COMMENT '销售阶段',
  `probability` int(3) DEFAULT NULL COMMENT '赢单率',
  `change_type` varchar(2) DEFAULT NULL COMMENT '机会类型',
  `sour_type` varchar(2) DEFAULT NULL COMMENT '机会来源',
  `lose_reasons` varchar(50) DEFAULT NULL COMMENT '输单原因',
  `nextcontact_date` date DEFAULT NULL COMMENT '下次联系时间',
  `nextcontact_note` varchar(50) DEFAULT NULL COMMENT '联系内容',
  `own_by` varchar(30) DEFAULT NULL COMMENT '所有者',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`),
  KEY `index_chance_create_by` (`create_by`) USING BTREE,
  KEY `index_chance_del_flag` (`del_flag`) USING BTREE,
  KEY `index_chance_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售机会表';

/*Table structure for table `crm_clue` */

DROP TABLE IF EXISTS `crm_clue`;

CREATE TABLE `crm_clue` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `market_id` varchar(30) DEFAULT NULL COMMENT '市场活动ID',
  `name` varchar(50) NOT NULL COMMENT '线索名称',
  `contacter_name` varchar(30) DEFAULT NULL COMMENT '联系人姓名',
  `sex` char(1) DEFAULT NULL COMMENT '性别',
  `mobile` varchar(20) DEFAULT NULL COMMENT '联系手机',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `job_type` varchar(20) DEFAULT NULL COMMENT '职务',
  `sour_type` varchar(3) DEFAULT NULL COMMENT '线索来源',
  `industry_type` varchar(3) DEFAULT NULL COMMENT '客户行业',
  `nature_type` varchar(3) DEFAULT NULL COMMENT '公司性质',
  `scale_type` varchar(3) DEFAULT NULL COMMENT '企业规模',
  `province` varchar(30) DEFAULT NULL COMMENT '省',
  `city` varchar(30) DEFAULT NULL COMMENT '市',
  `dict` varchar(30) DEFAULT NULL COMMENT '区',
  `address` varchar(50) DEFAULT NULL COMMENT '详细地址',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `nextcontact_date` date DEFAULT NULL COMMENT '下次联系时间',
  `nextcontact_note` varchar(50) DEFAULT NULL COMMENT '下次联系内容',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '转化客户',
  `is_pool` char(1) DEFAULT '0' COMMENT '是否为公海',
  `own_by` varchar(30) DEFAULT NULL COMMENT '所有者',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门权限隔离',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `field1` varchar(50) DEFAULT NULL COMMENT '备用字段1',
  `field2` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_clue_create_by` (`create_by`) USING BTREE,
  KEY `index_clue_name` (`name`) USING BTREE,
  KEY `index_clue_del_flag` (`del_flag`) USING BTREE,
  KEY `index_clue-account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='线索';

/*Table structure for table `crm_contact_record` */

DROP TABLE IF EXISTS `crm_contact_record`;

CREATE TABLE `crm_contact_record` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `target_type` char(2) DEFAULT '20' COMMENT '业务类型,19：线索，20：客户，21：联系人，22：商机，16：合同，50：回款，28：工单',
  `target_id` varchar(50) DEFAULT NULL COMMENT '业务ID',
  `target_name` varchar(50) DEFAULT NULL COMMENT '业务名称',
  `contact_type` varchar(2) DEFAULT NULL COMMENT '跟进方式',
  `contact_date` datetime DEFAULT NULL COMMENT '跟进日期',
  `content` varchar(500) DEFAULT NULL COMMENT '跟进内容',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门ID',
  `own_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_com_create_by` (`create_by`) USING BTREE,
  KEY `index_com_customer_id` (`target_id`) USING BTREE,
  KEY `index_com_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跟进记录';

/*Table structure for table `crm_contacter` */

DROP TABLE IF EXISTS `crm_contacter`;

CREATE TABLE `crm_contacter` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '所属客户',
  `name` varchar(30) DEFAULT NULL COMMENT '姓名',
  `sex` varchar(2) DEFAULT NULL COMMENT '性别',
  `birthday` datetime DEFAULT NULL COMMENT '生日',
  `job_type` varchar(20) DEFAULT NULL COMMENT '职务',
  `role_type` char(1) DEFAULT NULL COMMENT '角色',
  `mobile` varchar(20) DEFAULT NULL COMMENT '手机',
  `tel` varchar(20) DEFAULT NULL COMMENT '电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `wx` varchar(20) DEFAULT NULL COMMENT '微信',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ',
  `is_default` char(1) DEFAULT '0' COMMENT '是否首要',
  `create_by` varchar(30) DEFAULT NULL,
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门权限隔离',
  `own_by` varchar(30) DEFAULT NULL COMMENT '所有者',
  PRIMARY KEY (`id`),
  KEY `index_contacter_del_flag` (`del_flag`) USING BTREE,
  KEY `index_customer_id` (`customer_id`),
  KEY `index_contacter_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='联系人';

/*Table structure for table `crm_customer` */

DROP TABLE IF EXISTS `crm_customer`;

CREATE TABLE `crm_customer` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) NOT NULL COMMENT '客户名称',
  `customer_type` varchar(30) DEFAULT NULL COMMENT '客户分类',
  `customer_status` char(1) DEFAULT NULL COMMENT '客户状态',
  `customer_level` char(1) DEFAULT NULL COMMENT '客户级别',
  `contacter_name` varchar(30) DEFAULT NULL COMMENT '首要联系人',
  `mobile` varchar(20) DEFAULT NULL COMMENT '联系手机',
  `nextcontact_date` date DEFAULT NULL COMMENT '下次联系时间',
  `nextcontact_note` varchar(50) DEFAULT NULL COMMENT '下次联系内容',
  `tags` varchar(100) DEFAULT NULL COMMENT '客户标签',
  `own_by` varchar(30) DEFAULT NULL COMMENT '所有者',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `lock_flag` char(1) DEFAULT '0' COMMENT '锁定标记',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门权限隔离',
  `industry_type` varchar(3) DEFAULT NULL COMMENT '客户行业',
  `sour_type` varchar(3) DEFAULT NULL COMMENT '客户来源',
  `nature_type` varchar(3) DEFAULT NULL COMMENT '公司性质',
  `scale_type` varchar(3) DEFAULT NULL,
  `coin` int(10) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `fax` varchar(30) DEFAULT NULL,
  `province` varchar(30) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `dict` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `bankaccountname` varchar(50) DEFAULT NULL,
  `bankaccountno` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `is_pool` char(1) DEFAULT '0' COMMENT '公海客户1是0否',
  `clue_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customer_create_by` (`create_by`) USING BTREE,
  KEY `index_customer_name` (`name`) USING BTREE,
  KEY `index_customer_del_flag` (`del_flag`) USING BTREE,
  KEY `index_customer_type` (`customer_type`),
  KEY `index_customer-account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户';

/*Table structure for table `crm_customer_detail` */

DROP TABLE IF EXISTS `crm_customer_detail`;

CREATE TABLE `crm_customer_detail` (
  `id` varchar(30) NOT NULL COMMENT '客户ID',
  `industry_type` varchar(2) DEFAULT NULL COMMENT '客户行业',
  `sour_type` varchar(2) DEFAULT NULL COMMENT '客户来源',
  `nature_type` varchar(2) DEFAULT NULL COMMENT '公司性质',
  `scale_type` varchar(20) DEFAULT NULL COMMENT '企业规模',
  `coin` int(10) DEFAULT NULL COMMENT '积分',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `fax` varchar(20) DEFAULT NULL COMMENT '传真',
  `province` varchar(20) DEFAULT NULL COMMENT '省',
  `city` varchar(20) DEFAULT NULL COMMENT '市',
  `dict` varchar(20) DEFAULT NULL COMMENT '区',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `remarks` varchar(250) DEFAULT NULL COMMENT '备注信息',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户详情';

/*Table structure for table `crm_customer_star` */

DROP TABLE IF EXISTS `crm_customer_star`;

CREATE TABLE `crm_customer_star` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `own_by` varchar(30) DEFAULT NULL COMMENT '关注者',
  `create_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_star_customer_id` (`customer_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户关注';

/*Table structure for table `crm_customer_type` */

DROP TABLE IF EXISTS `crm_customer_type`;

CREATE TABLE `crm_customer_type` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `auth_type` char(1) DEFAULT NULL COMMENT '数据权限',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `supplier_protype_del_flag` (`del_flag`) USING BTREE,
  KEY `supplier_protype_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户分类';

/*Table structure for table `crm_document` */

DROP TABLE IF EXISTS `crm_document`;

CREATE TABLE `crm_document` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '所属客户',
  `name` varchar(50) DEFAULT NULL COMMENT '附件名称',
  `content` varchar(500) DEFAULT NULL COMMENT '附件',
  `create_by` varchar(30) DEFAULT NULL,
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_contacter_del_flag` (`del_flag`) USING BTREE,
  KEY `index_customer_id` (`customer_id`),
  KEY `index_contacter_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='附件管理';

/*Table structure for table `crm_invoice` */

DROP TABLE IF EXISTS `crm_invoice`;

CREATE TABLE `crm_invoice` (
  `id` varchar(30) NOT NULL COMMENT '客户ID',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `invoice_type` char(1) DEFAULT NULL COMMENT '发票类型',
  `reg_name` varchar(50) DEFAULT NULL COMMENT '发票抬头',
  `reg_address` varchar(50) DEFAULT NULL COMMENT '单位地址',
  `reg_phone` varchar(30) DEFAULT NULL COMMENT '单位电话',
  `bank_no` varchar(30) DEFAULT NULL COMMENT '银行基本户账号',
  `bank_name` varchar(50) DEFAULT NULL COMMENT '开户行',
  `tax_no` varchar(30) DEFAULT NULL COMMENT '税务登记号',
  `province` varchar(20) DEFAULT NULL COMMENT '省',
  `city` varchar(20) DEFAULT NULL COMMENT '市',
  `dict` varchar(20) DEFAULT NULL COMMENT '区',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `zipcode` varchar(20) DEFAULT NULL COMMENT '邮编',
  `receiver` varchar(30) DEFAULT NULL COMMENT '收货人',
  `phone` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开票信息';

/*Table structure for table `crm_market` */

DROP TABLE IF EXISTS `crm_market`;

CREATE TABLE `crm_market` (
  `id` varchar(30) NOT NULL COMMENT 'ID',
  `name` varchar(50) NOT NULL COMMENT '活动名称',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '截止日期',
  `market_type` char(2) DEFAULT NULL COMMENT '活动类型',
  `market_address` varchar(50) DEFAULT NULL COMMENT '活动地点',
  `estimate_cost` decimal(12,2) DEFAULT NULL COMMENT '预计成本',
  `actual_cost` decimal(12,2) DEFAULT NULL COMMENT '实际成本',
  `estimate_amount` decimal(12,2) DEFAULT NULL COMMENT '预计收入',
  `actual_amount` decimal(12,2) DEFAULT NULL COMMENT '实际收入',
  `invite_num` int(11) DEFAULT NULL COMMENT '邀请人数',
  `actual_num` int(11) DEFAULT NULL COMMENT '实际人数',
  `content` varchar(10000) DEFAULT NULL COMMENT '活动内容',
  `own_by` varchar(30) DEFAULT NULL COMMENT '所有者',
  `status` char(1) DEFAULT '0' COMMENT '活动状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '活动描述',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='市场活动';

/*Table structure for table `crm_market_data` */

DROP TABLE IF EXISTS `crm_market_data`;

CREATE TABLE `crm_market_data` (
  `id` varchar(30) NOT NULL,
  `title` varchar(200) DEFAULT NULL COMMENT '展示标题',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图',
  `content` varchar(10000) DEFAULT NULL COMMENT '活动内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动详情';

/*Table structure for table `crm_quote` */

DROP TABLE IF EXISTS `crm_quote`;

CREATE TABLE `crm_quote` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `customer_id` varchar(30) NOT NULL COMMENT '客户',
  `contacter_id` varchar(30) DEFAULT NULL COMMENT '联系人',
  `chance_id` varchar(30) DEFAULT NULL COMMENT '关联机会',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '总金额',
  `num` int(11) DEFAULT NULL COMMENT '总数量',
  `startDate` date DEFAULT NULL COMMENT '报价日期',
  `endDate` date DEFAULT NULL COMMENT '有效期至',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `own_by` varchar(30) DEFAULT NULL COMMENT '制单人',
  `notes` text COMMENT '正文',
  `files` varchar(1000) DEFAULT NULL COMMENT '附件',
  `audit_by` varchar(30) DEFAULT NULL,
  `audit_date` datetime DEFAULT NULL,
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  `office_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_quote_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报价单';

/*Table structure for table `crm_quote_detail` */

DROP TABLE IF EXISTS `crm_quote_detail`;

CREATE TABLE `crm_quote_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `quote_id` varchar(30) DEFAULT NULL COMMENT '报价单',
  `product_id` varchar(30) DEFAULT NULL COMMENT '产品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `price` decimal(12,2) DEFAULT NULL COMMENT '单价',
  `num` int(10) DEFAULT NULL COMMENT '数量',
  `amt` decimal(12,2) DEFAULT NULL COMMENT '金额',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_quote_detail_quote_id` (`quote_id`) USING BTREE,
  KEY `index_quote_detail_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报价单明细';

/*Table structure for table `crm_service` */

DROP TABLE IF EXISTS `crm_service`;

CREATE TABLE `crm_service` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(50) DEFAULT NULL COMMENT '工单编码',
  `name` varchar(50) NOT NULL COMMENT '主题',
  `service_type` char(1) DEFAULT NULL COMMENT '类型',
  `order_id` varchar(30) DEFAULT NULL COMMENT '订单合同',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `level_type` char(1) DEFAULT NULL COMMENT '优先级',
  `end_date` date DEFAULT NULL COMMENT '截止日期',
  `expecte` varchar(200) DEFAULT NULL COMMENT '期望结果',
  `content` varchar(500) DEFAULT NULL COMMENT '内容',
  `status` char(1) DEFAULT NULL COMMENT '处理状态',
  `deal_date` date DEFAULT NULL COMMENT '处理日期',
  `satisfy_type` char(1) DEFAULT NULL COMMENT '满意度',
  `audit_status` char(1) DEFAULT NULL COMMENT '审核状态',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` date DEFAULT NULL COMMENT '审核日期',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新人',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账号',
  PRIMARY KEY (`id`),
  KEY `crm_workorder_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='服务工单';

/*Table structure for table `crm_tag` */

DROP TABLE IF EXISTS `crm_tag`;

CREATE TABLE `crm_tag` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(30) DEFAULT NULL COMMENT '标签名称',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_care_create_by` (`create_by`) USING BTREE,
  KEY `index_care_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户标签';

/*Table structure for table `fi_finance_account` */

DROP TABLE IF EXISTS `fi_finance_account`;

CREATE TABLE `fi_finance_account` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) NOT NULL COMMENT '账户名称',
  `bank_name` varchar(50) DEFAULT NULL COMMENT '银行名称',
  `bankcard_no` varchar(20) DEFAULT NULL COMMENT '银行账号',
  `balance` decimal(12,2) DEFAULT '0.00' COMMENT '余额',
  `is_default` char(1) DEFAULT NULL COMMENT '是否默认',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_bankaccount_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结算账户';

/*Table structure for table `fi_finance_journal` */

DROP TABLE IF EXISTS `fi_finance_journal`;

CREATE TABLE `fi_finance_journal` (
  `id` varchar(30) NOT NULL COMMENT '流水号',
  `fiaccount_id` varchar(30) DEFAULT NULL COMMENT '结算账户',
  `deal_type` varchar(2) DEFAULT NULL COMMENT '交易类别',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `money_type` varchar(2) DEFAULT NULL COMMENT '资金类别',
  `money` decimal(12,2) DEFAULT NULL COMMENT '交易金额',
  `notes` varchar(50) DEFAULT NULL COMMENT '摘要',
  `balance` decimal(12,2) DEFAULT NULL COMMENT '当前余额',
  `unique_code` varchar(30) DEFAULT NULL COMMENT '唯一码',
  `data_type` varchar(2) DEFAULT NULL COMMENT '终端类型',
  `create_by` varchar(30) DEFAULT NULL COMMENT '操作人',
  `create_date` datetime DEFAULT NULL COMMENT '操作日期',
  `last_journal_id` varchar(30) DEFAULT NULL COMMENT '上一笔记录ID',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账套',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='账户流水';

/*Table structure for table `fi_payment_able` */

DROP TABLE IF EXISTS `fi_payment_able`;

CREATE TABLE `fi_payment_able` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(50) NOT NULL COMMENT '单号',
  `purchase_id` varchar(30) DEFAULT NULL COMMENT '采购单',
  `supplier_id` varchar(30) DEFAULT NULL COMMENT '供应商',
  `returnorder_id` varchar(30) DEFAULT NULL,
  `customer_id` varchar(50) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL COMMENT '应付金额',
  `real_amt` decimal(12,2) DEFAULT '0.00' COMMENT '实际已付',
  `able_date` date DEFAULT NULL COMMENT '应付时间',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_recei_customer_id` (`supplier_id`) USING BTREE,
  KEY `index_recei_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应付款';

/*Table structure for table `fi_payment_bill` */

DROP TABLE IF EXISTS `fi_payment_bill`;

CREATE TABLE `fi_payment_bill` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `fi_payment_able_id` varchar(30) DEFAULT NULL COMMENT '所属应付款',
  `no` varchar(30) NOT NULL COMMENT '单号',
  `supplier_id` varchar(30) DEFAULT NULL COMMENT '供应商',
  `customer_id` varchar(30) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL COMMENT '付款金额',
  `deal_date` date DEFAULT NULL COMMENT '付款时间',
  `fi_account_id` varchar(30) DEFAULT NULL COMMENT '付款账户',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_recei_customer_id` (`supplier_id`) USING BTREE,
  KEY `index_recei_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='付款单';

/*Table structure for table `fi_receive_able` */

DROP TABLE IF EXISTS `fi_receive_able`;

CREATE TABLE `fi_receive_able` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(50) NOT NULL COMMENT '单号',
  `order_id` varchar(30) DEFAULT NULL COMMENT '合同订单',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `amount` decimal(12,2) NOT NULL COMMENT '应收金额',
  `real_amt` decimal(12,2) DEFAULT '0.00' COMMENT '实际已收',
  `able_date` date DEFAULT NULL COMMENT '应收时间',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_recei_customer_id` (`customer_id`) USING BTREE,
  KEY `index_recei_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应收款';

/*Table structure for table `fi_receive_bill` */

DROP TABLE IF EXISTS `fi_receive_bill`;

CREATE TABLE `fi_receive_bill` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `fi_receive_able_id` varchar(30) DEFAULT NULL COMMENT '所属应收款',
  `no` varchar(30) NOT NULL COMMENT '单号',
  `order_id` varchar(30) DEFAULT NULL COMMENT '合同订单',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `amount` decimal(12,2) NOT NULL COMMENT '收款金额',
  `deal_date` date DEFAULT NULL COMMENT '收款时间',
  `fi_account_id` varchar(30) DEFAULT NULL COMMENT '收款账户',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `is_invoice` char(1) DEFAULT NULL COMMENT '是否开票',
  `invoice_amt` decimal(12,2) DEFAULT NULL COMMENT '开票金额',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `audit_by` varchar(30) DEFAULT NULL,
  `audit_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_receive_bill_customer_id` (`customer_id`) USING BTREE,
  KEY `index_receive_bill_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收款单';

/*Table structure for table `gen_report` */

DROP TABLE IF EXISTS `gen_report`;

CREATE TABLE `gen_report` (
  `id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '名称',
  `comments` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  `table_name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '表名',
  `report_type` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '图表类型',
  `x_axis` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT 'X轴字段',
  `y_axis` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT 'Y轴字段',
  `query_sql` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '查询数据SQL',
  `count_type` char(2) COLLATE utf8_bin DEFAULT NULL COMMENT '统计分类',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `status` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '发布状态',
  `create_by` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='图表配置';

/*Table structure for table `gen_report_column` */

DROP TABLE IF EXISTS `gen_report_column`;

CREATE TABLE `gen_report_column` (
  `id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `gen_report_id` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '归属图表配置',
  `java_field` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '字段名',
  `name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '字段描述',
  `java_type` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '字段类型',
  `is_list` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否显示',
  `is_query` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否查询字段',
  `query_type` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '查询方式',
  `show_type` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '显示类型',
  `dict_type` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '字典类型',
  `sort` decimal(10,0) DEFAULT NULL COMMENT '排序（升序）',
  `create_by` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `gen_report_column_table_id` (`gen_report_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='图表配置明细';

/*Table structure for table `gen_scheme` */

DROP TABLE IF EXISTS `gen_scheme`;

CREATE TABLE `gen_scheme` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '名称',
  `category` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '分类',
  `package_name` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '生成模块名',
  `sub_module_name` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '生成子模块名',
  `function_name` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '生成功能名',
  `function_name_simple` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '生成功能名（简写）',
  `function_author` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '生成功能作者',
  `gen_table_id` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '生成表编号',
  `page_model` varchar(30) COLLATE utf8_bin DEFAULT '0' COMMENT '页面模型:0:弹窗，1:跳转',
  `tree_data` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '左树右表的情况下，树形列表查询URL',
  `create_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `gen_scheme_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='生成方案';

/*Table structure for table `gen_table` */

DROP TABLE IF EXISTS `gen_table`;

CREATE TABLE `gen_table` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '名称',
  `comments` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  `class_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '实体类名称',
  `parent_table` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '关联父表',
  `parent_table_fk` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '关联父表外键',
  `create_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  `category` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT ' 生成模板分类',
  `package_name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '生成模块名',
  `sub_module_name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '生成子模块名',
  `function_name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '生成功能名',
  `function_name_simple` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '生成功能名（简写）',
  `function_author` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '生成功能作者',
  `page_model` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '页面模型:0:弹窗，1:跳转',
  `tree_data` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '左树右表的情况下，树形列表查询URL',
  PRIMARY KEY (`id`),
  KEY `gen_table_name` (`name`),
  KEY `gen_table_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='业务表';

/*Table structure for table `gen_table_column` */

DROP TABLE IF EXISTS `gen_table_column`;

CREATE TABLE `gen_table_column` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `gen_table_id` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '归属表编号',
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '名称',
  `comments` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  `jdbc_type` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '列的数据类型的字节长度',
  `java_type` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否主键',
  `is_null` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否可为空',
  `is_insert` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否为插入字段',
  `is_edit` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否编辑字段',
  `is_list` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否列表字段',
  `is_query` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '是否查询字段',
  `query_type` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '查询方式（等于、不等于、大于、小于、范围、左LIKE、右LIKE、左右LIKE）',
  `show_type` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '字段生成方案（文本框、文本域、下拉框、复选框、单选框、字典选择、人员选择、部门选择、区域选择）',
  `dict_type` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '字典类型',
  `settings` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '其它设置（扩展字段JSON）',
  `sort` decimal(10,0) DEFAULT NULL COMMENT '排序（升序）',
  `create_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `gen_table_column_table_id` (`gen_table_id`),
  KEY `gen_table_column_name` (`name`),
  KEY `gen_table_column_sort` (`sort`),
  KEY `gen_table_column_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='业务表字段';

/*Table structure for table `gen_template` */

DROP TABLE IF EXISTS `gen_template`;

CREATE TABLE `gen_template` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '名称',
  `category` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '分类',
  `file_path` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '生成文件路径',
  `file_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '生成文件名',
  `content` text COLLATE utf8_bin COMMENT '内容',
  `create_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `gen_template_del_falg` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='代码模板表';

/*Table structure for table `group_user` */

DROP TABLE IF EXISTS `group_user`;

CREATE TABLE `group_user` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户',
  `group_id` varchar(64) DEFAULT NULL COMMENT '群组id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='群组成员';

/*Table structure for table `hr_approval` */

DROP TABLE IF EXISTS `hr_approval`;

CREATE TABLE `hr_approval` (
  `id` varchar(64) NOT NULL COMMENT 'id',
  `name` varchar(50) DEFAULT NULL COMMENT '审批名称',
  `apply_name` varchar(50) DEFAULT NULL COMMENT '申请人姓名',
  `apply_org` varchar(50) DEFAULT NULL COMMENT '申请人部门',
  `approval_name` varchar(50) DEFAULT NULL COMMENT '审批人姓名',
  `notify_name` varchar(50) DEFAULT NULL COMMENT '抄送人姓名',
  `sp_status` int(2) DEFAULT NULL COMMENT '审批状态：1审批中；2 已通过；3已驳回；4已取消；6通过后撤销；10已支付',
  `sp_num` varchar(50) DEFAULT NULL COMMENT '审批单号',
  `apply_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '审批单提交时间',
  `apply_user_id` varchar(50) DEFAULT NULL COMMENT '审批单提交者的userid',
  `approval_type` char(2) DEFAULT NULL COMMENT '审批类型 0自定义，1.请假，2报销',
  `expense_type` int(1) DEFAULT NULL COMMENT '报销类型',
  `expense_reason` varchar(255) DEFAULT NULL COMMENT '报销事由',
  `leave_timeunit` int(1) DEFAULT NULL COMMENT '请假时间单位：0半天；1小时',
  `leave_type` int(2) DEFAULT NULL COMMENT '请假类型',
  `leave_start_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '请假开始时间',
  `leave_end_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '请假结束时间',
  `leave_duration` int(10) DEFAULT NULL COMMENT '请假时长，单位小时',
  `leave_reason` varchar(255) DEFAULT NULL COMMENT '请假事由',
  `apply_data` varchar(5000) DEFAULT NULL,
  `user_id` varchar(30) DEFAULT NULL COMMENT '系统用户id',
  `office_id` varchar(30) DEFAULT NULL,
  `account_id` varchar(30) DEFAULT NULL,
  `bk_checkin_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '补卡时间',
  `begin_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '结束时间',
  `duration` int(11) DEFAULT NULL COMMENT '时长',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业微信审批';

/*Table structure for table `hr_check_detail` */

DROP TABLE IF EXISTS `hr_check_detail`;

CREATE TABLE `hr_check_detail` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `groupname` varchar(64) NOT NULL COMMENT '打卡名称',
  `userid` varchar(64) NOT NULL COMMENT '用户id',
  `checkin_type` varchar(10) DEFAULT NULL COMMENT '打卡类型',
  `exception_type` varchar(10) DEFAULT NULL COMMENT '异常类型',
  `checkin_time` int(11) DEFAULT NULL COMMENT '打卡时间（毫秒）',
  `checkin_date` datetime DEFAULT NULL COMMENT '打卡日期',
  `location_title` varchar(100) DEFAULT NULL COMMENT '地点',
  `location_detail` varchar(400) DEFAULT NULL COMMENT '详细地址',
  `wifiname` varchar(20) DEFAULT NULL COMMENT '打卡的WIFI',
  `notes` varchar(100) DEFAULT NULL COMMENT '备注',
  `wifimac` varchar(200) DEFAULT NULL COMMENT '打卡的MAC地址/bssid',
  `mediaids` varchar(200) DEFAULT NULL COMMENT '打卡附件微信媒体编号',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='打卡明细';

/*Table structure for table `hr_check_report` */

DROP TABLE IF EXISTS `hr_check_report`;

CREATE TABLE `hr_check_report` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `groupname` varchar(50) NOT NULL COMMENT '规则名称',
  `userid` varchar(50) DEFAULT NULL COMMENT '用户id',
  `attendance_day` int(11) DEFAULT NULL COMMENT '应打卡天数',
  `normal_day` int(11) DEFAULT NULL COMMENT '正常天数',
  `abnormal_day` int(11) DEFAULT NULL COMMENT '异常天数',
  `attendance_card` int(11) DEFAULT NULL COMMENT '补卡',
  `annual_leave` int(11) DEFAULT NULL COMMENT '年假',
  `unpaid_leave` int(11) DEFAULT NULL COMMENT '事假',
  `sick_leave` int(11) DEFAULT NULL COMMENT '病假',
  `check_month` date DEFAULT NULL COMMENT '201806统计月份',
  `create_time` datetime DEFAULT NULL COMMENT '统计时间',
  `sys_user_id` varchar(30) NOT NULL COMMENT '系统用户ID',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `overtime_Leave` int(11) DEFAULT NULL COMMENT '调休假',
  `marital_Leave` int(11) DEFAULT NULL COMMENT '婚假',
  `maternity_Leave` int(11) DEFAULT NULL COMMENT '产假',
  `paternity_Leave` int(11) DEFAULT NULL COMMENT '陪产假',
  `other_Leave` int(11) DEFAULT NULL COMMENT '其他假期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='月度考勤汇总';

/*Table structure for table `hr_check_report_day` */

DROP TABLE IF EXISTS `hr_check_report_day`;

CREATE TABLE `hr_check_report_day` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `checkin_date` date DEFAULT NULL COMMENT '日期',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `sys_user_id` varchar(30) DEFAULT NULL COMMENT '姓名',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门',
  `groupname` varchar(50) DEFAULT NULL COMMENT ' 所属规则',
  `first_checkin_time` datetime DEFAULT NULL COMMENT '最早',
  `last_checkin_time` datetime DEFAULT NULL COMMENT '最晚',
  `checkin_num` int(11) DEFAULT NULL COMMENT '次数',
  `work_hours` decimal(10,1) DEFAULT NULL COMMENT '工作时长',
  `oa_audit_id` varchar(50) DEFAULT NULL COMMENT '审批单',
  `checkin_status` char(2) DEFAULT NULL COMMENT '状态',
  `audit_status` char(2) DEFAULT NULL COMMENT '校准状态',
  `leave_day` int(10) DEFAULT NULL COMMENT '请假天数 这里存的是小时',
  `unique_code` varchar(50) DEFAULT NULL COMMENT '唯一码',
  `update_flag` int(1) DEFAULT '0' COMMENT 'HR修改考勤结果标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每日打卡汇总';

/*Table structure for table `hr_check_report_detail` */

DROP TABLE IF EXISTS `hr_check_report_detail`;

CREATE TABLE `hr_check_report_detail` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `groupname` varchar(64) DEFAULT NULL COMMENT '规则名称',
  `userid` varchar(64) DEFAULT NULL COMMENT '用户编号',
  `checkin_type` varchar(10) DEFAULT NULL COMMENT '打卡类型',
  `exception_type` varchar(64) DEFAULT NULL COMMENT '异常类型',
  `checkin_time` int(10) DEFAULT NULL COMMENT '打卡毫秒',
  `checkin_date` datetime DEFAULT NULL COMMENT '打卡时间',
  `location_title` varchar(64) DEFAULT NULL COMMENT '地点',
  `location_detail` varchar(64) DEFAULT NULL COMMENT '详细地点',
  `wifiname` varchar(64) DEFAULT NULL COMMENT 'wifi',
  `notes` varchar(64) DEFAULT NULL COMMENT '备注',
  `wifimac` varchar(64) DEFAULT NULL COMMENT 'wifimac',
  `mediaids` varchar(200) DEFAULT NULL COMMENT '文件',
  `checkin_status` varchar(200) DEFAULT NULL COMMENT '状态',
  `office_id` varchar(200) DEFAULT NULL COMMENT 'office',
  `sys_user_id` varchar(200) DEFAULT NULL COMMENT 'yonh ',
  `sdate` date DEFAULT NULL COMMENT '打卡日期',
  `account_id` varchar(200) NOT NULL COMMENT '企业编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='打卡明细表';

/*Table structure for table `hr_check_report_sum` */

DROP TABLE IF EXISTS `hr_check_report_sum`;

CREATE TABLE `hr_check_report_sum` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `groupname` varchar(64) NOT NULL COMMENT '规则名称',
  `userid` varchar(64) NOT NULL COMMENT '用户id',
  `office_id` varchar(10) DEFAULT NULL COMMENT '部门id',
  `attendance_day` int(11) DEFAULT NULL COMMENT '应打卡天数',
  `normal_day` int(11) DEFAULT NULL COMMENT '正常天数',
  `abnormal_day` int(11) DEFAULT NULL COMMENT '异常天数',
  `attendance_card` int(11) DEFAULT NULL COMMENT '补卡',
  `annual_leave` int(11) DEFAULT NULL COMMENT '年假',
  `unpaid leave` int(11) DEFAULT NULL COMMENT '事假',
  `sick_leave` int(11) DEFAULT NULL COMMENT '病假',
  `check_month` int(11) DEFAULT NULL COMMENT '201806统计月份',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='月度却考勤汇总';

/*Table structure for table `hr_check_rule` */

DROP TABLE IF EXISTS `hr_check_rule`;

CREATE TABLE `hr_check_rule` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `group_Type` char(2) DEFAULT NULL COMMENT '打卡规则类型。1：固定时间上下班；2：按班次上下班；3：自由上下班',
  `group_id` varchar(64) NOT NULL COMMENT '打卡规则id',
  `groupname` varchar(64) NOT NULL COMMENT '打卡名称',
  `workdays` varchar(64) NOT NULL COMMENT '打卡日期1，2，3，4',
  `flex_time` int(11) DEFAULT NULL COMMENT '弹性时间（毫秒）',
  `noneed_offwork` tinyint(1) DEFAULT NULL COMMENT '1  or 0',
  `limit_aheadtime` int(11) DEFAULT NULL COMMENT '打卡时间限制（毫秒）',
  `checkintime` varchar(400) DEFAULT NULL COMMENT '打卡时间存json',
  `spe_offdays` varchar(400) DEFAULT NULL COMMENT '不需要打卡的时间Json',
  `spe_workdays` varchar(400) DEFAULT NULL COMMENT '需要打卡的时间Json',
  `sync_holidays` tinyint(1) DEFAULT NULL COMMENT '1  or 0同步节假日',
  `need_photo` tinyint(1) DEFAULT NULL COMMENT '1  or 0 拍照打卡',
  `wifimac_infos` varchar(400) DEFAULT NULL COMMENT 'wifi信息',
  `note_can_use_local_pic` tinyint(1) DEFAULT NULL COMMENT '1  or 0是否备注时允许上传本地图片',
  `allow_checkin_offworkday` tinyint(1) DEFAULT NULL COMMENT '1  or 0 是否非工作日允许打卡',
  `allow_apply_offworkday` tinyint(1) DEFAULT NULL COMMENT '1  or 0补卡申请',
  `loc_infos` varchar(400) DEFAULT NULL COMMENT '位置打卡地点信息json',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='打卡规则表';

/*Table structure for table `hr_check_user` */

DROP TABLE IF EXISTS `hr_check_user`;

CREATE TABLE `hr_check_user` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `userid` varchar(64) NOT NULL COMMENT '用户id',
  `check_rule_id` varchar(30) DEFAULT NULL COMMENT '打卡规则表',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='打卡用户规则关系表';

/*Table structure for table `hr_contract` */

DROP TABLE IF EXISTS `hr_contract`;

CREATE TABLE `hr_contract` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `recruitMode` varchar(64) NOT NULL COMMENT '聘用形式.正式，劳务，兼职，实习，返聘',
  `code` varchar(64) NOT NULL COMMENT ' 合同编号',
  `contract_Type` varchar(64) NOT NULL COMMENT ' 合同类型。实习生合同，劳务合同',
  `contract_status` varchar(64) NOT NULL COMMENT ' 合同状态，执行中，结束，意外终止',
  `start_Time` date DEFAULT NULL COMMENT '开始时间',
  `end_time` date DEFAULT NULL COMMENT ' 结束时间',
  `probation_end_time` date DEFAULT NULL COMMENT ' 试用期结束时间',
  `regular_time` date DEFAULT NULL COMMENT ' 转正时间',
  `enclosure` varchar(64) NOT NULL COMMENT ' 合同附件',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `hr_employee_id` varchar(64) NOT NULL COMMENT '用户表',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='人事系统合同表';

/*Table structure for table `hr_employee` */

DROP TABLE IF EXISTS `hr_employee`;

CREATE TABLE `hr_employee` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `sex` char(1) DEFAULT NULL COMMENT '性别',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证号',
  `id_card_img` varchar(255) DEFAULT NULL COMMENT '身份证照',
  `native_place` varchar(30) DEFAULT NULL COMMENT '籍贯',
  `nation` varchar(30) DEFAULT NULL COMMENT '民族',
  `en_name` varchar(50) DEFAULT NULL COMMENT '英文名',
  `marital_status` char(1) DEFAULT NULL COMMENT '婚姻状况',
  `birthday` varchar(10) DEFAULT NULL COMMENT '生日',
  `registration` varchar(50) DEFAULT NULL COMMENT '户籍所在地',
  `political` varchar(20) DEFAULT NULL COMMENT '政治面貌',
  `children` varchar(50) DEFAULT NULL COMMENT '子女状态',
  `mobile` varchar(20) DEFAULT NULL COMMENT '联系手机',
  `email` varchar(50) DEFAULT NULL COMMENT '个人邮箱',
  `qq` varchar(50) DEFAULT NULL COMMENT 'QQ',
  `wx` varchar(50) DEFAULT NULL COMMENT '微信',
  `city` varchar(50) DEFAULT NULL COMMENT '居住城市',
  `address` varchar(50) DEFAULT NULL COMMENT '通讯地址',
  `contact_people` varchar(50) DEFAULT NULL COMMENT '紧急联系人',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '紧急联系电话',
  `social_security_no` varchar(50) DEFAULT NULL COMMENT '社保电脑号',
  `accumulation_no` varchar(50) DEFAULT NULL COMMENT '公积金账号',
  `bank_card_no` varchar(30) DEFAULT NULL COMMENT '银行卡号',
  `bank_card_name` varchar(50) DEFAULT NULL COMMENT '开户行',
  `education_type` char(1) DEFAULT NULL COMMENT '最高学历',
  `graduate_school` varchar(50) DEFAULT NULL COMMENT '毕业学校',
  `school_start` varchar(20) DEFAULT NULL,
  `school_end` varchar(20) DEFAULT NULL,
  `specialty` varchar(50) DEFAULT NULL COMMENT '专业',
  `certificate_img` varchar(255) DEFAULT NULL COMMENT '毕业证书',
  `last_company` varchar(50) DEFAULT NULL COMMENT '上家公司',
  `last_position` varchar(50) DEFAULT NULL COMMENT '上家公司职位',
  `leaving_certify` varchar(255) DEFAULT NULL COMMENT '前公司离职证明',
  `entry_date` date DEFAULT NULL COMMENT '入职日期',
  `regular_date` date DEFAULT NULL COMMENT '转正日期（正式）',
  `regular_status` char(1) DEFAULT NULL COMMENT '转正状态（正式）',
  `regular_evaluation` varchar(200) DEFAULT NULL COMMENT '转正评价',
  `probation_period` int(2) DEFAULT NULL COMMENT '试用期',
  `employ_type` char(1) DEFAULT NULL COMMENT '聘用形式',
  `position` varchar(50) DEFAULT NULL COMMENT '职位',
  `first_work_date` date DEFAULT NULL COMMENT '首次参加工作时间',
  `work_address` varchar(50) DEFAULT NULL COMMENT '工作地点',
  `contract_start_date` date DEFAULT NULL COMMENT '现合同开始时间',
  `contract_end_date` date DEFAULT NULL COMMENT '现合同结束时间',
  `contract_file` varchar(255) DEFAULT NULL COMMENT '合同文件',
  `recruit_source` char(1) DEFAULT NULL COMMENT '招聘渠道',
  `recommend` varchar(50) DEFAULT NULL COMMENT '推荐企业/人',
  `formal_salary_base` decimal(12,2) DEFAULT NULL COMMENT '工资基数(元)',
  `probation_salary_base` decimal(12,2) DEFAULT NULL COMMENT '试用期工资基数',
  `salary_remarks` varchar(200) DEFAULT NULL COMMENT '薪酬备注',
  `status` char(1) DEFAULT NULL COMMENT '员工状态',
  `is_edit` char(1) DEFAULT NULL COMMENT '允许员工自己编辑信息',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `sys_user_id` varchar(64) DEFAULT NULL COMMENT '基础用户表',
  `hr_resume_id` varchar(64) DEFAULT NULL COMMENT '对应简历ID',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_employee_status` (`status`),
  KEY `index_employee_delflag` (`del_flag`),
  KEY `index_employee_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='员工信息';

/*Table structure for table `hr_interview` */

DROP TABLE IF EXISTS `hr_interview`;

CREATE TABLE `hr_interview` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `position` varchar(50) DEFAULT NULL COMMENT '岗位',
  `interview_date` datetime DEFAULT NULL COMMENT '面试日期',
  `interview_time` datetime DEFAULT NULL COMMENT '面试时间1520',
  `invitate_status` char(1) DEFAULT NULL COMMENT '邀约状态',
  `link_man` varchar(50) DEFAULT NULL COMMENT '联系人',
  `link_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `company` varchar(50) DEFAULT NULL COMMENT '公司名称',
  `address` varchar(50) DEFAULT NULL COMMENT '面试地点',
  `sign_status` char(1) DEFAULT NULL COMMENT '签到状态 0： 未签到，1：已签到',
  `sign_time` datetime DEFAULT NULL COMMENT '签到时间1520',
  `interview` varchar(64) DEFAULT NULL COMMENT '面试人',
  `interview_note` varchar(200) DEFAULT NULL COMMENT '面试反馈',
  `interview_status` char(1) DEFAULT NULL COMMENT '反馈状态',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `hr_resume_id` varchar(64) DEFAULT NULL COMMENT '对应简历ID',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='面试';

/*Table structure for table `hr_mail` */

DROP TABLE IF EXISTS `hr_mail`;

CREATE TABLE `hr_mail` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `mail_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '邮箱发送名称',
  `mail_account` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '邮箱账户',
  `mail_pass` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '邮箱密码',
  `pop3_addr` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT 'POP3邮件服务地址',
  `smtp_addr` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT 'SMTP邮件服务地址',
  `account_id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '企业帐号',
  `create_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='代码模板表';

/*Table structure for table `hr_offer` */

DROP TABLE IF EXISTS `hr_offer`;

CREATE TABLE `hr_offer` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `hr_resume_id` varchar(64) DEFAULT NULL COMMENT '简历ID',
  `read_email` varchar(50) DEFAULT NULL COMMENT '抄送邮箱',
  `validity_period` int(2) DEFAULT NULL COMMENT '有效期',
  `report_date` datetime DEFAULT NULL COMMENT '报到时间',
  `probation_period` int(2) DEFAULT NULL COMMENT '试用期',
  `position` varchar(50) DEFAULT NULL COMMENT '入职岗位',
  `department` varchar(50) DEFAULT NULL COMMENT '入职部门',
  `address` varchar(50) DEFAULT NULL COMMENT '公司地址',
  `link_man` varchar(50) DEFAULT NULL COMMENT '入职联系人',
  `link_phone` varchar(50) DEFAULT NULL COMMENT '联系人电话',
  `company` varchar(50) DEFAULT NULL COMMENT '公司名称',
  `formal_salary_base` decimal(12,2) DEFAULT NULL COMMENT '工资基数(元)',
  `probation_salary_base` decimal(12,2) DEFAULT NULL COMMENT '试用期工资基数',
  `salary_remarks` varchar(200) DEFAULT NULL COMMENT '薪酬备注',
  `offer_file` varchar(255) DEFAULT NULL COMMENT '附件 ',
  `status` char(1) DEFAULT NULL COMMENT '状态( 1：已发送，2：已确认)',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='OFFER';

/*Table structure for table `hr_option` */

DROP TABLE IF EXISTS `hr_option`;

CREATE TABLE `hr_option` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `grant_date` date DEFAULT NULL COMMENT '授予日期',
  `grant_num` int(11) DEFAULT NULL COMMENT '授予数量',
  `proportion` decimal(12,2) DEFAULT NULL COMMENT '比例',
  `round_num` varchar(20) DEFAULT NULL COMMENT '轮次',
  `lock_period` decimal(12,2) DEFAULT NULL COMMENT '锁定期',
  `mature_num` int(11) DEFAULT NULL COMMENT '已成熟数量',
  `option_file` varchar(255) DEFAULT NULL COMMENT '期权合同',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `hr_employee_id` varchar(30) NOT NULL COMMENT '员工ID',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='期权';

/*Table structure for table `hr_position_change` */

DROP TABLE IF EXISTS `hr_position_change`;

CREATE TABLE `hr_position_change` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `old_office_id` varchar(64) DEFAULT NULL COMMENT '调整前部门',
  `old_position` varchar(50) DEFAULT NULL COMMENT '调整前岗位',
  `old_position_level` varchar(50) DEFAULT NULL COMMENT '调整前职级',
  `office_id` varchar(64) DEFAULT NULL COMMENT '调整后部门',
  `position` varchar(50) DEFAULT NULL COMMENT '调整后岗位',
  `position_level` varchar(50) DEFAULT NULL COMMENT '调整后职级',
  `change_date` date DEFAULT NULL COMMENT '调岗时间',
  `change_cause` varchar(200) DEFAULT NULL COMMENT '调岗原因',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `hr_employee_id` varchar(30) NOT NULL COMMENT '员工ID',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='调岗';

/*Table structure for table `hr_quit` */

DROP TABLE IF EXISTS `hr_quit`;

CREATE TABLE `hr_quit` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `quit_type` char(1) DEFAULT NULL COMMENT '离职类型',
  `quit_date` date DEFAULT NULL COMMENT '离职时间',
  `quit_cause` varchar(200) DEFAULT NULL COMMENT '离职原因',
  `apply_quit_cause` varchar(200) DEFAULT NULL COMMENT '申请离职原因',
  `compensation` decimal(12,2) DEFAULT NULL COMMENT '补偿金',
  `social_over_month` char(1) DEFAULT NULL COMMENT '社保减员月',
  `fund_over_month` char(1) DEFAULT NULL COMMENT '公积金减员月',
  `annual_leave` int(3) DEFAULT NULL COMMENT '剩余年假',
  `rest_leave` int(3) DEFAULT NULL COMMENT '剩余调休',
  `work_content` varchar(300) DEFAULT NULL COMMENT '工作交接内容',
  `work_by` varchar(30) DEFAULT NULL COMMENT '工作交接给',
  `work_status` char(1) DEFAULT NULL COMMENT '工作交接完成情况',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `hr_employee_id` varchar(30) NOT NULL COMMENT '员工ID',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='离职';

/*Table structure for table `hr_recruit` */

DROP TABLE IF EXISTS `hr_recruit`;

CREATE TABLE `hr_recruit` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(64) DEFAULT NULL COMMENT '岗位名称',
  `depart` varchar(50) DEFAULT NULL COMMENT '需求部门',
  `recruit_num` int(11) DEFAULT NULL COMMENT '招聘人数',
  `education` varchar(50) DEFAULT NULL COMMENT '学历要求',
  `experience` varchar(50) DEFAULT NULL COMMENT '工作经验',
  `schedule` int(10) DEFAULT '0' COMMENT '进度',
  `status` char(1) DEFAULT NULL COMMENT '状态：0进行中，1：已结束',
  `resume_num` int(10) DEFAULT '0' COMMENT '接收简历数',
  `interview_num` int(10) DEFAULT '0' COMMENT '面试数',
  `offer_num` int(10) DEFAULT '0' COMMENT 'offer数',
  `entry_num` int(10) DEFAULT '0' COMMENT '已入职',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='招聘任务';

/*Table structure for table `hr_resume` */

DROP TABLE IF EXISTS `hr_resume`;

CREATE TABLE `hr_resume` (
  `id` varchar(64) CHARACTER SET utf8mb4 NOT NULL COMMENT '编号',
  `hr_recruit_id` varchar(64) DEFAULT NULL COMMENT '招聘任务',
  `resume_source` varchar(2) DEFAULT NULL COMMENT '简历来源 1:智联，2:51job, 3:拉钩，10：其他',
  `position` varchar(50) DEFAULT NULL COMMENT '应聘岗位',
  `resume_file` varchar(255) DEFAULT NULL COMMENT '简历文件',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `sex` char(2) DEFAULT NULL COMMENT '性别',
  `age` int(3) DEFAULT NULL COMMENT '年龄',
  `mobile` varchar(11) DEFAULT NULL COMMENT '手机号',
  `mail` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `experience` int(2) DEFAULT NULL COMMENT '工作经验',
  `education` varchar(20) DEFAULT NULL COMMENT '学历',
  `last_company` varchar(50) DEFAULT NULL COMMENT '当前公司',
  `last_job` varchar(50) DEFAULT NULL COMMENT '当前职位',
  `university` varchar(50) DEFAULT NULL COMMENT '毕业院校',
  `specialty` varchar(50) DEFAULT NULL COMMENT '专业',
  `current_node` char(1) DEFAULT NULL COMMENT '当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库',
  `resume_status` char(1) DEFAULT NULL COMMENT '简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过',
  `interview_status` char(1) DEFAULT NULL COMMENT '面试状态：已邀约0，1已签到, 2已面试 3: 已取消',
  `interview_num` int(5) DEFAULT NULL COMMENT '面试次数',
  `employ_status` char(1) DEFAULT NULL COMMENT '录用状态：0待确认,1已接受, 2已入职,3已拒绝',
  `reserve_status` char(1) DEFAULT NULL COMMENT '人才库状态：0已淘汰，人才储备，2未入职',
  `reserve_cause` char(1) DEFAULT NULL COMMENT '放弃原因',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `hr_employee_id` varchar(30) DEFAULT NULL COMMENT '基础用户表',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `hr_resume_current_node` (`current_node`),
  KEY `hr_resume_delflag` (`del_flag`),
  KEY `hr_resume_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='简历';

/*Table structure for table `hr_resume_log` */

DROP TABLE IF EXISTS `hr_resume_log`;

CREATE TABLE `hr_resume_log` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `hr_resume_id` varchar(64) NOT NULL COMMENT '简历编号',
  `note` varchar(200) DEFAULT NULL COMMENT '内容',
  `type` char(2) DEFAULT NULL COMMENT '事件类型： 1上传简历，2邀约面试，3：下发录用OFFER，4：入职',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  `del_flag` char(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='简历日志';

/*Table structure for table `hr_resume_record` */

DROP TABLE IF EXISTS `hr_resume_record`;

CREATE TABLE `hr_resume_record` (
  `id` varchar(64) NOT NULL,
  `hr_resume_id` varchar(64) DEFAULT NULL COMMENT '简历',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` datetime DEFAULT NULL COMMENT '时间',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邀请记录';

/*Table structure for table `hr_salary` */

DROP TABLE IF EXISTS `hr_salary`;

CREATE TABLE `hr_salary` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `year` varchar(4) DEFAULT NULL COMMENT '年份',
  `month` varchar(2) DEFAULT NULL COMMENT '月份',
  `work_days` int(10) DEFAULT NULL COMMENT '应出勤天数',
  `status` char(1) DEFAULT NULL COMMENT '状态(0未审核，1已审核)',
  `audit_by` varchar(64) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '审核日期',
  `create_by` varchar(64) DEFAULT NULL COMMENT '制单人',
  `create_date` datetime DEFAULT NULL COMMENT '制单日期',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工资表';

/*Table structure for table `hr_salary_change` */

DROP TABLE IF EXISTS `hr_salary_change`;

CREATE TABLE `hr_salary_change` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `hr_employee_id` varchar(30) DEFAULT NULL COMMENT '员工',
  `old_base_salary` decimal(10,2) DEFAULT NULL COMMENT '调薪前基本工资',
  `base_salary` decimal(10,2) DEFAULT NULL COMMENT '调薪后基本工资',
  `change_range` decimal(10,2) DEFAULT NULL COMMENT '调整幅度',
  `effect_date` date DEFAULT NULL COMMENT '调薪生效时间',
  `change_cause` varchar(200) DEFAULT NULL COMMENT '调薪原因',
  `status` char(1) DEFAULT '' COMMENT '状态(0未审核，1已审核)',
  `audit_by` varchar(64) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '审核日期',
  `create_by` varchar(64) DEFAULT NULL COMMENT '制单人',
  `create_date` datetime DEFAULT NULL COMMENT '制单日期',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='调薪';

/*Table structure for table `hr_salary_detail` */

DROP TABLE IF EXISTS `hr_salary_detail`;

CREATE TABLE `hr_salary_detail` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `hr_salary_id` varchar(64) DEFAULT NULL COMMENT '归属工资表',
  `hr_employee_id` varchar(30) DEFAULT NULL COMMENT '员工',
  `year_month` varchar(20) DEFAULT NULL COMMENT '月份',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `must_work_days` int(10) DEFAULT NULL COMMENT '应出勤天数',
  `real_work_days` int(10) DEFAULT NULL COMMENT '实际出勤天数',
  `extra_work_days` int(10) DEFAULT NULL COMMENT '加班天数',
  `leave_days` int(10) DEFAULT NULL COMMENT '请假天数',
  `absent_days` int(10) DEFAULT NULL COMMENT '旷工天数',
  `base_salary` decimal(10,2) DEFAULT NULL COMMENT '基本工资',
  `post_salary` decimal(10,2) DEFAULT NULL COMMENT '岗位工资',
  `bonus_salary` decimal(10,2) DEFAULT NULL COMMENT '奖金',
  `overtime_salary` decimal(10,2) DEFAULT NULL COMMENT '加班费',
  `should_amt` decimal(10,2) DEFAULT NULL COMMENT '应发合计',
  `social_amt` decimal(10,2) DEFAULT NULL COMMENT '社保',
  `fund_amt` decimal(10,2) DEFAULT NULL COMMENT '公积金',
  `tax_amt` decimal(10,2) DEFAULT NULL COMMENT '个税',
  `seduct_salary` decimal(10,2) DEFAULT NULL COMMENT '应扣工资',
  `real_amt` decimal(10,2) DEFAULT NULL COMMENT '实发工资',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '制单人',
  `create_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '制单日期',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工资明细';

/*Table structure for table `hr_template` */

DROP TABLE IF EXISTS `hr_template`;

CREATE TABLE `hr_template` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(1) DEFAULT NULL COMMENT '模板分类',
  `name` varchar(50) DEFAULT NULL COMMENT '模板名称',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` varchar(10000) DEFAULT NULL COMMENT '模板内容',
  `is_default` char(1) DEFAULT NULL COMMENT '是否默认',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) NOT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='HR模板';

/*Table structure for table `iim_chat_history` */

DROP TABLE IF EXISTS `iim_chat_history`;

CREATE TABLE `iim_chat_history` (
  `id` varchar(64) NOT NULL,
  `userid1` varchar(64) DEFAULT NULL,
  `userid2` varchar(64) DEFAULT NULL,
  `msg` varchar(1024) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `iim_group` */

DROP TABLE IF EXISTS `iim_group`;

CREATE TABLE `iim_group` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `groupname` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '群组名',
  `avatar` varchar(256) DEFAULT NULL COMMENT '群头像',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='群组';

/*Table structure for table `iim_mail` */

DROP TABLE IF EXISTS `iim_mail`;

CREATE TABLE `iim_mail` (
  `id` varchar(64) NOT NULL,
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `overview` varchar(128) DEFAULT NULL COMMENT '内容概要',
  `content` longblob COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件';

/*Table structure for table `iim_mail_box` */

DROP TABLE IF EXISTS `iim_mail_box`;

CREATE TABLE `iim_mail_box` (
  `id` varchar(64) NOT NULL,
  `readstatus` varchar(45) DEFAULT NULL COMMENT '状态 0 未读 1 已读',
  `senderId` varchar(64) DEFAULT NULL COMMENT '发件人',
  `receiverId` varchar(6400) DEFAULT NULL COMMENT '收件人',
  `sendtime` datetime DEFAULT NULL COMMENT '发送时间',
  `mailid` varchar(64) DEFAULT NULL COMMENT '邮件外键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收件箱';

/*Table structure for table `iim_mail_compose` */

DROP TABLE IF EXISTS `iim_mail_compose`;

CREATE TABLE `iim_mail_compose` (
  `id` varchar(64) NOT NULL,
  `status` varchar(45) DEFAULT NULL COMMENT '状态 0 草稿 1 已发送',
  `readstatus` varchar(45) DEFAULT NULL COMMENT '状态 0 未读 1 已读',
  `senderId` varchar(64) DEFAULT NULL COMMENT '发送者',
  `receiverId` varchar(6400) DEFAULT NULL COMMENT '接收者',
  `sendtime` datetime DEFAULT NULL COMMENT '发送时间',
  `mailId` varchar(64) DEFAULT NULL COMMENT '邮件id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发件箱 草稿箱';

/*Table structure for table `kms_article` */

DROP TABLE IF EXISTS `kms_article`;

CREATE TABLE `kms_article` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `category_id` varchar(30) DEFAULT NULL COMMENT '栏目名称',
  `title` varchar(50) NOT NULL COMMENT '文章标题',
  `link` varchar(250) DEFAULT NULL COMMENT '文章链接',
  `image` varchar(250) DEFAULT NULL COMMENT '文章图片',
  `keywords` varchar(50) DEFAULT NULL COMMENT '关键字',
  `description` varchar(250) DEFAULT NULL COMMENT '摘要',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `hits` int(11) DEFAULT NULL COMMENT '点击数',
  `comments` int(11) DEFAULT NULL COMMENT '评论数',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_care_create_by` (`create_by`) USING BTREE,
  KEY `index_care_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章';

/*Table structure for table `kms_article_data` */

DROP TABLE IF EXISTS `kms_article_data`;

CREATE TABLE `kms_article_data` (
  `id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `content` text COLLATE utf8_bin COMMENT '文章内容',
  `files` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `copyfrom` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '文章来源',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='文章详情';

/*Table structure for table `kms_category` */

DROP TABLE IF EXISTS `kms_category`;

CREATE TABLE `kms_category` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) DEFAULT NULL COMMENT '栏目名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `in_menu` char(1) DEFAULT NULL COMMENT '是否在导航中显示',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_protype_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='栏目';

/*Table structure for table `kms_comment` */

DROP TABLE IF EXISTS `kms_comment`;

CREATE TABLE `kms_comment` (
  `id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `category_id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '栏目编号',
  `article_id` varchar(30) COLLATE utf8_bin NOT NULL COMMENT '文章编号',
  `content` varchar(250) COLLATE utf8_bin DEFAULT NULL COMMENT '评论内容',
  `create_by` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '评论人',
  `create_date` datetime NOT NULL COMMENT '评论时间',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `cms_comment_category_id` (`category_id`),
  KEY `cms_comment_content_id` (`article_id`),
  KEY `cms_comment_status` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='文章评论';

/*Table structure for table `monitor` */

DROP TABLE IF EXISTS `monitor`;

CREATE TABLE `monitor` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `cpu` varchar(64) DEFAULT NULL COMMENT 'cpu使用率',
  `jvm` varchar(64) DEFAULT NULL COMMENT 'jvm使用率',
  `ram` varchar(64) DEFAULT NULL COMMENT '内存使用率',
  `toemail` varchar(64) DEFAULT NULL COMMENT '警告通知邮箱',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='系统监控';

/*Table structure for table `oa_calendar` */

DROP TABLE IF EXISTS `oa_calendar`;

CREATE TABLE `oa_calendar` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `title` varchar(64) DEFAULT NULL COMMENT '事件标题',
  `starttime` varchar(64) DEFAULT NULL COMMENT '事件开始时间',
  `endtime` varchar(64) DEFAULT NULL COMMENT '事件结束时间',
  `allday` varchar(64) DEFAULT NULL COMMENT '是否为全天时间',
  `color` varchar(64) DEFAULT NULL COMMENT '时间的背景色',
  `userid` varchar(64) DEFAULT NULL COMMENT 'userid',
  `customer_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日历';

/*Table structure for table `oa_common_audit` */

DROP TABLE IF EXISTS `oa_common_audit`;

CREATE TABLE `oa_common_audit` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(2) DEFAULT NULL COMMENT '审批类型',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `files` varchar(1000) DEFAULT NULL COMMENT '附件',
  `current_by` varchar(64) DEFAULT NULL COMMENT '下一审批人',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `office_id` varchar(64) DEFAULT NULL COMMENT '部门',
  `own_by` varchar(64) DEFAULT NULL COMMENT '申请人',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_audit_type` (`type`),
  KEY `index_audit_common_del_flag` (`del_flag`) USING BTREE,
  KEY `index_audit_common_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='普通审批流程';

/*Table structure for table `oa_common_audit_record` */

DROP TABLE IF EXISTS `oa_common_audit_record`;

CREATE TABLE `oa_common_audit_record` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `common_audit_id` varchar(64) DEFAULT NULL COMMENT '审批ID',
  `deal_type` varchar(1) DEFAULT NULL COMMENT '执行类型(0:审批，1:抄送)',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` datetime DEFAULT NULL COMMENT '阅读时间',
  `audit_status` char(1) DEFAULT NULL COMMENT '审批结果',
  `audit_date` datetime DEFAULT NULL COMMENT '审批时间',
  `audit_notes` varchar(200) DEFAULT NULL COMMENT '审批意见',
  `audit_order` int(5) DEFAULT NULL COMMENT '审批顺序',
  PRIMARY KEY (`id`),
  KEY `oa_common_audit_notify_id` (`common_audit_id`) USING BTREE,
  KEY `oa_common_audit_user_id` (`user_id`) USING BTREE,
  KEY `oa_common_audit_read_flag` (`read_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='审批记录';

/*Table structure for table `oa_common_borrow` */

DROP TABLE IF EXISTS `oa_common_borrow`;

CREATE TABLE `oa_common_borrow` (
  `id` varchar(30) NOT NULL COMMENT '审批流程编号',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '借款总额',
  `borrow_date` datetime DEFAULT NULL COMMENT '借款时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='借款单';

/*Table structure for table `oa_common_expense` */

DROP TABLE IF EXISTS `oa_common_expense`;

CREATE TABLE `oa_common_expense` (
  `id` varchar(30) NOT NULL COMMENT '审批流程编号',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '报销总额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报销单';

/*Table structure for table `oa_common_expense_detail` */

DROP TABLE IF EXISTS `oa_common_expense_detail`;

CREATE TABLE `oa_common_expense_detail` (
  `id` varchar(30) NOT NULL COMMENT '审批流程编号',
  `expense_id` varchar(30) DEFAULT NULL COMMENT '报销单ID',
  `item_name` varchar(50) DEFAULT NULL COMMENT '报销事项',
  `date` datetime DEFAULT NULL COMMENT '日期',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '报销金额（元）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='报销单明细';

/*Table structure for table `oa_common_extra` */

DROP TABLE IF EXISTS `oa_common_extra`;

CREATE TABLE `oa_common_extra` (
  `id` varchar(30) NOT NULL COMMENT '审批流程编号',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `extra_type` char(1) DEFAULT NULL COMMENT '加班类型',
  `days_num` decimal(5,2) DEFAULT NULL COMMENT '加班时长(天)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='加班单';

/*Table structure for table `oa_common_flow` */

DROP TABLE IF EXISTS `oa_common_flow`;

CREATE TABLE `oa_common_flow` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(2) DEFAULT NULL COMMENT '审批类型',
  `title` varchar(50) DEFAULT NULL COMMENT '流程名称',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_audit_type` (`type`),
  KEY `index_audit_common_del_flag` (`del_flag`) USING BTREE,
  KEY `index_audit_common_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程配置';

/*Table structure for table `oa_common_flow_detail` */

DROP TABLE IF EXISTS `oa_common_flow_detail`;

CREATE TABLE `oa_common_flow_detail` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `common_flow_id` varchar(64) DEFAULT NULL COMMENT '审批ID',
  `deal_type` varchar(1) DEFAULT NULL COMMENT '执行类型(0:审批，1:抄送)',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `sort` int(5) DEFAULT NULL COMMENT '执行顺序',
  PRIMARY KEY (`id`),
  KEY `oa_common_audit_notify_id` (`common_flow_id`) USING BTREE,
  KEY `oa_common_audit_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程明细';

/*Table structure for table `oa_common_leave` */

DROP TABLE IF EXISTS `oa_common_leave`;

CREATE TABLE `oa_common_leave` (
  `id` varchar(30) NOT NULL COMMENT '审批流程编号',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `leave_type` char(1) DEFAULT NULL COMMENT '请假类型',
  `days_num` decimal(5,2) DEFAULT NULL COMMENT '请假时长(天)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='请假单';

/*Table structure for table `oa_common_travel` */

DROP TABLE IF EXISTS `oa_common_travel`;

CREATE TABLE `oa_common_travel` (
  `id` varchar(30) NOT NULL COMMENT '审批流程编号',
  `start_address` varchar(30) DEFAULT NULL COMMENT '出发地',
  `dest_address` varchar(30) DEFAULT NULL COMMENT '出差城市',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `budget_amt` decimal(12,2) DEFAULT NULL COMMENT '预算金额',
  `advance_amt` decimal(12,2) DEFAULT NULL COMMENT '预支金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='差旅单';

/*Table structure for table `oa_leave` */

DROP TABLE IF EXISTS `oa_leave`;

CREATE TABLE `oa_leave` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `process_instance_id` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '流程实例编号',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `leave_type` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '请假类型',
  `reason` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '请假理由',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  `reality_start_time` datetime DEFAULT NULL COMMENT '实际开始时间',
  `reality_end_time` datetime DEFAULT NULL COMMENT '实际结束时间',
  `create_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `oa_leave_create_by` (`create_by`),
  KEY `oa_leave_process_instance_id` (`process_instance_id`),
  KEY `oa_leave_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='请假流程表';

/*Table structure for table `oa_note` */

DROP TABLE IF EXISTS `oa_note`;

CREATE TABLE `oa_note` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `notes` varchar(50) NOT NULL COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='便签';

/*Table structure for table `oa_notify` */

DROP TABLE IF EXISTS `oa_notify`;

CREATE TABLE `oa_notify` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(1) DEFAULT NULL COMMENT '类型',
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `files` varchar(2000) DEFAULT NULL COMMENT '附件',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oa_notify_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通知通告';

/*Table structure for table `oa_notify_record` */

DROP TABLE IF EXISTS `oa_notify_record`;

CREATE TABLE `oa_notify_record` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `oa_notify_id` varchar(64) DEFAULT NULL COMMENT '通知通告ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` date DEFAULT NULL COMMENT '阅读时间',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oa_notify_record_notify_id` (`oa_notify_id`),
  KEY `oa_notify_record_user_id` (`user_id`),
  KEY `oa_notify_record_read_flag` (`read_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通知通告发送记录';

/*Table structure for table `oa_proj_cons` */

DROP TABLE IF EXISTS `oa_proj_cons`;

CREATE TABLE `oa_proj_cons` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `PROC_INS_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '流程实例ID',
  `PROJ_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '项目ID',
  `STATUS` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '定位当前节点',
  `USER_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '申请用户',
  `files` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '附件',
  `AUDIT_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '审批人',
  `AUDIT_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '审批意见',
  `create_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  `OFFICE_ID` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `OA_PROJ_CONS_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='项目咨询流程表';

/*Table structure for table `oa_proj_impl` */

DROP TABLE IF EXISTS `oa_proj_impl`;

CREATE TABLE `oa_proj_impl` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `PROC_INS_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '流程实例ID',
  `PROJ_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '项目ID',
  `STATUS` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '定位当前节点',
  `USER_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '申请用户ID',
  `USER_NAME` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '申请用户名称',
  `OFFICE_ID` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '申请用户部门ID',
  `OFFICE_NAME` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '申请用户部门名',
  `files` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '附件',
  `AUDIT_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '审批人ID',
  `AUDIT_NAME` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '审批人姓名',
  `AUDIT_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '审批意见',
  `create_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者ID',
  `create_by_name` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者姓名',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者ID',
  `update_by_name` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者姓名',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `OA_PROJ_IMPL_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='项目实施流程表';

/*Table structure for table `oa_project` */

DROP TABLE IF EXISTS `oa_project`;

CREATE TABLE `oa_project` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '项目编号',
  `name` varchar(50) NOT NULL COMMENT '项目名称',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL COMMENT '截止日期',
  `schedule` int(11) DEFAULT NULL COMMENT '进度',
  `content` text COMMENT '项目描述',
  `files` varchar(2000) DEFAULT NULL COMMENT '附件',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `status` char(1) DEFAULT '0' COMMENT '任务状态',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `office_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oa_project_del_flag` (`del_flag`) USING BTREE,
  KEY `oa_project_create_by` (`create_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='项目';

/*Table structure for table `oa_project_cons` */

DROP TABLE IF EXISTS `oa_project_cons`;

CREATE TABLE `oa_project_cons` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `PROC_INS_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '流程实例ID',
  `USER_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '申请用户',
  `OFFICE_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '归属部门',
  `POST` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '岗位',
  `HR_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '项目负责人意见',
  `LEAD_FST_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '院领导1意见',
  `LEAD_SEC_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '院领导2意见',
  `create_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  `files` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '附件',
  `PROJECT_ID` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID1` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID2` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID3` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `OA_TEST_AUDIT_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='项目咨询流程表';

/*Table structure for table `oa_project_impl` */

DROP TABLE IF EXISTS `oa_project_impl`;

CREATE TABLE `oa_project_impl` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `PROC_INS_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '流程实例ID',
  `USER_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '变动用户',
  `OFFICE_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '归属部门',
  `POST` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '岗位',
  `CONTENT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '调整原因',
  `EXE_DATE` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '执行时间',
  `LEAD_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '项目负责人意见',
  `MAIN_LEAD_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '领导意见',
  `create_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  `files` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '附件',
  `PROJECT_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `OA_PROJECT_IMPL_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='项目实施流程表';

/*Table structure for table `oa_project_record` */

DROP TABLE IF EXISTS `oa_project_record`;

CREATE TABLE `oa_project_record` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `oa_project_id` varchar(64) DEFAULT NULL COMMENT '项目ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` datetime DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  KEY `oa_project_record_notify_id` (`oa_project_id`) USING BTREE,
  KEY `oa_project_record_user_id` (`user_id`) USING BTREE,
  KEY `oa_project_record_read_flag` (`read_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='项目参与人员';

/*Table structure for table `oa_task` */

DROP TABLE IF EXISTS `oa_task`;

CREATE TABLE `oa_task` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '任务编号',
  `name` varchar(50) NOT NULL COMMENT '任务名称',
  `relation_type` varchar(30) DEFAULT NULL COMMENT '任务类型',
  `relation_id` varchar(30) DEFAULT NULL COMMENT '关联ID',
  `relation_name` varchar(50) DEFAULT NULL COMMENT '关联名称',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL COMMENT '截止日期',
  `level_type` char(1) DEFAULT NULL COMMENT '优先级',
  `schedule` int(11) DEFAULT NULL COMMENT '进度',
  `content` text COMMENT '任务描述',
  `files` varchar(2000) DEFAULT NULL COMMENT '附件',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `status` char(1) DEFAULT '0' COMMENT '任务状态',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `office_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oa_notify_del_flag` (`del_flag`),
  KEY `oa_notify_create_by` (`create_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务';

/*Table structure for table `oa_task_record` */

DROP TABLE IF EXISTS `oa_task_record`;

CREATE TABLE `oa_task_record` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `oa_task_id` varchar(64) DEFAULT NULL COMMENT '任务ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` datetime DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  KEY `oa_notify_record_notify_id` (`oa_task_id`),
  KEY `oa_notify_record_user_id` (`user_id`),
  KEY `oa_notify_record_read_flag` (`read_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务参与人员';

/*Table structure for table `oa_test_audit` */

DROP TABLE IF EXISTS `oa_test_audit`;

CREATE TABLE `oa_test_audit` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `PROC_INS_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '流程实例ID',
  `USER_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '变动用户',
  `OFFICE_ID` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '归属部门',
  `POST` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '岗位',
  `AGE` char(1) COLLATE utf8_bin DEFAULT NULL COMMENT '性别',
  `EDU` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '学历',
  `CONTENT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '调整原因',
  `OLDA` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '现行标准 薪酬档级',
  `OLDB` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '现行标准 月工资额',
  `OLDC` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '现行标准 年薪总额',
  `NEWA` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '调整后标准 薪酬档级',
  `NEWB` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '调整后标准 月工资额',
  `NEWC` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '调整后标准 年薪总额',
  `ADD_NUM` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '月增资',
  `EXE_DATE` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '执行时间',
  `HR_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '人力资源部门意见',
  `LEAD_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '分管领导意见',
  `MAIN_LEAD_TEXT` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '集团主要领导意见',
  `create_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `OA_TEST_AUDIT_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='审批流程测试表';

/*Table structure for table `oa_topic` */

DROP TABLE IF EXISTS `oa_topic`;

CREATE TABLE `oa_topic` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` varchar(10000) DEFAULT NULL COMMENT '内容',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oa_notify_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='话题';

/*Table structure for table `oa_topic_record` */

DROP TABLE IF EXISTS `oa_topic_record`;

CREATE TABLE `oa_topic_record` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `oa_topic_id` varchar(30) DEFAULT NULL COMMENT '话题ID',
  `user_id` varchar(30) DEFAULT NULL COMMENT ' 回复人',
  `notes` varchar(500) DEFAULT NULL COMMENT ' 回复内容',
  `create_date` datetime DEFAULT NULL COMMENT ' 回复时间',
  `thumbs` int(11) DEFAULT NULL COMMENT '点赞数',
  PRIMARY KEY (`id`),
  KEY `oa_notify_record_notify_id` (`oa_topic_id`),
  KEY `oa_notify_record_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='话题';

/*Table structure for table `oa_work_log` */

DROP TABLE IF EXISTS `oa_work_log`;

CREATE TABLE `oa_work_log` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `work_log_type` char(2) DEFAULT NULL COMMENT '类型',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` varchar(1000) DEFAULT NULL COMMENT '内容',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '批阅人',
  `status` char(1) DEFAULT NULL COMMENT '批阅状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oa_notify_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工作报告';

/*Table structure for table `oa_work_log_record` */

DROP TABLE IF EXISTS `oa_work_log_record`;

CREATE TABLE `oa_work_log_record` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `oa_work_log_id` varchar(30) DEFAULT NULL COMMENT '工作报告ID',
  `user_id` varchar(30) DEFAULT NULL COMMENT '查阅人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` datetime DEFAULT NULL COMMENT '阅读时间',
  `audit_notes` varchar(50) DEFAULT NULL COMMENT '评论',
  PRIMARY KEY (`id`),
  KEY `oa_notify_record_notify_id` (`oa_work_log_id`),
  KEY `oa_notify_record_user_id` (`user_id`),
  KEY `oa_notify_record_read_flag` (`read_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工作报告查阅记录';

/*Table structure for table `oa_work_log_rule` */

DROP TABLE IF EXISTS `oa_work_log_rule`;

CREATE TABLE `oa_work_log_rule` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `user_id` varchar(30) DEFAULT NULL COMMENT '查阅人',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='汇报规则';

/*Table structure for table `om_contract` */

DROP TABLE IF EXISTS `om_contract`;

CREATE TABLE `om_contract` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '合同编号',
  `name` varchar(50) DEFAULT NULL COMMENT '主题',
  `order_id` varchar(30) DEFAULT NULL COMMENT '销售订单',
  `quote_id` varchar(30) DEFAULT NULL COMMENT '报价单',
  `chance_id` varchar(30) DEFAULT NULL COMMENT '机会',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '总金额',
  `deal_date` date DEFAULT NULL COMMENT '签约日期',
  `deliver_date` date DEFAULT NULL COMMENT '交付时间',
  `start_date` date DEFAULT NULL COMMENT '生效时间',
  `end_date` date DEFAULT NULL COMMENT '到期时间',
  `own_by` varchar(30) DEFAULT NULL COMMENT '销售负责人',
  `notes` text COMMENT '正文',
  `files` varchar(2000) DEFAULT NULL COMMENT '附件',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '审核时间',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  `office_id` varchar(30) DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`),
  KEY `index_order_customer_id` (`customer_id`) USING BTREE,
  KEY `index_order_del_flag` (`del_flag`) USING BTREE,
  KEY `index_order_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售合同';

/*Table structure for table `om_order` */

DROP TABLE IF EXISTS `om_order`;

CREATE TABLE `om_order` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `sale_type` char(1) DEFAULT NULL COMMENT '销售类型',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `content` varchar(50) DEFAULT NULL COMMENT '内容',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `total_amt` decimal(12,2) DEFAULT NULL COMMENT '合计',
  `tax_amt` decimal(12,2) DEFAULT NULL COMMENT '税额',
  `other_amt` decimal(12,2) DEFAULT NULL COMMENT '其他费用',
  `amount` decimal(12,2) NOT NULL COMMENT '总计金额',
  `fi_account_id` varchar(30) DEFAULT NULL COMMENT '结算账户',
  `book_amt` decimal(12,2) DEFAULT '0.00' COMMENT '订金',
  `receive_amt` decimal(12,2) DEFAULT '0.00' COMMENT '回款金额',
  `is_invoice` char(1) DEFAULT NULL COMMENT '是否开票',
  `invoice_amt` decimal(12,2) DEFAULT '0.00' COMMENT '开票金额',
  `profit_amt` decimal(12,2) DEFAULT '0.00' COMMENT '毛利润',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchase_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售订单';

/*Table structure for table `om_order_detail` */

DROP TABLE IF EXISTS `om_order_detail`;

CREATE TABLE `om_order_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `order_id` varchar(30) DEFAULT NULL COMMENT '所属销售订单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `price` decimal(12,2) DEFAULT NULL COMMENT '单价(元)',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '金额(元)',
  `tax_rate` decimal(12,2) DEFAULT NULL COMMENT '税率',
  `tax_amt` decimal(12,2) DEFAULT NULL COMMENT '税额',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售订单明细';

/*Table structure for table `om_returnorder` */

DROP TABLE IF EXISTS `om_returnorder`;

CREATE TABLE `om_returnorder` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `sale_type` char(1) DEFAULT NULL COMMENT '销售类型',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `order_id` varchar(30) DEFAULT NULL COMMENT '关联销售订单',
  `warehouse_id` varchar(30) DEFAULT NULL COMMENT '入库仓库',
  `content` varchar(50) DEFAULT NULL COMMENT '内容',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `total_amt` decimal(12,2) DEFAULT NULL COMMENT '合计',
  `tax_amt` decimal(12,2) DEFAULT NULL COMMENT '税额',
  `other_amt` decimal(12,2) DEFAULT NULL COMMENT '其他费用',
  `amount` decimal(12,2) NOT NULL COMMENT '总计金额',
  `actual_amt` decimal(12,2) DEFAULT NULL COMMENT '实退金额',
  `fi_account_id` varchar(30) DEFAULT NULL COMMENT '结算账户',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchase_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售退货单';

/*Table structure for table `om_returnorder_detail` */

DROP TABLE IF EXISTS `om_returnorder_detail`;

CREATE TABLE `om_returnorder_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `returnorder_id` varchar(30) DEFAULT NULL COMMENT '所属退货单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `price` decimal(12,2) DEFAULT NULL COMMENT '单价(元)',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '金额(元)',
  `tax_rate` decimal(12,2) DEFAULT NULL COMMENT '税率',
  `tax_amt` decimal(12,2) DEFAULT NULL COMMENT '税额',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`returnorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售退货单明细';

/*Table structure for table `pay_alipay_log` */

DROP TABLE IF EXISTS `pay_alipay_log`;

CREATE TABLE `pay_alipay_log` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `appid` varchar(50) DEFAULT NULL COMMENT '开发者应用ID',
  `seller_id` varchar(50) DEFAULT NULL COMMENT '卖家支付宝用户号',
  `trade_no` varchar(50) DEFAULT NULL COMMENT '支付宝交易号',
  `out_trade_no` varchar(50) DEFAULT NULL COMMENT '商户订单号',
  `trade_status` varchar(50) DEFAULT NULL COMMENT '交易状态',
  `sign` varchar(50) DEFAULT NULL COMMENT '签名',
  `sign_type` varchar(50) DEFAULT NULL COMMENT '签名类型',
  `trade_type` varchar(30) DEFAULT NULL COMMENT '交易类型',
  `bank_type` varchar(50) DEFAULT NULL COMMENT '付款银行',
  `total_amount` decimal(12,2) DEFAULT NULL COMMENT '订单金额',
  `buyer_pay_amount` decimal(12,2) DEFAULT NULL COMMENT '付款金额',
  `receipt_amount` decimal(12,2) DEFAULT NULL COMMENT '实收金额',
  `gmt_payment` varchar(50) DEFAULT NULL COMMENT '交易付款时间',
  `buyer_id` varchar(50) DEFAULT NULL COMMENT '支付宝支付账号',
  `out_biz_no` varchar(50) DEFAULT NULL COMMENT '商户业务号',
  `refund_fee` decimal(12,2) DEFAULT NULL COMMENT '退款金额',
  `gmt_refund` varchar(50) DEFAULT NULL COMMENT '交易退款时间',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付宝支付通知';

/*Table structure for table `pay_bankbook_balance` */

DROP TABLE IF EXISTS `pay_bankbook_balance`;

CREATE TABLE `pay_bankbook_balance` (
  `id` varchar(30) NOT NULL COMMENT 'ID ',
  `balance` decimal(12,2) DEFAULT '0.00' COMMENT '余额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='电子钱包余额';

/*Table structure for table `pay_bankbook_journal` */

DROP TABLE IF EXISTS `pay_bankbook_journal`;

CREATE TABLE `pay_bankbook_journal` (
  `id` varchar(30) NOT NULL COMMENT 'ID ',
  `account_id` varchar(30) DEFAULT NULL COMMENT '账号ID',
  `deal_date` datetime DEFAULT NULL COMMENT '交易日期',
  `deal_type` char(1) DEFAULT NULL COMMENT '交易类型',
  `money` decimal(12,2) DEFAULT NULL COMMENT '交易金额',
  `money_type` char(2) DEFAULT NULL COMMENT '资金类别',
  `balance` decimal(12,2) DEFAULT NULL COMMENT '当前余额',
  `remarks` varchar(50) DEFAULT NULL COMMENT '摘要',
  `unique_code` varchar(50) DEFAULT NULL COMMENT '唯一码',
  `create_by` varchar(50) DEFAULT NULL COMMENT '操作人',
  `create_date` datetime DEFAULT NULL COMMENT '操作日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='电子钱包交易明细';

/*Table structure for table `pay_book_order` */

DROP TABLE IF EXISTS `pay_book_order`;

CREATE TABLE `pay_book_order` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(50) DEFAULT NULL COMMENT '订单编号',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '订单金额',
  `product_id` varchar(30) DEFAULT NULL COMMENT '产品名称',
  `mobile` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `name` varchar(30) DEFAULT NULL COMMENT '姓名',
  `company` varchar(50) DEFAULT NULL COMMENT '公司名称',
  `scale_type` char(1) DEFAULT NULL COMMENT '企业规模',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮箱',
  `qq` varchar(50) DEFAULT NULL COMMENT 'QQ',
  `notes` varchar(50) DEFAULT NULL COMMENT '留言',
  `status` char(1) DEFAULT NULL COMMENT '支付状态',
  `pay_type` char(1) DEFAULT NULL COMMENT '支付类型(0：微信，1：支付宝)',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预定订单';

/*Table structure for table `pay_recharge_order` */

DROP TABLE IF EXISTS `pay_recharge_order`;

CREATE TABLE `pay_recharge_order` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(50) DEFAULT NULL COMMENT '订单编号',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '订单金额',
  `notes` varchar(50) DEFAULT NULL,
  `status` char(1) DEFAULT NULL COMMENT '支付状态',
  `pay_type` char(1) DEFAULT NULL COMMENT '支付类型(0：微信，1：支付宝)',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值订单';

/*Table structure for table `pay_wxpay_log` */

DROP TABLE IF EXISTS `pay_wxpay_log`;

CREATE TABLE `pay_wxpay_log` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `appid` varchar(50) DEFAULT NULL COMMENT '公众账号',
  `mch_id` varchar(50) DEFAULT NULL COMMENT '商户号',
  `sign` varchar(50) DEFAULT NULL COMMENT ' 签名',
  `sign_type` varchar(50) DEFAULT NULL COMMENT '签名类型',
  `result_code` varchar(50) DEFAULT NULL COMMENT '业务结果',
  `err_code` varchar(50) DEFAULT NULL COMMENT '错误代码',
  `trade_type` varchar(30) DEFAULT NULL COMMENT '交易类型',
  `bank_type` varchar(50) DEFAULT NULL COMMENT '付款银行',
  `openid` varchar(50) DEFAULT NULL COMMENT '用户标识',
  `total_fee` decimal(12,2) DEFAULT NULL COMMENT '订单金额',
  `cash_fee` decimal(12,2) DEFAULT NULL COMMENT '现金支付金额',
  `transaction_id` varchar(50) DEFAULT NULL COMMENT '微信支付订单号',
  `out_trade_no` varchar(50) DEFAULT NULL COMMENT '商户订单号',
  `time_end` varchar(50) DEFAULT NULL COMMENT '支付完成时间',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信支付通知';

/*Table structure for table `qws_msg_notice` */

DROP TABLE IF EXISTS `qws_msg_notice`;

CREATE TABLE `qws_msg_notice` (
  `id` varchar(32) NOT NULL,
  `msg_signature` varchar(255) DEFAULT NULL COMMENT '消息签名',
  `timestamp` varchar(255) DEFAULT NULL COMMENT '时间戳',
  `nonce` varchar(255) DEFAULT NULL COMMENT '随机数',
  `echostr` varchar(255) DEFAULT NULL COMMENT '加密的字符串',
  `requestBody` varchar(5000) DEFAULT NULL COMMENT '消息主体',
  `create_date` datetime DEFAULT NULL COMMENT '接收时间',
  `status` char(1) DEFAULT '0' COMMENT '处理状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据回调消息';

/*Table structure for table `qws_suite_notice` */

DROP TABLE IF EXISTS `qws_suite_notice`;

CREATE TABLE `qws_suite_notice` (
  `id` varchar(32) NOT NULL,
  `request_url` varchar(1000) DEFAULT NULL COMMENT '请求URL',
  `request_body` varchar(5000) DEFAULT NULL COMMENT '消息主体',
  `msg_signature` varchar(512) DEFAULT NULL COMMENT '消息签名',
  `timestamp` varchar(50) DEFAULT NULL COMMENT '时间戳',
  `nonce` varchar(50) DEFAULT NULL COMMENT '随机数',
  `echostr` varchar(512) DEFAULT NULL COMMENT '加密字符串',
  `suite_id` varchar(50) DEFAULT NULL COMMENT '第三方应用的SuiteId',
  `info_type` varchar(50) DEFAULT NULL COMMENT '消息类型',
  `suite_ticket` varchar(512) DEFAULT NULL COMMENT 'suite_ticket',
  `auth_code` varchar(512) DEFAULT NULL COMMENT '临时授权码',
  `auth_corp_id` varchar(50) DEFAULT NULL COMMENT '授权方的corpid',
  `change_type` varchar(50) DEFAULT NULL COMMENT '通讯录变更类型',
  `user_id` varchar(50) DEFAULT NULL COMMENT '成员ID',
  `party_id` varchar(50) DEFAULT NULL COMMENT '部门ID',
  `create_date` datetime DEFAULT NULL COMMENT '接收时间',
  `status` char(1) DEFAULT '0' COMMENT '处理状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='指令回调消息';

/*Table structure for table `scm_care` */

DROP TABLE IF EXISTS `scm_care`;

CREATE TABLE `scm_care` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) DEFAULT NULL COMMENT '主题',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户名称',
  `contacter_name` varchar(30) DEFAULT NULL COMMENT '联系人',
  `care_type` varchar(2) DEFAULT NULL COMMENT '关怀类型',
  `care_date` datetime DEFAULT NULL COMMENT '关怀日期',
  `care_note` varchar(200) DEFAULT NULL COMMENT '关怀内容',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `create_by` varchar(30) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  PRIMARY KEY (`id`),
  KEY `index_care_create_by` (`create_by`) USING BTREE,
  KEY `index_care_customer_id` (`customer_id`) USING BTREE,
  KEY `index_care_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户关怀';

/*Table structure for table `scm_complaint` */

DROP TABLE IF EXISTS `scm_complaint`;

CREATE TABLE `scm_complaint` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) NOT NULL COMMENT '主题',
  `order_id` varchar(30) DEFAULT NULL COMMENT '订单合同',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `level_type` char(1) DEFAULT NULL COMMENT '优先级',
  `end_date` date DEFAULT NULL COMMENT '截止日期',
  `expecte` varchar(200) DEFAULT NULL COMMENT '期望结果',
  `content` varchar(10000) DEFAULT NULL COMMENT '内容',
  `status` char(1) DEFAULT NULL COMMENT '处理状态',
  `deal_date` date DEFAULT NULL COMMENT '处理日期',
  `satisfy_type` char(1) DEFAULT NULL COMMENT '满意度',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` date DEFAULT NULL COMMENT '审核日期',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新人',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账号',
  PRIMARY KEY (`id`),
  KEY `crm_workorder_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户投诉';

/*Table structure for table `scm_problem` */

DROP TABLE IF EXISTS `scm_problem`;

CREATE TABLE `scm_problem` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `problem_type_id` varchar(30) DEFAULT NULL,
  `name` varchar(50) NOT NULL COMMENT '问题名称',
  `content` varchar(10000) DEFAULT NULL COMMENT '内容',
  `status` char(1) DEFAULT NULL COMMENT '处理状态',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新人',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账号',
  PRIMARY KEY (`id`),
  KEY `crm_workorder_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='常见问题';

/*Table structure for table `scm_problem_type` */

DROP TABLE IF EXISTS `scm_problem_type`;

CREATE TABLE `scm_problem_type` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protype_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='常见问题分类';

/*Table structure for table `scm_suppot` */

DROP TABLE IF EXISTS `scm_suppot`;

CREATE TABLE `scm_suppot` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) NOT NULL COMMENT '主题',
  `order_id` varchar(30) DEFAULT NULL COMMENT '订单合同',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '客户',
  `own_by` varchar(30) DEFAULT NULL COMMENT '负责人',
  `level_type` char(1) DEFAULT NULL COMMENT '优先级',
  `end_date` date DEFAULT NULL COMMENT '截止日期',
  `expecte` varchar(200) DEFAULT NULL COMMENT '期望结果',
  `content` varchar(10000) DEFAULT NULL COMMENT '内容',
  `status` char(1) DEFAULT NULL COMMENT '处理状态',
  `deal_date` date DEFAULT NULL COMMENT '处理日期',
  `satisfy_type` char(1) DEFAULT NULL COMMENT '满意度',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` date DEFAULT NULL COMMENT '审核日期',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新人',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业账号',
  PRIMARY KEY (`id`),
  KEY `crm_workorder_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户服务';

/*Table structure for table `sys_account` */

DROP TABLE IF EXISTS `sys_account`;

CREATE TABLE `sys_account` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(30) DEFAULT NULL COMMENT '公司名称',
  `mobile` varchar(20) DEFAULT NULL COMMENT '手机',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `email` varchar(30) DEFAULT NULL COMMENT '邮箱',
  `fax` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `enname` varchar(50) DEFAULT NULL COMMENT '英文名',
  `logo` varchar(200) DEFAULT NULL,
  `neturl` varchar(50) DEFAULT NULL,
  `bankaccountname` varchar(50) DEFAULT NULL,
  `bankaccountno` varchar(50) DEFAULT NULL,
  `admin_user_id` varchar(30) DEFAULT NULL COMMENT '管理员账号',
  `max_user_num` int(11) DEFAULT NULL COMMENT '授权用户数',
  `now_user_num` int(11) DEFAULT NULL COMMENT '当前用户数',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `system_name` varchar(30) DEFAULT NULL COMMENT '系统名称',
  `api_secret` varchar(64) DEFAULT NULL,
  `sms_status` char(1) DEFAULT '0' COMMENT '开通短信提醒功能 0 否，1是',
  `pay_status` char(1) DEFAULT '0' COMMENT '付费状态: 1 欠费，0正常',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(250) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `permanent_code` varchar(512) DEFAULT NULL COMMENT '企业微信永久授权码',
  `userid` varchar(50) DEFAULT NULL COMMENT '授权管理员的userid',
  `corpid` varchar(50) DEFAULT NULL COMMENT '企业微信id',
  `corp_name` varchar(50) DEFAULT NULL COMMENT '企业微信名称',
  `corp_type` varchar(50) DEFAULT NULL COMMENT '企业微信类型',
  `corp_wxqrcode` varchar(255) DEFAULT NULL COMMENT '授权方企业微信二维码',
  `corp_scale` varchar(50) DEFAULT NULL COMMENT '企业规模',
  `corp_industry` varchar(50) DEFAULT NULL COMMENT '企业所属行业',
  `agentid` varchar(50) DEFAULT NULL COMMENT '授权方应用id',
  `crm_retrieve_period` int(11) DEFAULT '30' COMMENT '客户池回收周期',
  `crm_contact_remind_period` int(11) DEFAULT '7' COMMENT '客户提醒周期',
  PRIMARY KEY (`id`),
  KEY `oa_leave_process_instance_id` (`phone`),
  KEY `oa_leave_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业帐号';

/*Table structure for table `sys_area` */

DROP TABLE IF EXISTS `sys_area`;

CREATE TABLE `sys_area` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) DEFAULT NULL COMMENT '上级区域ID',
  `parent_ids` varchar(2000) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL COMMENT '区域名称',
  `sort` decimal(10,0) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `type` varchar(11) DEFAULT NULL COMMENT '区域类型',
  `del_flag` char(1) DEFAULT NULL COMMENT '有效标识',
  `create_by` varchar(64) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `account_id` varchar(64) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='行政区域表';

/*Table structure for table `sys_browse_log` */

DROP TABLE IF EXISTS `sys_browse_log`;

CREATE TABLE `sys_browse_log` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `target_type` varchar(2) DEFAULT NULL COMMENT '目标类型',
  `target_id` varchar(30) DEFAULT NULL COMMENT '目标ID',
  `target_name` varchar(50) DEFAULT NULL COMMENT '目标名称',
  `user_id` varchar(30) NOT NULL COMMENT '浏览者',
  `browse_date` datetime NOT NULL COMMENT '最新浏览时间',
  PRIMARY KEY (`id`),
  KEY `oa_leave_create_by` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='足迹';

/*Table structure for table `sys_config` */

DROP TABLE IF EXISTS `sys_config`;

CREATE TABLE `sys_config` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `mail_smtp` varchar(50) DEFAULT NULL COMMENT '邮箱服务器地址',
  `mail_port` varchar(50) DEFAULT NULL COMMENT '邮箱服务器端口',
  `mail_name` varchar(50) DEFAULT NULL COMMENT '系统邮箱地址',
  `mail_password` varchar(50) DEFAULT NULL COMMENT '系统邮箱密码',
  `sms_name` varchar(50) DEFAULT NULL COMMENT '短信用户名',
  `sms_password` varchar(50) DEFAULT NULL COMMENT '短信密码',
  `account_id` varchar(30) DEFAULT NULL,
  `wx_agentid` int(11) DEFAULT NULL COMMENT '企业应用的id',
  `wx_corpid` varchar(50) DEFAULT NULL COMMENT '企业微信企业ID',
  `wx_corpsecret` varchar(50) DEFAULT NULL COMMENT '企业微信管理组的凭证密钥 ',
  `wx_access_token` varchar(512) DEFAULT NULL COMMENT '企业微信获取到的凭证',
  `wx_expires_in` int(50) DEFAULT NULL COMMENT '企业微信凭证的有效时间（秒）',
  `wx_token_date` datetime DEFAULT NULL COMMENT 'token更新时间',
  `wx_status` char(1) DEFAULT '0' COMMENT '企业微信状态',
  `checkin_secret` varchar(100) DEFAULT NULL COMMENT '打卡应用的Secret',
  `approval_secret` varchar(100) DEFAULT NULL COMMENT '审批应用的Secret',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='系统配置';

/*Table structure for table `sys_dict` */

DROP TABLE IF EXISTS `sys_dict`;

CREATE TABLE `sys_dict` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `value` varchar(100) NOT NULL COMMENT '数据值',
  `label` varchar(100) NOT NULL COMMENT '标签名',
  `type` varchar(100) NOT NULL COMMENT '类型',
  `description` varchar(100) NOT NULL COMMENT '描述',
  `sort` decimal(10,0) NOT NULL COMMENT '排序（升序）',
  `parent_id` varchar(64) DEFAULT '0' COMMENT '父级编号',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_dict_value` (`value`),
  KEY `sys_dict_label` (`label`),
  KEY `sys_dict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

/*Table structure for table `sys_dynamic` */

DROP TABLE IF EXISTS `sys_dynamic`;

CREATE TABLE `sys_dynamic` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `object_type` varchar(2) DEFAULT NULL COMMENT '对象类型',
  `action_type` varchar(2) DEFAULT NULL COMMENT '动作类型',
  `target_id` varchar(30) DEFAULT NULL COMMENT '对象ID',
  `target_name` varchar(50) DEFAULT NULL COMMENT '对象名称',
  `create_by` varchar(30) NOT NULL COMMENT '操作人',
  `create_date` datetime NOT NULL COMMENT '操作时间',
  `customer_id` varchar(30) DEFAULT NULL COMMENT '关联客户',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐套',
  `office_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dyamic_account_id` (`account_id`),
  KEY `index_dyamic_create_by` (`create_by`) USING BTREE,
  KEY `index_dyamic_target_id` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='动态表';

/*Table structure for table `sys_join` */

DROP TABLE IF EXISTS `sys_join`;

CREATE TABLE `sys_join` (
  `id` varchar(30) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL COMMENT '手机号码',
  `name` varchar(30) DEFAULT NULL COMMENT '真实姓名',
  `user_id` varchar(30) DEFAULT NULL COMMENT '邀请人',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业编号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_log` */

DROP TABLE IF EXISTS `sys_log`;

CREATE TABLE `sys_log` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(2) DEFAULT '1' COMMENT '日志类型',
  `title` varchar(255) DEFAULT '' COMMENT '日志标题',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `remote_addr` varchar(255) DEFAULT NULL COMMENT '操作IP地址',
  `user_agent` varchar(255) DEFAULT NULL COMMENT '用户代理',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '请求URI',
  `method` varchar(5) DEFAULT NULL COMMENT '操作方式',
  `params` text COMMENT '操作提交的数据',
  `exception` text COMMENT '异常信息',
  `account_id` varchar(32) DEFAULT NULL,
  `data_type` char(1) DEFAULT '0' COMMENT '数据类型',
  PRIMARY KEY (`id`),
  KEY `sys_log_create_by` (`create_by`),
  KEY `sys_log_request_uri` (`request_uri`),
  KEY `sys_log_type` (`type`),
  KEY `sys_log_create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日志表';

/*Table structure for table `sys_mdict` */

DROP TABLE IF EXISTS `sys_mdict`;

CREATE TABLE `sys_mdict` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_mdict_parent_id` (`parent_id`),
  KEY `sys_mdict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='多级字典表';

/*Table structure for table `sys_menu` */

DROP TABLE IF EXISTS `sys_menu`;

CREATE TABLE `sys_menu` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `href` varchar(2000) DEFAULT NULL COMMENT '链接',
  `target` varchar(20) DEFAULT NULL COMMENT '目标',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `is_show` char(1) NOT NULL COMMENT '是否在菜单中显示',
  `permission` varchar(200) DEFAULT NULL COMMENT '权限标识',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_menu_parent_id` (`parent_id`),
  KEY `sys_menu_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单表';

/*Table structure for table `sys_office` */

DROP TABLE IF EXISTS `sys_office`;

CREATE TABLE `sys_office` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `code` varchar(100) DEFAULT NULL COMMENT '区域编码',
  `type` char(1) NOT NULL COMMENT '机构类型',
  `grade` char(1) NOT NULL COMMENT '机构等级',
  `primary_person` varchar(64) DEFAULT NULL COMMENT '主负责人',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `sys_office_parent_id` (`parent_id`),
  KEY `sys_office_del_flag` (`del_flag`),
  KEY `sys_office_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构表';

/*Table structure for table `sys_panel` */

DROP TABLE IF EXISTS `sys_panel`;

CREATE TABLE `sys_panel` (
  `id` varchar(30) NOT NULL COMMENT 'ID',
  `panel_id` char(2) DEFAULT NULL COMMENT '面板ID',
  `user_id` varchar(30) DEFAULT NULL COMMENT '用户ID',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sys_panel_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='面板设置';

/*Table structure for table `sys_role` */

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `office_id` varchar(64) DEFAULT NULL COMMENT '归属机构',
  `name` varchar(100) NOT NULL COMMENT '角色名称',
  `enname` varchar(255) DEFAULT NULL COMMENT '英文名称',
  `role_type` varchar(255) DEFAULT NULL COMMENT '角色类型',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围',
  `is_sys` varchar(64) DEFAULT NULL COMMENT '是否系统数据',
  `useable` varchar(64) DEFAULT NULL COMMENT '是否可用',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `sys_role_del_flag` (`del_flag`),
  KEY `sys_role_enname` (`enname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Table structure for table `sys_role_menu` */

DROP TABLE IF EXISTS `sys_role_menu`;

CREATE TABLE `sys_role_menu` (
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  `menu_id` varchar(64) NOT NULL COMMENT '菜单编号',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-菜单';

/*Table structure for table `sys_role_office` */

DROP TABLE IF EXISTS `sys_role_office`;

CREATE TABLE `sys_role_office` (
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  `office_id` varchar(64) NOT NULL COMMENT '机构编号',
  PRIMARY KEY (`role_id`,`office_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-机构';

/*Table structure for table `sys_sms` */

DROP TABLE IF EXISTS `sys_sms`;

CREATE TABLE `sys_sms` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `sms_type` char(5) DEFAULT NULL COMMENT '短信类型',
  `content` varchar(100) DEFAULT NULL COMMENT '短信内容',
  `mobile` varchar(11) DEFAULT NULL COMMENT '接收手机号码',
  `code` varchar(10) DEFAULT NULL COMMENT '验证码',
  `ip` varchar(20) DEFAULT NULL COMMENT '客户端IP',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信下发表';

/*Table structure for table `sys_user` */

DROP TABLE IF EXISTS `sys_user`;

CREATE TABLE `sys_user` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `company_id` varchar(64) DEFAULT NULL COMMENT '归属公司',
  `office_id` varchar(64) DEFAULT NULL COMMENT '归属部门',
  `login_name` varchar(100) DEFAULT NULL COMMENT '登录名',
  `password` varchar(100) DEFAULT NULL COMMENT '密码',
  `no` varchar(100) DEFAULT NULL COMMENT '工号',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `sex` char(1) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(50) DEFAULT NULL COMMENT '电话',
  `mobile` varchar(50) DEFAULT NULL COMMENT '手机',
  `job` varchar(50) DEFAULT NULL,
  `user_type` char(1) DEFAULT NULL COMMENT '用户类型',
  `data_scope` char(1) DEFAULT '8' COMMENT '数据范围',
  `photo` varchar(1000) DEFAULT NULL COMMENT '用户头像',
  `login_ip` varchar(100) DEFAULT NULL COMMENT '最后登陆IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登陆时间',
  `login_flag` varchar(64) DEFAULT NULL COMMENT '是否可登录',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `qrcode` varchar(1000) DEFAULT NULL COMMENT '二维码',
  `sign` varchar(450) DEFAULT NULL COMMENT '个性签名',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `bind_wx` char(1) DEFAULT '0' COMMENT '绑定企业微信',
  `user_id` varchar(64) DEFAULT NULL COMMENT '成员UserID。对应管理端的帐号，企业内必须唯一。不区分大小写，长度为1~64个字节',
  `token` varchar(100) DEFAULT NULL COMMENT 'token',
  PRIMARY KEY (`id`),
  KEY `sys_user_office_id` (`office_id`),
  KEY `sys_user_login_name` (`login_name`),
  KEY `sys_user_company_id` (`company_id`),
  KEY `sys_user_update_date` (`update_date`),
  KEY `sys_user_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Table structure for table `sys_user_friend` */

DROP TABLE IF EXISTS `sys_user_friend`;

CREATE TABLE `sys_user_friend` (
  `id` varchar(64) NOT NULL,
  `userId` varchar(64) NOT NULL,
  `friendId` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `sys_user_role` */

DROP TABLE IF EXISTS `sys_user_role`;

CREATE TABLE `sys_user_role` (
  `user_id` varchar(64) NOT NULL COMMENT '用户编号',
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-角色';

/*Table structure for table `systemconfig` */

DROP TABLE IF EXISTS `systemconfig`;

CREATE TABLE `systemconfig` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `smtp` varchar(64) DEFAULT NULL COMMENT '邮箱服务器地址',
  `port` varchar(64) DEFAULT NULL COMMENT '邮箱服务器端口',
  `mailname` varchar(64) DEFAULT NULL COMMENT '系统邮箱地址',
  `mailpassword` varchar(64) DEFAULT NULL COMMENT '系统邮箱密码',
  `smsname` varchar(64) DEFAULT NULL COMMENT '短信用户名',
  `smspassword` varchar(64) DEFAULT NULL COMMENT '短信密码',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='系统配置';

/*Table structure for table `t_test` */

DROP TABLE IF EXISTS `t_test`;

CREATE TABLE `t_test` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(30) DEFAULT NULL COMMENT '名称',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单';

/*Table structure for table `t_tree` */

DROP TABLE IF EXISTS `t_tree`;

CREATE TABLE `t_tree` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_protype_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='树结构(商品分类)';

/*Table structure for table `test_data` */

DROP TABLE IF EXISTS `test_data`;

CREATE TABLE `test_data` (
  `id` varchar(32) NOT NULL COMMENT '编号',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `sex` char(1) DEFAULT NULL COMMENT '性别',
  `age` int(3) DEFAULT NULL COMMENT '年龄',
  `mobile` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮箱',
  `address` varchar(50) DEFAULT NULL COMMENT '联系地址',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_name` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_name` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `test_data_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务数据表';

/*Table structure for table `test_data_child` */

DROP TABLE IF EXISTS `test_data_child`;

CREATE TABLE `test_data_child` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `order_id` varchar(30) DEFAULT NULL COMMENT '所属销售订单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `price` decimal(12,2) DEFAULT NULL COMMENT '单价(元)',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '金额(元)',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单明细(一对多子表)';

/*Table structure for table `test_data_main` */

DROP TABLE IF EXISTS `test_data_main`;

CREATE TABLE `test_data_main` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `sale_type` char(1) DEFAULT NULL COMMENT '销售类型',
  `amount` decimal(12,2) NOT NULL COMMENT '总计金额',
  `invoice_amt` decimal(12,2) DEFAULT '0.00' COMMENT '开票金额',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单(一对多)';

/*Table structure for table `test_interface` */

DROP TABLE IF EXISTS `test_interface`;

CREATE TABLE `test_interface` (
  `id` varchar(30) NOT NULL DEFAULT '' COMMENT '主键',
  `type` varchar(16) DEFAULT NULL COMMENT '接口类型',
  `url` varchar(300) DEFAULT NULL COMMENT '请求URL',
  `body` varchar(1000) DEFAULT NULL COMMENT '请求body',
  `successmsg` varchar(512) DEFAULT NULL COMMENT '成功时返回消息',
  `errormsg` varchar(512) DEFAULT NULL COMMENT '失败时返回消息',
  `contents` varchar(10000) DEFAULT NULL COMMENT '接口说明',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) CHARACTER SET latin1 DEFAULT '0' COMMENT '删除标记',
  `name` varchar(100) DEFAULT NULL COMMENT '接口名称',
  `account_id` varchar(30) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口列表';

/*Table structure for table `test_line_weather_main_city` */

DROP TABLE IF EXISTS `test_line_weather_main_city`;

CREATE TABLE `test_line_weather_main_city` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `datestr` datetime DEFAULT NULL COMMENT '日期',
  `beijing_maxtemp` double DEFAULT NULL COMMENT '北京最高气温',
  `beijing_mintemp` double DEFAULT NULL COMMENT '北京最低气温',
  `changchun_maxtemp` double DEFAULT NULL COMMENT '长春最高气温',
  `changchun_mintemp` double DEFAULT NULL COMMENT '长春最低气温',
  `shenyang_maxtemp` double DEFAULT NULL COMMENT '沈阳最高气温',
  `shenyang_mintemp` double DEFAULT NULL COMMENT '沈阳最低气温',
  `haerbin_maxtemp` double DEFAULT NULL COMMENT '哈尔滨最高气温',
  `haerbin_mintemp` double DEFAULT NULL COMMENT '哈尔滨最低气温',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='城市气温';

/*Table structure for table `test_note` */

DROP TABLE IF EXISTS `test_note`;

CREATE TABLE `test_note` (
  `id` varchar(30) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `title` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '标题',
  `contents` longblob COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='富文本测试';

/*Table structure for table `test_one` */

DROP TABLE IF EXISTS `test_one`;

CREATE TABLE `test_one` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) NOT NULL COMMENT '商品编码',
  `name` varchar(50) NOT NULL COMMENT '商品名称',
  `product_type_id` varchar(30) DEFAULT NULL COMMENT '商品分类',
  `unit_type` char(2) DEFAULT NULL COMMENT '基本单位',
  `spec` varchar(30) DEFAULT NULL COMMENT '规格',
  `color` varchar(30) DEFAULT NULL COMMENT '颜色',
  `size` varchar(30) DEFAULT NULL COMMENT '尺寸',
  `product_img` varchar(500) DEFAULT NULL COMMENT '商品图片',
  `sale_price` decimal(12,2) DEFAULT NULL COMMENT '零售价',
  `batch_price` decimal(12,2) DEFAULT NULL COMMENT '批发价',
  `content` varchar(10000) DEFAULT NULL COMMENT '商品描述',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_pro_product_type_id` (`product_type_id`) USING BTREE,
  KEY `index_pro_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品信息(单表)';

/*Table structure for table `test_pie_class` */

DROP TABLE IF EXISTS `test_pie_class`;

CREATE TABLE `test_pie_class` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `class_name` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '班级',
  `num` int(11) DEFAULT NULL COMMENT '人数',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='班级';

/*Table structure for table `test_tree` */

DROP TABLE IF EXISTS `test_tree`;

CREATE TABLE `test_tree` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protype_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='树结构(商品分类)';

/*Table structure for table `test_uielement` */

DROP TABLE IF EXISTS `test_uielement`;

CREATE TABLE `test_uielement` (
  `id` varchar(30) NOT NULL,
  `product_id` varchar(50) DEFAULT NULL COMMENT '列表选择器',
  `product_type` varchar(50) DEFAULT NULL COMMENT '树形选择器',
  `sex` char(1) DEFAULT NULL COMMENT '数据字典radio',
  `sex2` varchar(50) DEFAULT NULL COMMENT '数据字典select',
  `tags` varchar(50) DEFAULT '' COMMENT '多选下拉标签',
  `tags2` varchar(50) DEFAULT NULL COMMENT '数据字典checkbox',
  `user_id` varchar(50) DEFAULT NULL COMMENT '人员选择',
  `office_id` varchar(50) DEFAULT NULL COMMENT '部门选择',
  `image` varchar(1000) DEFAULT NULL COMMENT '单图片上传',
  `image2` varchar(1000) DEFAULT NULL COMMENT '多图片上传',
  `file` varchar(1000) DEFAULT NULL COMMENT '单文件上传',
  `file2` varchar(1000) DEFAULT NULL COMMENT '多文件上传',
  `content` varchar(10000) DEFAULT NULL COMMENT '富文本编辑器',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI标签';

/*Table structure for table `test_validation` */

DROP TABLE IF EXISTS `test_validation`;

CREATE TABLE `test_validation` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '非空',
  `num` double DEFAULT NULL COMMENT '金额',
  `num2` int(11) DEFAULT NULL COMMENT '整数',
  `new_date` datetime DEFAULT NULL COMMENT '日期',
  `date2` datetime DEFAULT NULL COMMENT '时间',
  `mobile` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `url` varchar(64) DEFAULT NULL COMMENT '网址',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='校验测试表单';

/*Table structure for table `ts_test` */

DROP TABLE IF EXISTS `ts_test`;

CREATE TABLE `ts_test` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(30) DEFAULT NULL COMMENT '名称',
  `sex` char(1) DEFAULT NULL,
  `age` int(10) DEFAULT NULL COMMENT '年龄',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息';

/*Table structure for table `ts_tree` */

DROP TABLE IF EXISTS `ts_tree`;

CREATE TABLE `ts_tree` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `index_protype_del_flag` (`del_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='树结构(商品分类)';

/*Table structure for table `wms_allot` */

DROP TABLE IF EXISTS `wms_allot`;

CREATE TABLE `wms_allot` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `num` int(11) DEFAULT NULL COMMENT '总数量',
  `real_num` int(11) DEFAULT '0' COMMENT '已完成数',
  `out_warehouse_id` varchar(30) DEFAULT NULL COMMENT '调出仓库',
  `in_warehouse_id` varchar(30) DEFAULT NULL COMMENT '调入出库',
  `logistics_company` varchar(50) DEFAULT NULL COMMENT '物流公司',
  `logistics_no` varchar(50) DEFAULT NULL COMMENT '物流单号',
  `logistics_amount` decimal(12,2) DEFAULT NULL COMMENT '运费',
  `fi_account_id` varchar(30) DEFAULT NULL COMMENT '支付账户',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchase_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调拨单';

/*Table structure for table `wms_allot_detail` */

DROP TABLE IF EXISTS `wms_allot_detail`;

CREATE TABLE `wms_allot_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `allot_id` varchar(30) DEFAULT NULL COMMENT '所属调拨单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL,
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `sort` int(10) DEFAULT NULL COMMENT '排序',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`allot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调拨单明细';

/*Table structure for table `wms_instock` */

DROP TABLE IF EXISTS `wms_instock`;

CREATE TABLE `wms_instock` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `instock_type` char(1) DEFAULT NULL,
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `purchase_id` varchar(30) DEFAULT NULL COMMENT '关联采购单号',
  `supplier_id` varchar(30) DEFAULT NULL COMMENT '供应商',
  `customer_id` varchar(50) DEFAULT NULL,
  `content` varchar(50) DEFAULT NULL COMMENT '内容',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `real_num` int(11) DEFAULT '0' COMMENT '已入库数',
  `warehouse_id` varchar(30) DEFAULT NULL COMMENT '入库仓库',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchase_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入库单';

/*Table structure for table `wms_instock_detail` */

DROP TABLE IF EXISTS `wms_instock_detail`;

CREATE TABLE `wms_instock_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `instock_id` varchar(30) DEFAULT NULL COMMENT '所属入库单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `instock_num` int(11) DEFAULT NULL COMMENT '已入库数量',
  `diff_num` int(11) DEFAULT NULL COMMENT '未入库数量',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `sort` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`instock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入库单明细';

/*Table structure for table `wms_outstock` */

DROP TABLE IF EXISTS `wms_outstock`;

CREATE TABLE `wms_outstock` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `outstock_type` char(1) DEFAULT NULL COMMENT '出库单类型',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `order_id` varchar(30) DEFAULT NULL COMMENT '关联订单号',
  `supplier_id` varchar(30) DEFAULT NULL COMMENT '供应商',
  `customer_id` varchar(50) DEFAULT NULL,
  `content` varchar(50) DEFAULT NULL COMMENT '内容',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `real_num` int(11) DEFAULT '0' COMMENT '已出库数',
  `warehouse_id` varchar(30) DEFAULT NULL COMMENT '入库仓库',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchase_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出库单';

/*Table structure for table `wms_outstock_detail` */

DROP TABLE IF EXISTS `wms_outstock_detail`;

CREATE TABLE `wms_outstock_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `instock_id` varchar(30) DEFAULT NULL COMMENT '所属出库单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `outstock_num` int(11) DEFAULT NULL COMMENT '已出库数量',
  `diff_num` int(11) DEFAULT NULL COMMENT '未出库数量',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `sort` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`instock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出库单明细';

/*Table structure for table `wms_product` */

DROP TABLE IF EXISTS `wms_product`;

CREATE TABLE `wms_product` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) NOT NULL COMMENT '商品编号',
  `name` varchar(50) NOT NULL COMMENT '商品名称',
  `code` varchar(50) DEFAULT NULL COMMENT '商品条码',
  `product_type_id` varchar(30) DEFAULT NULL COMMENT '商品分类',
  `unit_type` char(2) DEFAULT NULL COMMENT '基本单位',
  `spec` varchar(30) DEFAULT NULL COMMENT '规格',
  `color` varchar(30) DEFAULT NULL COMMENT '颜色',
  `size` varchar(30) DEFAULT NULL COMMENT '尺寸',
  `custom_field1` varchar(30) DEFAULT NULL COMMENT '自定义属性1',
  `custom_field2` varchar(30) DEFAULT NULL COMMENT '自定义属性2',
  `product_img` varchar(200) DEFAULT NULL COMMENT '商品图片',
  `sale_price` decimal(12,2) DEFAULT NULL COMMENT '零售价',
  `batch_price` decimal(12,2) DEFAULT NULL COMMENT '批发价',
  `min_price` decimal(12,2) DEFAULT NULL COMMENT '最低售价',
  `cost_price` decimal(12,2) DEFAULT NULL COMMENT '参考成本价',
  `min_stock` int(11) DEFAULT NULL COMMENT '最低库存量',
  `max_stock` int(11) DEFAULT NULL COMMENT '最高库存量',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_pro_product_type_id` (`product_type_id`) USING BTREE,
  KEY `index_pro_del_flag` (`del_flag`) USING BTREE,
  KEY `index_pro_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品表';

/*Table structure for table `wms_product_data` */

DROP TABLE IF EXISTS `wms_product_data`;

CREATE TABLE `wms_product_data` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '编号',
  `content` text COLLATE utf8_bin COMMENT '商品详情',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='商品详情表';

/*Table structure for table `wms_product_type` */

DROP TABLE IF EXISTS `wms_product_type`;

CREATE TABLE `wms_product_type` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_protype_del_flag` (`del_flag`) USING BTREE,
  KEY `index_protype_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品分类';

/*Table structure for table `wms_purchase` */

DROP TABLE IF EXISTS `wms_purchase`;

CREATE TABLE `wms_purchase` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) DEFAULT NULL COMMENT '单号',
  `supplier_id` varchar(30) DEFAULT NULL COMMENT '供应商',
  `content` varchar(50) DEFAULT NULL COMMENT '内容',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `total_amt` decimal(12,2) DEFAULT NULL COMMENT '合计',
  `tax_amt` decimal(12,2) DEFAULT NULL COMMENT '税额',
  `other_amt` decimal(12,2) DEFAULT NULL COMMENT '其他费用',
  `amount` decimal(12,2) NOT NULL COMMENT '总计金额',
  `warehouse_id` varchar(30) DEFAULT NULL COMMENT '入库仓库',
  `status` varchar(1) DEFAULT NULL COMMENT '审核状态',
  `deal_by` varchar(30) DEFAULT NULL COMMENT '经办人',
  `deal_date` datetime DEFAULT NULL COMMENT '业务日期',
  `create_by` varchar(30) NOT NULL COMMENT '制单人',
  `create_date` datetime NOT NULL COMMENT '制单时间',
  `audit_by` varchar(30) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_purchase_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchase_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='采购单';

/*Table structure for table `wms_purchase_detail` */

DROP TABLE IF EXISTS `wms_purchase_detail`;

CREATE TABLE `wms_purchase_detail` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `purchase_id` varchar(30) DEFAULT NULL COMMENT '所属采购单',
  `product_id` varchar(30) NOT NULL COMMENT '商品',
  `unit_type` varchar(30) DEFAULT NULL COMMENT '单位',
  `price` decimal(12,2) DEFAULT NULL COMMENT '单价(元)',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '金额(元)',
  `tax_rate` decimal(12,2) DEFAULT NULL COMMENT '税率',
  `tax_amt` decimal(12,2) DEFAULT NULL COMMENT '税额',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  `sort` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_purchase_detail_del_flag` (`del_flag`) USING BTREE,
  KEY `index_purchasedetail_purchaseid` (`purchase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='采购单明细';

/*Table structure for table `wms_stock` */

DROP TABLE IF EXISTS `wms_stock`;

CREATE TABLE `wms_stock` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `product_id` varchar(30) DEFAULT NULL COMMENT '商品',
  `warehouse_id` varchar(30) DEFAULT NULL COMMENT '仓库',
  `stock_num` int(11) DEFAULT NULL COMMENT '库存数',
  `warn_num` int(11) DEFAULT NULL COMMENT '预警数',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wms_stock_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品库存';

/*Table structure for table `wms_stock_journal` */

DROP TABLE IF EXISTS `wms_stock_journal`;

CREATE TABLE `wms_stock_journal` (
  `id` varchar(30) NOT NULL COMMENT 'ID',
  `product_id` varchar(30) DEFAULT NULL COMMENT '商品',
  `deal_type` char(1) DEFAULT NULL COMMENT '操作类型',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `notes` varchar(50) DEFAULT NULL COMMENT '摘要',
  `warehouse_id` varchar(30) DEFAULT NULL COMMENT '仓库',
  `unique_code` varchar(50) DEFAULT NULL COMMENT '唯一码',
  `create_by` varchar(30) DEFAULT NULL COMMENT '操作人',
  `create_date` datetime DEFAULT NULL COMMENT '操作日期',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `wms_stock_journal_product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='库存流水';

/*Table structure for table `wms_supplier` */

DROP TABLE IF EXISTS `wms_supplier`;

CREATE TABLE `wms_supplier` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) NOT NULL COMMENT '编号',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `supplier_type_id` varchar(30) DEFAULT NULL COMMENT '供应商分类',
  `contact_name` varchar(30) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `qq` varchar(30) DEFAULT NULL COMMENT 'QQ',
  `fax` varchar(30) DEFAULT NULL COMMENT '传真',
  `zipcode` int(10) DEFAULT NULL COMMENT '邮编',
  `address` varchar(50) DEFAULT NULL COMMENT '联系地址',
  `arrear` decimal(12,2) DEFAULT '0.00' COMMENT '应付欠款',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_supplier_del_flag` (`del_flag`) USING BTREE,
  KEY `index_supplier_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商';

/*Table structure for table `wms_supplier_type` */

DROP TABLE IF EXISTS `wms_supplier_type`;

CREATE TABLE `wms_supplier_type` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `parent_id` varchar(30) DEFAULT NULL COMMENT '上级分类',
  `parent_ids` varchar(1000) DEFAULT NULL COMMENT '所有父级编号',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(30) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `supplier_protype_del_flag` (`del_flag`) USING BTREE,
  KEY `supplier_protype_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商分类';

/*Table structure for table `wms_warehouse` */

DROP TABLE IF EXISTS `wms_warehouse`;

CREATE TABLE `wms_warehouse` (
  `id` varchar(30) NOT NULL COMMENT '编号',
  `no` varchar(30) NOT NULL COMMENT '仓库编号',
  `name` varchar(50) NOT NULL COMMENT '仓库名称',
  `is_default` char(1) DEFAULT NULL COMMENT '是否默认',
  `contact_name` varchar(30) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `mobile` varchar(20) DEFAULT NULL COMMENT '联系手机',
  `email` varchar(50) DEFAULT NULL COMMENT '联系邮箱',
  `address` varchar(50) DEFAULT NULL COMMENT '联系地址',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(30) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(50) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `account_id` varchar(30) DEFAULT NULL COMMENT '企业帐号',
  PRIMARY KEY (`id`),
  KEY `index_warehouser_del_flag` (`del_flag`) USING BTREE,
  KEY `index_warehouser_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仓库表';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
