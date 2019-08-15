package com.javafast.modules.pay.utils;

/**
 * 支付宝支付基础配置类
 * @author syh
 *
 */
public class AlipayConfig {

	// 应用ID,您的APPID，收款账号既是您的APPID对应支付宝账号
	public static String app_id = "2018031402371516";
	
	// 商户私钥，您的PKCS8格式RSA2私钥
    public static String merchant_private_key = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCVMLjNu68k9wUc/wpCG5OljWf+UtlbKkWThbpN6dMlBXls5w7Tmm1gSh+Y1wFUD+zHhiCE1M6YYX/rFJrlEm/sNsJ0r6fixvxWnIOiHSg9JpoYBASyCLVC0l93G9/Tf1ykGafSy5wwhZdaL1ivYwavvx/VnqRqddnBK1GU52TXm97AFbTCfKZWuco6YvMKAzwB3leo9EQPs+P2lA/Jkrp7OFZ+nOCERyNqpXyRViTKfODAXAWlgtX8UKNebD6zmDdaHgUkmeCj1ef/OUnV8/xAPcv+E2I00Usy7Zwuk0AW27CqekiToBpoAKO9UYiNvqO+zHuG1KDQn4oUGifizOmFAgMBAAECggEAXcL1IjdmZ7DngcW3yLxUGqO4S9n9yJHUkFZnNDhT/txl589/PfW779wl54SYzSAFC5B8N38XKCV+o1ubzYO825O+ul77AEdWp4hOIkB43ZW5GobL/KgEYy6b2Nun2+AbdPa6xnw4eTY8XO2Mqw1tUl6nvzWo10+hvwleiFq0wdu2hC5HSsE4aib2Q4ZZ1FrvSKklRLP0l13S19XAaAnijVyi5annC2wS5y0NabBLu2yo22zr5sRRtQL54y1J7879WZuskM/gv4fD3ie/3Vas9eO8q32EP1HE2Q4J6RJByaWPyzZdoAY3BcaeAgaDtPmMrdkJm4aM2sapF2M3tmwOsQKBgQDqIANLFdc1ck7uV6DpohGoJGaHoI8sb1pt9p9ZomtoKUnv038is7J/sjPSEb/0cSrqC1794ufmvUa2EGHaTtbe/H36VIs6rFmPlUxPObG57wuS/kEoTaM4AzSdoQZv32O7DbrE99+ax98bR/witLHr7l0Ek/3OPxFUn4eaqz46+wKBgQCjISxfIGxwP+/XUhWc8V+3fosxVGOkbAAxq3jy7a8mOGDpedXjEvdzMf4hZPlguzkGl9COnIpsaorXXQ/njn385Wm0w3/VYaqd1x7J/8n229H3qvR2Vh/z195eJr8Kd9CB7Sl4FSb1i0/G6B3L6G5jljlFDD8qEr1MKohdLJhFfwKBgD9xQ1MybOnXutnNNxZ4S26TxpDUClgRKKEJpm6km5RTM+zgE+B0b1c5E9/F3Y1AqU9Ym3oS5aJaAfJOCCYfHQy5wO13wW65y18kJtSFHsryouFHMqLYPvVrsPNR8iuYji7e7pB3VslbhfKflAxXiKsVIXGfJLSh1HFo9VcNNkTHAoGAfol49cEc3GV8EbXmdfr1mExchENFl4D/FYhBJY8hUbBh3DlZo+5Oa9jXm+fLWTFhJrAUYssixL5QPIY/lAp/x+/ccw9C1a4QvqbjhyUW8JnK4SaGwlRELM3B+55qiiAuaNoiVLdzpPwPQedDVaxSFIWuntTFGkm29KH5bOzuoNkCgYATpFuyQ2jE/u/RUDsxxeeTYiOZaHaSlimjxT34k3CCgwBghwzmUTzMvHZg03fsi50wRLX7GxIxTKeY73xuXLmTfX5+vOrVoBIoDGqKo9mq0iPRl5HCeiNeptexrGqLCrxw1Wy2O9gDeR9ubU1VVL+DB6zd2ZGb9wqERWYsmKmPoQ==";
	
    // 支付宝公钥,查看地址：https://openhome.alipay.com/platform/keyManage.htm 对应APPID下的支付宝公钥。
    public static String alipay_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoNVx/EEafx426GvKS4aYkRdiBOCbziXy6fkaAzCyTBWX6OpiBJ5AI6YbSDf1/xvqlLO/iA77i/Im1wwPdJfeVycE4W/1sdD0E+sLuoufEEZq9l17bkvRLA0qvsPyepD044KDA1AOFozhltg4uMvqSmW4Itjy/dIgTXJenbSXMTCF0qhsrNnUdm+5Ul6bSg2RDALoAR7QFXwWOlW/Hvz0rGOE071DxLLkVFxjkMfK/cGoEs6eXrG9iLuQUJRIp7UOIdBahEeBfo74Wl5sld4851rj/po1g3uFD8Qbsl9GNr09YcmyepamVRIPKqslFQpt9TwEH+DPefnUeMVcYOCa5QIDAQAB";

    // 服务器异步通知页面路径  需http://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
 	public static String notify_url = "http://demo.javafast.cn/jf/pay/aliPay/payReceive";

 	// 页面跳转同步通知页面路径 需http://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
 	public static String return_url = "http://demo.javafast.cn/jf/pay/aliPay/returnPage";

 	// 签名方式
 	public static String sign_type = "RSA2";
 		
 	// 字符编码格式
 	public static String charset = "utf-8";
 	
 	// 支付宝网关
 	public static String gatewayUrl = "https://openapi.alipay.com/gateway.do";
}
