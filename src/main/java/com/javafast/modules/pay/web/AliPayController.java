package com.javafast.modules.pay.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.Map;
import com.javafast.common.web.BaseController;
import com.javafast.modules.pay.entity.PayAlipayLog;
import com.javafast.modules.pay.entity.PayRechargeOrder;
import com.javafast.modules.pay.service.PayAlipayLogService;
import com.javafast.modules.pay.service.PayRechargeOrderService;
import com.javafast.modules.pay.utils.AlipayConfig;
import java.math.BigDecimal;
import java.util.*;
import com.alipay.api.*;
import com.alipay.api.internal.util.*;
import com.alipay.api.request.AlipayTradePagePayRequest;

/**
 * 支付宝支付控制器
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/aliPay")
public class AliPayController extends BaseController {
	
	@Autowired
	private PayRechargeOrderService payRechargeOrderService;
	
	@Autowired
	private PayAlipayLogService payAlipayLogService;
	
	/**
	 * 支付宝支付
	 * @param id 充值单ID
	 * @param httpRequest
	 * @param httpResponse
	 * @throws Exception
	 */
	@RequestMapping(value = "toPay")
	public void toPay(String id, HttpServletRequest httpRequest, HttpServletResponse httpResponse) throws Exception {
		
		//从数据库取出充值订单
		PayRechargeOrder order = payRechargeOrderService.get(id);
		
		//获得初始化的AlipayClient
		AlipayClient alipayClient = new DefaultAlipayClient(AlipayConfig.gatewayUrl, AlipayConfig.app_id, AlipayConfig.merchant_private_key, "json", AlipayConfig.charset, AlipayConfig.alipay_public_key, AlipayConfig.sign_type);
		AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();//创建API对应的request
		
		alipayRequest.setReturnUrl(AlipayConfig.return_url);
		alipayRequest.setNotifyUrl(AlipayConfig.notify_url);//在公共参数中设置回跳和通知地址
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("out_trade_no", order.getId());//商户订单号，商户网站订单系统中唯一订单号，必填
		jsonObj.put("product_code", "FAST_INSTANT_TRADE_PAY");//销售产品码，必填，与支付宝签约的产品码名称。 注：目前仅支持FAST_INSTANT_TRADE_PAY
		jsonObj.put("total_amount", order.getAmount());//订单金额，必填
		jsonObj.put("subject", "JavaFast平台充值");//订单名称，必填
		jsonObj.put("body", "JavaFast平台充值");//商品描述，可空
		
		alipayRequest.setBizContent(jsonObj.toString());

		String form="";
		try {
			
			form = alipayClient.pageExecute(alipayRequest).getBody(); //调用SDK生成表单
		} catch (AlipayApiException e) {
			e.printStackTrace();
		}
		httpResponse.setContentType("text/html;charset=" + AlipayConfig.charset);
		httpResponse.getWriter().write(form);//直接将完整的表单html输出到页面
		httpResponse.getWriter().flush();
		httpResponse.getWriter().close();
	}

	/**
	 * 支付回调处理。 支付完成后，支付宝会把相关支付结果发送到我们上面指定的那个回调地址，我们需要接收处理，并返回应答
	 * @param request
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "payReceive")
	public void payReceive(HttpServletRequest request, HttpServletResponse response) {
		
		try{
			
			//获取支付宝POST过来反馈信息
			Map<String,String> params = new HashMap<String,String>();
			Map<String,String[]> requestParams = request.getParameterMap();
			for (Iterator<String> iter = requestParams.keySet().iterator(); iter.hasNext();) {
				String name = (String) iter.next();
				String[] values = (String[]) requestParams.get(name);
				String valueStr = "";
				for (int i = 0; i < values.length; i++) {
					valueStr = (i == values.length - 1) ? valueStr + values[i]
							: valueStr + values[i] + ",";
				}
				//乱码解决，这段代码在出现乱码时使用
				valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
				params.put(name, valueStr);
			}
			
			boolean signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.alipay_public_key, AlipayConfig.charset, AlipayConfig.sign_type); //调用SDK验证签名

			//——请在这里编写您的程序（以下代码仅作参考）——
			
			/* 实际验证过程建议商户务必添加以下校验：
			1、需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
			2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
			3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）
			4、验证app_id是否为该商户本身。
			*/
			
			if(signVerified) {//验证成功
				
				//商户订单号
				String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");
			
				//支付宝交易号
				String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");
				
				//卖家支付宝用户号
				String seller_id = new String(request.getParameter("seller_id").getBytes("ISO-8859-1"),"UTF-8");
			
				//交易状态  TRADE_SUCCESS:交易支付成功,TRADE_FINISHED：交易结束，不可退款
				String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
				
				//订单金额 本次交易支付的订单金额，单位为人民币（元），精确到小数点后2位
				String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"),"UTF-8");
				
				//实收金额  商家在交易中实际收到的款项，单位为元，精确到小数点后2位
				String receipt_amount = new String(request.getParameter("receipt_amount").getBytes("ISO-8859-1"),"UTF-8");
				
				//付款金额  用户在交易中支付的金额，单位为元，精确到小数点后2位
				String buyer_pay_amount = new String(request.getParameter("buyer_pay_amount").getBytes("ISO-8859-1"),"UTF-8");
				
				//交易付款时间 该笔交易的买家付款时间。格式为yyyy-MM-dd HH:mm:ss
				String gmt_payment = new String(request.getParameter("gmt_payment").getBytes("ISO-8859-1"),"UTF-8");
				
				//买家支付宝用户号
				String buyer_id = new String(request.getParameter("buyer_id").getBytes("ISO-8859-1"),"UTF-8");
				
				//交易退款时间
				String gmt_refund = new String(request.getParameter("gmt_refund").getBytes("ISO-8859-1"),"UTF-8");
				
				//总退款金额 
				String refund_fee = new String(request.getParameter("refund_fee").getBytes("ISO-8859-1"),"UTF-8");
				
				//商户业务号 商户业务ID，主要是退款通知中返回退款申请的流水号
				String out_biz_no = new String(request.getParameter("out_biz_no").getBytes("ISO-8859-1"),"UTF-8");
				
				//交易状态  TRADE_SUCCESS:交易支付成功
				if (trade_status.equals("TRADE_SUCCESS")){
					
					//处理业务   记录微信支付通知，并审单
					PayAlipayLog payAlipayLog = new PayAlipayLog();
					payAlipayLog.setOutTradeNo(out_trade_no);
					payAlipayLog.setTradeNo(trade_no);
					payAlipayLog.setSellerId(seller_id);
					payAlipayLog.setTradeStatus(trade_status);
					payAlipayLog.setTotalAmount(new BigDecimal(total_amount));
					payAlipayLog.setBuyerPayAmount(new BigDecimal(buyer_pay_amount));
					payAlipayLog.setReceiptAmount(new BigDecimal(receipt_amount));
					payAlipayLog.setGmtPayment(gmt_payment);
					payAlipayLog.setBuyerId(buyer_id);
					payAlipayLog.setGmtRefund(gmt_refund);
					payAlipayLog.setRefundFee(new BigDecimal(refund_fee));
					payAlipayLog.setOutBizNo(out_biz_no);
					payAlipayLogService.save(payAlipayLog);
					
					//处理业务
					boolean result = payAlipayLogService.addAlipayLog(payAlipayLog);
					if(result){
						
						//处理业务完毕  处理后同步返回给支付宝，支付宝不再发该笔交易的通知
						response.getWriter().println("success");
					}
				}else if(trade_status.equals("TRADE_FINISHED")){
					
					//退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
					
					
				}
			}else {//验证失败
				//out.println("fail");
				response.getWriter().println("fail");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * 支付完成后页面跳转同步通知页面
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "returnPage")
	public String returnPage(HttpServletRequest request, HttpServletResponse response) {
		
		return "modules/pay/alipayResult";
	}
}