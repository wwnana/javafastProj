package com.javafast.modules.sys.utils;

/**
 * 常量管理工具
 * @author 1002377
 *
 */
public class Contants {

	//是和否常量
	public static final String IS_EABLE = "1";//1代表是或有
	public static final String IS_UNEABLE = "0";//0代表否或无
	
	public static final String API_KEY = "0000AAick";//API_KEY
	
	//销售阶段
	public static final String CRM_PERIOD_TYPE_PURPOSE = "1";//初步恰接 1
	public static final String CRM_PERIOD_TYPE_DEMAND = "2";//需求确定2
	public static final String CRM_PERIOD_TYPE_QUOTE = "3";//方案报价3
	public static final String CRM_PERIOD_TYPE_ORDER = "4";//成交待收4
	public static final String CRM_PERIOD_TYPE_COMPLETE = "5";//回款完成5
	
	//审批类型
	public static final String AUDIT_TYPE_COMMON = "0";//普通审批
	
	public static final String AUDIT_TYPE_LEAVE = "1";//请假单
	
	public static final String AUDIT_TYPE_EXPENSE = "2";//报销单
	
	public static final String AUDIT_TYPE_TRAVEL = "3";//差旅单
	
	public static final String AUDIT_TYPE_BORROW = "4";//借款单
	
	//object_type对象类型,0：登陆，99：退出，    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单, 30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
	public static final String OBJECT_SYS_TYPE_LOGIN = "0";//登陆
	public static final String OBJECT_SYS_TYPE_LOGINOUT = "99";//退出
	public static final String OBJECT_SYS_TYPE_SIGNIN = "2";//签到
	public static final String OBJECT_SYS_TYPE_SIGNOUT = "3";//签退
	
	public static final String OBJECT_OA_TYPE_PROJECT = "10";//项目
	public static final String OBJECT_OA_TYPE_TASK = "11";//任务
	public static final String OBJECT_OA_TYPE_WORKLOG = "12";//日报
	public static final String OBJECT_OA_TYPE_NOTIFY = "13";//通知
	public static final String OBJECT_OA_TYPE_AUDIT = "14";//审批
	
	public static final String OBJECT_CRM_TYPE_MARKET = "18";//市场活动
	public static final String OBJECT_CRM_TYPE_CLUE = "19";//销售线索
	public static final String OBJECT_CRM_TYPE_CUSTOMER = "20";//客户
	public static final String OBJECT_CRM_TYPE_CONTACTER = "21";//联系人
	public static final String OBJECT_CRM_TYPE_CHANCE = "22";//商机
	public static final String OBJECT_CRM_TYPE_QUOTE = "23";//报价
	public static final String OBJECT_CRM_TYPE_CONTRACT = "16";//合同
	public static final String OBJECT_CRM_TYPE_CONTRACT_ORDER = "24";//订单
	public static final String OBJECT_CRM_TYPE_RECORD = "25";//沟通
	public static final String OBJECT_CRM_TYPE_ORDER = "26";//订单
	public static final String OBJECT_CRM_TYPE_RETURN_ORDER = "27";//退货单
	public static final String OBJECT_CRM_TYPE_ORDERWORK = "28";//工单
	public static final String OBJECT_WMS_TYPE_PROBLEM = "29";//知识
	
	public static final String OBJECT_WMS_TYPE_PRODUCT = "30";//产品
	public static final String OBJECT_WMS_TYPE_PURCHASE = "31";//采购
	public static final String OBJECT_WMS_TYPE_STOKBILL_IN = "32";//入库
	public static final String OBJECT_WMS_TYPE_STOKBILL_OUT = "33";//出库
	public static final String OBJECT_WMS_TYPE_STOKMOVE = "34";//移库	
	public static final String OBJECT_WMS_TYPE_CHECK = "36";//盘点
	public static final String OBJECT_WMS_TYPE_ALLOT = "37";//调拨
	public static final String OBJECT_WMS_TYPE_SUPPLIER = "39";//供应商
	
	public static final String OBJECT_FI_TYPE_RECEIVABLE = "50";//应收款
	public static final String OBJECT_FI_TYPE_PAYMENTABLE = "51";//应付款
	public static final String OBJECT_FI_TYPE_RECEIVEBILL = "52";//收款单
	public static final String OBJECT_FI_TYPE_PAYMENTBILL = "53";//付款单
	
