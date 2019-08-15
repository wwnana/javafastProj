package com.javafast.api.sms.aliyun;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;

import com.javafast.common.config.Global;

/**
 * 阿里云短信工具实现类
 * @author JavaFast
 */
public class AliyunSMSUtil {
	
	//产品名称:云通信短信API产品,开发者无需替换
    static final String product = "Dysmsapi";
    //产品域名,开发者无需替换
    static final String domain = "dysmsapi.aliyuncs.com";

    // TODO 此处需要替换成开发者自己的AK(在阿里云访问控制台寻找)
    public static final String accessKeyId = Global.getConfig("aliyun.sms.accessKey");//Key
	public static final String accessKeySecret = Global.getConfig("aliyun.sms.accessSecret");//Secret
	public static final String signName = Global.getConfig("aliyun.sms.signName");//发送短信使用的签名
	
	//验证码短信模板： 您的手机验证码为：${code}，5分钟内有效
	public static final String verifCodeTemplateCode = Global.getConfig("aliyun.sms.verifCodeTemplateCode");
	
	//注册成功通知短信模板：恭喜您注册成功！您的登录账号：${loginname}，登录密码：${loginpwd}，请妥善保管。
	public static final String regMsgTemplateCode = Global.getConfig("aliyun.sms.regMsgTemplateCode");
	
	//密码重置成功通知短信模板： 密码重置成功！您的登录账号：${loginname}，登录密码：${loginpwd}，请妥善保管。
	public static final String resetPwdTemplateCode = Global.getConfig("aliyun.sms.resetPwdTemplateCode");
	
	//尊敬的${accountname}用户，您有新的审批任务，请登录企酷CRM进行审批。
	public static final String resetOATemplateCode = Global.getConfig("aliyun.sms.resetOATemplateCode");
	
	//尊敬的${accountname}用户，您收到新的客户指派任务，请登录企酷CRM了解详情。
	public static final String resetCRMTemplateCode = Global.getConfig("aliyun.sms.resetCRMTemplateCode");
	
	//面试通知 ${name}您好，${company}的HR向您发送了邀约通知邮件，请您进入邮箱${tomail}查收并回复。
	public static final String hrInterviewTemplateCode = Global.getConfig("aliyun.sms.hrInterviewTemplateCode");
	
	//OFFER通知 ${name}您好，${company}的HR向您发放了OFFER，请您进入邮箱${tomail}查收并回复。
	public static final String hrOfferTemplateCode = Global.getConfig("aliyun.sms.hrOfferTemplateCode");
	
	//入职成功通知${name}您好，${company}已经为您开通了系统账号，请通过手机号码：${umobile}登录${systemname}了解详情。
	public static final String hrEntryTemplateCode = Global.getConfig("aliyun.sms.hrEntryTemplateCode");
	
	/**
	 * 发送短信
	 * @param templateCode 短信模板
	 * @param mobile 手机号码
	 * @param json 参数
	 * @throws Exception 
	 */
	public static boolean sendSms(String templateCode, String mobile, String json) throws Exception {
				
		//可自助调整超时时间
        System.setProperty("sun.net.client.defaultConnectTimeout", "10000");
        System.setProperty("sun.net.client.defaultReadTimeout", "10000");

        //初始化acsClient,暂不支持region化
        IClientProfile profile = DefaultProfile.getProfile("cn-hangzhou", accessKeyId, accessKeySecret);
        DefaultProfile.addEndpoint("cn-hangzhou", "cn-hangzhou", product, domain);
        IAcsClient acsClient = new DefaultAcsClient(profile);

        //组装请求对象-具体描述见控制台-文档部分内容
        SendSmsRequest request = new SendSmsRequest();
        //必填:待发送手机号
        request.setPhoneNumbers(mobile);
        //必填:短信签名-可在短信控制台中找到
        request.setSignName(signName);
        //必填:短信模板-可在短信控制台中找到
        request.setTemplateCode(templateCode);
        //可选:模板中的变量替换JSON串,如模板内容为"亲爱的${name},您的验证码为${code}"时,此处的值为
        request.setTemplateParam(json);

        //选填-上行短信扩展码(无特殊需求用户请忽略此字段)
        //request.setSmsUpExtendCode("90997");

        //可选:outId为提供给业务方扩展字段,最终在短信回执消息中将此值带回给调用者
        //request.setOutId("yourOutId");

        //hint 此处可能会抛出异常，注意catch
        SendSmsResponse sendSmsResponse = acsClient.getAcsResponse(request);
        
        //成功
        if("OK".equals(sendSmsResponse.getCode())){
        	
        	return true;
        }else{
        	System.out.println("阿里云短信下发失败，短信接口返回的数据----------------");
            System.out.println("Code=" + sendSmsResponse.getCode());
            System.out.println("Message=" + sendSmsResponse.getMessage());
            System.out.println("RequestId=" + sendSmsResponse.getRequestId());
            System.out.println("BizId=" + sendSmsResponse.getBizId());
        } 
        
        return false;
    }
}
