package com.javafast.modules.pay.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.HashMap;
import java.util.Map;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;

import com.javafast.common.config.Global;
import com.javafast.common.json.AjaxJson;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.FileUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.pay.entity.PayRechargeOrder;
import com.javafast.modules.pay.entity.PayWxpayLog;
import com.javafast.modules.pay.service.PayRechargeOrderService;
import com.javafast.modules.pay.service.PayWxpayLogService;
import com.javafast.modules.pay.utils.WxPayConfig;
import com.javafast.api.pay.util.HttpUtil;
import com.javafast.api.pay.wxpay.WXPayUtil;
import com.javafast.modules.tools.utils.TwoDimensionCode;

/**
 * 微信支付控制器
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/wxPay")
public class WxPayController extends BaseController {
	
	@Autowired
	private PayRechargeOrderService payRechargeOrderService;
	
	@Autowired
	private PayWxpayLogService payWxpayLogService;
	
	/**
	 * 扫码支付  下单，返回二维码链接
	 * @param orderId 商户订单号
	 * @param totalFee 订单总金额，单位为分
	 * @param body 商品描述
	 * @return 二维码链接
	 */
    public String doUnifiedOrder(String orderId, int totalFee, String body) {
    	
        HashMap<String, String> data = new HashMap<String, String>();
        data.put("appid", WxPayConfig.appid);//公众账号ID
        data.put("mch_id", WxPayConfig.mch_id);//商户号
        data.put("nonce_str", WXPayUtil.generateUUID());//随机字符串
        data.put("body", body);//商品描述
        data.put("out_trade_no", orderId);//商户订单号
        //data.put("device_info", "WEB");//设备号 PC网页或公众号内支付可以传"WEB"
        //data.put("fee_type", "CNY"); //标价币种  默认人民币：CNY
        data.put("total_fee", totalFee+"");//订单总金额，单位为分
        data.put("spbill_create_ip", "39.108.212.118");//终端IP  APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        data.put("notify_url", WxPayConfig.notify_url);//通知地址  异步接收微信支付结果通知的回调地址，通知url必须为外网可访问的url，不能携带参数。
        data.put("trade_type", "NATIVE");//交易类型 NATIVE 扫码支付
        //data.put("product_id", orderId);//商品ID，非必填

        try {

        	//签名
            String sign = WXPayUtil.generateSignature(data, WxPayConfig.key);
            data.put("sign", sign);
            
            //将Map转换为XML格式的字符串
            String requestXML = WXPayUtil.mapToXml(data);  

            //发送post请求
            String resXml = HttpUtil.postData(WxPayConfig.UFDODER_URL, requestXML); 

            System.out.println(resXml);  
            
            //XML格式字符串转换为Map
            Map map = WXPayUtil.xmlToMap(resXml);  
            String return_code = (String) map.get("return_code");  
            if("SUCCESS".equals(return_code)){
            	
            	String result_code = (String) map.get("result_code");  
                if("SUCCESS".equals(result_code)){
                	
                	String prepay_id = (String) map.get("prepay_id");  //预支付交易会话标识  微信生成的预支付会话标识，用于后续接口调用中使用，该值有效期为2小时
                    
                    //二维码链接 trade_type为NATIVE时有返回，用于生成二维码，展示给用户进行扫码支付
                    String urlCode = (String) map.get("code_url");  
                    
                    System.out.println(urlCode);  
                    return urlCode;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
	 * 生成微信支付二维码
	 * @param request
	 * @param orderId 订单号
	 * @return
	 */
	@RequestMapping(value="createWxPayCode")
	@ResponseBody
	public AjaxJson createWxPayCode(HttpServletRequest request, String orderId, String notes){
		AjaxJson j = new AjaxJson();
		
			try {
				
				//从数据库取出充值订单
				PayRechargeOrder t = payRechargeOrderService.get(orderId);
				int caseFee = t.getAmount().multiply(new BigDecimal(100)).intValue();
				String body = notes;
				
				//图片文件输出路径
				String realPath = Global.getConfig("userfiles.wxpaydir");
				FileUtils.createDirectory(realPath);//如果目录不存在，则创建目录
				
				String name= orderId + ".png"; //此处二维码的图片名
				String filePath = realPath +"/"+ name;  //存放路径
				
				//扫码支付  下单，返回二维码链接
				String urlCode = doUnifiedOrder(orderId, caseFee, body);
				if(StringUtils.isNotBlank(urlCode)){
					
					//生成二维码
					TwoDimensionCode.encoderQRCode(urlCode, filePath, "png");//执行生成二维码
					
					//二维码访问地址
					String fileUrl = Global.getConfig("userfiles.wxpayurl") +"/"+ name;

					j.setSuccess(true);
					j.setMsg("微信支付二维码生成成功");
					j.put("filePath", fileUrl);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		return j;
	}
	
	/**
	 * 支付回调处理。 支付完成后，微信会把相关支付结果和用户信息发送到我们上面指定的那个回调地址，我们需要接收处理，并返回应答
	 * @param request
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "payReceive")
	public void payReceive(HttpServletRequest request, HttpServletResponse response) {
		
		try{
			
			//读取参数  
	        InputStream inputStream ;  
	        StringBuffer sb = new StringBuffer();  
	        inputStream = request.getInputStream();  
	        String s ;  
	        BufferedReader in = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));  
	        while ((s = in.readLine()) != null){  
	            sb.append(s);  
	        }  
	        in.close();  
	        inputStream.close();  
	  
	        //解析xml成map  
	        Map<String, String> map = new HashMap<String, String>();  
	        map = WXPayUtil.xmlToMap(sb.toString());  
	        
	        String resXml = "";//返回给微信的报文  
	        
	        //判断签名是否正确
	        if(WXPayUtil.isSignatureValid(map, WxPayConfig.key)){
	        	
	        	//判断状态码
	        	if("SUCCESS".equals((String)map.get("result_code"))){
	        		
	        		//通知参数
	        		String appid = (String)map.get("appid");  //公众账号ID
	        		String mch_id = (String)map.get("mch_id");  //商户号
	        		String result_code = (String)map.get("result_code");  //业务结果 SUCCESS/FAIL
	                String openid = (String)map.get("openid");  //用户标识
	                String transaction_id = (String)map.get("transaction_id");   //微信支付订单号 
	                String out_trade_no = (String)map.get("out_trade_no");   //商户订单号       
	                String trade_type = (String)map.get("trade_type");  //交易类型 JSAPI、NATIVE、APP
	                String bank_type = (String)map.get("bank_type");  //付款银行
	                BigDecimal total_fee = new BigDecimal(map.get("total_fee")).divide(new BigDecimal(100));  //订单总金额，单位为分
	                BigDecimal cash_fee = new BigDecimal(map.get("cash_fee")).divide(new BigDecimal(100));  //现金支付金额
	                
	                //判断支付结果
	            	if("SUCCESS".equals(result_code)){
	            		
	            		//创建微信支付记录
	            		PayWxpayLog payWxpayLog = new PayWxpayLog();
	            		payWxpayLog.setAppid(appid);
	            		payWxpayLog.setMchId(mch_id);
	            		payWxpayLog.setResultCode(result_code);
	            		payWxpayLog.setOpenid(openid);
	            		payWxpayLog.setTransactionId(transaction_id);
	            		payWxpayLog.setOutTradeNo(out_trade_no);
	            		payWxpayLog.setTradeType(trade_type);
	            		payWxpayLog.setBankType(bank_type);
	            		payWxpayLog.setTotalFee(total_fee);
	            		payWxpayLog.setCashFee(cash_fee);
	            		payWxpayLogService.save(payWxpayLog);
	            		
	            		//处理业务
	            		boolean result = payWxpayLogService.addWxpayLog(payWxpayLog);
	            		if(result){
	            			
	            			resXml = "<xml><return_code><![CDATA[SUCCESS]]></return_code>"  
	                                + "<return_msg><![CDATA[OK]]></return_msg></xml>";
	                		
	                		//处理业务完毕  处理后同步返回给微信
	                    	BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());  
	                        out.write(resXml.getBytes());
	                        out.flush();  
	                        out.close();
	            		}
	            	}
	        	}
	        }
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}