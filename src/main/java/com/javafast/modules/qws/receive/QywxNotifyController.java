package com.javafast.modules.qws.receive;

import com.javafast.api.qywxs.aes.AesException;
import com.javafast.api.qywxs.aes.WXBizMsgCrypt;
import com.javafast.modules.qws.service.MessageCompanyService;
import com.javafast.modules.qws.utils.ProviderConstantUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 接收企业微信消息控制器
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/wechat/notify")
public class QywxNotifyController {

	private static final Logger logger = LoggerFactory.getLogger(QywxNotifyController.class);
	
	@Autowired
	private MessageCompanyService messageCompanyService;
	
	/**
	 * 指令回调消息
	 * 系统将会把此应用的授权变更事件以及ticket参数等推送给此URL，ticket说明详见API接口说明。
	 * (填写URL时需要正确响应企业微信验证URL的请求。请参考接收消息） 
	 * POST 为接收消息
	 */
	@RequestMapping(value = "callback", method = RequestMethod.POST)
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		logger.info("=================接收指令回调消息=================");
		
		// 1.将请求、响应的编码均设置为UTF-8（防止中文乱码）
		System.out.println("callback-doPost");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// 2.调用消息业务类接收消息、处理消息
		String respMessage = messageCompanyService.getEncryptRespMessageCallBack(request);

		// 处理表情
		// String respMessage = CoreService.processRequest_emoj(request);
		// 处理图文消息
		// String respMessage = Test_NewsService.processRequest(request);

		// 3.响应消息
		PrintWriter out = response.getWriter();
		out.print(respMessage);
		out.close();
	}

	/**
	 * 数据回调消息
	 * 用于接收托管企业微信应用的用户消息和用户事件。
	 * URL支持使用$CORPID$模板参数表示corpid，推送事件时企业微信会自动将其替换为授权企业的corpid。
	 * (关于如何回调，请参考接收消息。注意验证时$CORPID$模板参数会替换为当前服务商的corpid，校验时也应该使用corpid初始化解密库)
	 * POST 为接收消息
	 */
	@RequestMapping(value = "ticket", method = RequestMethod.POST)
	public void doPostCollBack(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		logger.info("=================接收数据回调消息=================");
		
		// 1.将请求、响应的编码均设置为UTF-8（防止中文乱码）
		System.out.println("ticket-POst0------------");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// 2.调用消息业务类接收消息、处理消息
		String respMessage = messageCompanyService.getEncryptRespMessageBySuite(request);

		// 处理表情
		// String respMessage = CoreService.processRequest_emoj(request);
		// 处理图文消息
		// String respMessage = Test_NewsService.processRequest(request);

		// 3.响应消息
		PrintWriter out = response.getWriter();
		out.print(respMessage);
		out.close();
	}

	/**
	 * 数据回调URL校验
	 * GET为校验
	 */
	@RequestMapping(value = "ticket", method = RequestMethod.GET)
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, AesException {

		logger.info("=================数据回调URL校验=================");
		
		// 微信加密签名
		String msg_signature = request.getParameter("msg_signature");
		// 时间戳
		String timestamp = request.getParameter("timestamp");
		// 随机数
		String nonce = request.getParameter("nonce");
		// 随机字符串
		String echostr = request.getParameter("echostr");

		System.out.println("request=" + request.getRequestURL());

		PrintWriter out = response.getWriter();
		// 通过检验msg_signature对请求进行校验，若校验成功则原样返回echostr，表示接入成功，否则接入失败
		String result = null;
		try {
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey, ProviderConstantUtils.corpId);
			result = wxcpt.VerifyURL(msg_signature, timestamp, nonce, echostr);
		} catch (AesException e) {
			e.printStackTrace();
		}
		if (result == null) {
			result = ProviderConstantUtils.token;
		}
		out.print(result);
		out.close();
		out = null;
	}

	/**
	 * 指令回调URLURL校验
	 * GET为校验
	 */
	@RequestMapping(value = "callback", method = RequestMethod.GET)
	public void doGetcall(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, AesException {

		logger.info("=================指令回调URL校验=================");
		
		// 微信加密签名
		String msg_signature = request.getParameter("msg_signature");
		// 时间戳
		String timestamp = request.getParameter("timestamp");
		// 随机数
		String nonce = request.getParameter("nonce");
		// 随机字符串
		String echostr = request.getParameter("echostr");

		System.out.println("request=" + request.getRequestURL());

		PrintWriter out = response.getWriter();
		// 通过检验msg_signature对请求进行校验，若校验成功则原样返回echostr，表示接入成功，否则接入失败
		String result = null;
		try {
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey,
					ProviderConstantUtils.corpId);
			result = wxcpt.VerifyURL(msg_signature, timestamp, nonce, echostr);
		} catch (AesException e) {
			e.printStackTrace();
		}
		if (result == null) {
			result = ProviderConstantUtils.token;
		}
		out.print(result);
		out.close();
		out = null;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 确认请求来自微信服务器 <暂时不用>
	 */
	@RequestMapping(value = "msg", method = RequestMethod.GET)
	public void doGetMessage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, AesException {

		// 微信加密签名
		String msg_signature = request.getParameter("msg_signature");
		// 时间戳
		String timestamp = request.getParameter("timestamp");
		// 随机数
		String nonce = request.getParameter("nonce");
		// 随机字符串
		String echostr = request.getParameter("echostr");

		System.out.println("request=" + request.getRequestURL());

		PrintWriter out = response.getWriter();
		// 通过检验msg_signature对请求进行校验，若校验成功则原样返回echostr，表示接入成功，否则接入失败
		String result = null;
		try {
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey,
					ProviderConstantUtils.corpId);
			result = wxcpt.VerifyURL(msg_signature, timestamp, nonce, echostr);
		} catch (AesException e) {
			e.printStackTrace();
		}
		if (result == null) {
			result = ProviderConstantUtils.token;
		}
		out.print(result);
		out.close();
		out = null;
	}

	/**
	 * 确认请求来自微信服务器 <暂时不用>
	 */
	@RequestMapping(value = "msg", method = RequestMethod.POST)
	public void doPOSTMessage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, AesException {

		System.out.println("callback-doPost");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// 2.调用消息业务类接收消息、处理消息
		MessageCompanyService msgsv = new MessageCompanyService();
		String respMessage = msgsv.getEncryptRespMessage(request);

		// 处理表情
		// String respMessage = CoreService.processRequest_emoj(request);
		// 处理图文消息
		// String respMessage = Test_NewsService.processRequest(request);

		// 3.响应消息
		PrintWriter out = response.getWriter();
		out.print(respMessage);
		out.close();
	}
}