	//action_type动作类型，  1：创建，2：修改，3：删除，4：撤销，5:还原，6：审核，7：拒绝，8：分享 ，9：指派，10:领取，11：激活，12：冻结    ，21：启动，22：完成，23：暂停，24:关闭                     0:登陆，99：退出
	public static final String ACTION_TYPE_ADD = "1";//创建
	public static final String ACTION_TYPE_UPDATE = "2";//修改
	public static final String ACTION_TYPE_DEL = "3";//删除
	public static final String ACTION_TYPE_CANCEL = "4";//撤销
	public static final String ACTION_TYPE_BACK = "5";//还原
	public static final String ACTION_TYPE_AUDIT = "6";//审核
	public static final String ACTION_TYPE_REJECT = "7";//拒绝
	public static final String ACTION_TYPE_SHARE = "8";//分享
	public static final String ACTION_TYPE_APPOINT = "9";//指派
	public static final String ACTION_TYPE_DRAW = "10";//领取
	public static final String ACTION_TYPE_ACTIVE = "11";//激活
	public static final String ACTION_TYPE_UNACTIVE = "12";//冻结
	public static final String ACTION_TYPE_POOL = "15";//放入公海
	public static final String ACTION_TYPE_CHANGE = "16";//转化为客户
	public static final String ACTION_TYPE_AUTO_POOL = "19";//自动回收到公海
	
	public static final String ACTION_TYPE_START = "21";//启动
	public static final String ACTION_TYPE_END = "22";//完成
	public static final String ACTION_TYPE_STOP = "23";//暂停
	public static final String ACTION_TYPE_CLOSE = "24";//关闭 
	
	public static final String ACTION_TYPE_UNLOCK = "30"; //解锁
	public static final String ACTION_TYPE_LOCK = "31"; //锁定
	
	public static final String ACTION_TYPE_IMPORT = "40"; //导入
	public static final String ACTION_TYPE_EXPORT = "41"; //导出
	
	//面板类型
	public static final String PANEL_TYPE_NOTIFY = "0";//最新公告
	public static final String PANEL_TYPE_REMIND = "1";//待办提醒
	public static final String PANEL_TYPE_NOTE = "2";//我的便签
	public static final String PANEL_TYPE_AUDIT = "5";//待办审批
	
	public static final String PANEL_TYPE_PROJECT = "11";//待办项目
	public static final String PANEL_TYPE_TASK = "12";//待办任务
	public static final String PANEL_TYPE_PROJECT_VIEW = "18";//项目总览
	public static final String PANEL_TYPE_TASK_VIEW = "19";//任务总览
	
	public static final String PANEL_TYPE_CRM_REPORT = "20";//个人业绩
	public static final String PANEL_TYPE_CHANCE_PERIOD = "21";//阶段分析
	public static final String PANEL_TYPE_CRM_REMIND = "22";//客户提醒
	public static final String PANEL_TYPE_CRM_RECORD = "23";//待办拜访
	public static final String PANEL_TYPE_CRM_VIEW = "27";//业务总览
	public static final String PANEL_TYPE_BROWSE = "28";//最近浏览
	
	public static final String PANEL_TYPE_WMS_VIEW = "30";//进销存总览
	public static final String PANEL_TYPE_INSTOCK = "31";//待办入库
	public static final String PANEL_TYPE_OUTSTOCK = "32";//待办出库
	public static final String PANEL_TYPE_PURCHASE = "34";//待办采购
	public static final String PANEL_TYPE_STOCK_WARN = "35";//库存预警
	
	public static final String PANEL_TYPE_FI_VIEW = "41";//财务总览
	public static final String PANEL_TYPE_ABLE_RECEIVE = "42";//待办应收
	public static final String PANEL_TYPE_ABLE_PAYMENT = "43";//待办应付
	public static final String PANEL_TYPE_RECEIVE_BILL = "44";//待核收款
	public static final String PANEL_TYPE_PAYMENT_BILL = "45";//待核付款
	
	public static final String PANEL_TYPE_HR_VIEW = "51";//人事总览
	public static final String PANEL_TYPE_INTERVIEW = "52";//面试日程
	public static final String PANEL_TYPE_OFFER = "53";//本周OFFER
	public static final String PANEL_TYPE_NEW_EMPLOYEE = "55";//新入职员工
	public static final String PANEL_TYPE_CONTACT_REMIND = "56";//合同到期提醒
	
	//APP key
	public static final String APP_KEY = "8WYHG6NGC";
		
	//默认头像
	public static final String TEMP_USER_IMG = "/static/images/user.jpg";
	public static final String SITE_URL = "http://crm.qikucrm.com";
}
