package com.javafast.api.sms.utils;

import java.util.Date;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.sms.aliyun.AliyunSMSUtil;
import com.javafast.common.config.Global;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.entity.SysSms;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.SysSmsService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 手机短信工具
 */
public class SmsUtils {

	private static SysSmsService sysSmsService = SpringContextHolder.getBean(SysSmsService.class);
	
	private static SysAccountService sysAccountService = SpringContextHolder.getBean(SysAccountService.class);
	
	private static UserService userService = SpringContextHolder.getBean(UserService.class);
	
	/**
	 * 下发验证码短信 您的手机验证码为：${code}，5分钟内有效
	 * @param mobile
	 * @param verifCode 验证码
	 * @return
	 */
	public static boolean sendVerifCodeSms(String mobile, String verifCode) {  
		
		try {
			
			JSONObject json = new JSONObject();
			json.put("code", verifCode);
			
			//System.out.println("下发验证码："+mobile+","+verifCode);
			return AliyunSMSUtil.sendSms(AliyunSMSUtil.verifCodeTemplateCode, mobile, json.toJSONString());
		}catch (Exception e) {
			e.printStackTrace();
		}
		return false;
    }
	
	/**
	 * 注册成功通知 恭喜您注册成功！您的登录账号：${loginname}，登录密码：${loginpwd}，请妥善保管。
	 * @param mobile
	 * @param loginname 个人登录账号
	 * @param loginpwd 个人登录密码
	 * @return
	 */
	public static boolean sendRegMsgSms(String mobile, String accountid, String loginname, String loginpwd) {  
		
		try {

			JSONObject json = new JSONObject();
			json.put("accountid", accountid);
			json.put("loginname", loginname);
			json.put("loginpwd", loginpwd);
			
			return AliyunSMSUtil.sendSms(AliyunSMSUtil.regMsgTemplateCode, mobile, json.toJSONString());
        } catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }
	
	/**
	 * 密码重置成功通知： 密码重置成功！您的登录账号：${loginname}，登录密码：${loginpwd}，请妥善保管。
	 * @param mobile
	 * @param loginname
	 * @param loginpwd
	 * @return
	 */
	public static boolean sendResetPwdSms(String mobile, String accountid, String loginname, String loginpwd) {  
		
		try {

			JSONObject json = new JSONObject();
			json.put("accountid", accountid);
			json.put("loginname", loginname);
			json.put("loginpwd", loginpwd);
			
			return AliyunSMSUtil.sendSms(AliyunSMSUtil.resetPwdTemplateCode, mobile, json.toJSONString());
        } catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }
	
	/**
	 * 面试通知
	 * ${name}您好，${company}的HR向您发送了邀约通知邮件，请您进入邮箱${tomail}查收并回复。
	 * @return
	 */
	public static boolean sendInterviewSms(String mobile, String name, String company, String tomail) {  
		
		try {

			JSONObject json = new JSONObject();
			json.put("name", name);
			json.put("company", company);
			json.put("tomail", tomail);
			
			return AliyunSMSUtil.sendSms(AliyunSMSUtil.hrInterviewTemplateCode, mobile, json.toJSONString());
        } catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }
	
	/**
	 * OFFER通知
	 *  ${name}您好，${company}的HR向您发放了OFFER，请您进入邮箱${tomail}查收并回复。
	 * @return
	 */
	public static boolean sendOfferSms(String mobile, String name, String company, String tomail) {  
		
		try {

			JSONObject json = new JSONObject();
			json.put("name", name);
			json.put("company", company);
			json.put("tomail", tomail);
			
			return AliyunSMSUtil.sendSms(AliyunSMSUtil.hrOfferTemplateCode, mobile, json.toJSONString());
        } catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }
	
	/**
	 * 入职成功通知
	 * ${name}您好，${company}已经为您开通了系统账号，请通过手机号码：${umobile}登录${systemname}了解详情。
	 * @return
	 */
	public static boolean sendEntrySms(String mobile, String name, String company, String systemname) {  
		
		try {

			JSONObject json = new JSONObject();
			json.put("name", name);
			json.put("company", company);
			json.put("umobile", mobile);
			json.put("systemname", systemname);
			return AliyunSMSUtil.sendSms(AliyunSMSUtil.hrEntryTemplateCode, mobile, json.toJSONString());
        } catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }

	/**
	 * 模板短信
	 * @param templateCode
	 * @param mobile
	 * @return
	 */
	public static boolean sendTempletSms(String templateCode, String mobile) {  
		
		try {

			return AliyunSMSUtil.sendSms(templateCode, mobile, null);
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }
	
	/**
	 * 发送普通通知类短信
	 * @param smsCode 短信模板
	 * @param mobile
	 * @param accountname
	 * @return
	 */
	public static boolean sendCommonSms(String smsCode, String mobile, String accountname) {  
		
		try {

			if(StringUtils.isBlank(smsCode) || StringUtils.isBlank(mobile)){
				return false;
			}
			
			JSONObject json = new JSONObject();
			json.put("accountname", accountname);
			
			return AliyunSMSUtil.sendSms(smsCode, mobile, json.toJSONString());
        } catch (Exception e) {
			e.printStackTrace();
			return false;
		}
    }
	
	/**
	 * 创建短信通知(异步发送)
	 * @param smsType 短信类型  14:OA审批提醒，20：CRM客户指派提醒
	 * @param userId 接收人ID
	 */
	public static void addSms(String smsType, String userId) {
		
		if(StringUtils.isNotBlank(userId)){
			
			User user = userService.getUserByDb(userId);
			if(StringUtils.isNotBlank(user.getMobile())){
			
				//手机短信通知 (前提：开通短信提醒功能)
				if(Contants.IS_EABLE.equals(UserUtils.getSysAccount().getSmsStatus())){
					
					SysSms sysSms = new SysSms();
					sysSms.setSmsType(smsType);
					sysSms.setMobile(user.getMobile());
					sysSms.setStatus(Global.NO);
					sysSmsService.save(sysSms);
				}
			}
		}
	}
	
	/**
	 * 推送短信
	 */
	public static void pushSms() {
		
		SysSms conSysSms = new SysSms();
		conSysSms.setStatus(Global.NO);
		List<SysSms> sysSmsList = sysSmsService.findAllList(conSysSms);
		if(sysSmsList == null  || sysSmsList.size() == 0){
			return;
		}
		
		for(int i=0; i<sysSmsList.size(); i++){
			
			SysSms sysSms = sysSmsList.get(i);
			if(StringUtils.isBlank(sysSms.getAccountId())){
				continue;
			}
			
			//获取短信发送内容
			String accountName = sysAccountService.get(sysSms.getAccountId()).getName();
			String smsCode = "";
			if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(sysSms.getSmsType())){
				smsCode = AliyunSMSUtil.resetCRMTemplateCode;
			}
			if(Contants.OBJECT_OA_TYPE_AUDIT.equals(sysSms.getSmsType())){
				smsCode = AliyunSMSUtil.resetOATemplateCode;
			}
			
			//发送
			boolean result = sendCommonSms(smsCode, sysSms.getMobile(), accountName);
			if(result){
				//更新短信记录状态
				sysSms.setStatus("1");
				sysSmsService.save(sysSms);
			}
		}
	}
}
