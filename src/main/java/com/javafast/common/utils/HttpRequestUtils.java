package com.javafast.common.utils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSONObject;

/**
 * HTTP请求工具类
 * 
 * @author JavaFast
 */
public class HttpRequestUtils {

	private static final Logger logger = LoggerFactory.getLogger(HttpRequestUtils.class);

	/**
	 * 发起http请求并获取结果
	 * 
	 * @param requestUrl
	 *            请求地址
	 * @param requestMethod
	 *            请求方式（GET、POST）
	 * @param outputStr
	 *            请求参数
	 * @return JSONObject(通过JSONObject.get(key)的方式获取json对象的属性值)
	 */
	public static JSONObject httpRequest(String requestUrl, String requestMethod, String outputStr) {

		JSONObject jsonObject = null;
		StringBuffer buffer = new StringBuffer();
		InputStream inputStream = null;
		InputStreamReader inputStreamReader = null;
		BufferedReader reader = null;

		try {

			logger.debug("[HTTP]", "http请求request:{},method:{},output{}",
					new Object[] { requestUrl, requestMethod, outputStr });

			// 建立连接
			URL url = new URL(requestUrl);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setConnectTimeout(3000);
			connection.setReadTimeout(30000);
			connection.setUseCaches(false);
			connection.setRequestMethod(requestMethod);

			// 请求参数
			if (outputStr != null) {
				OutputStream out = connection.getOutputStream();
				out.write(outputStr.getBytes("UTF-8"));
				out.close();
			}

			// 流处理
			inputStream = connection.getInputStream();
			inputStreamReader = new InputStreamReader(inputStream, "UTF-8");
			reader = new BufferedReader(inputStreamReader);
			String line;
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}

			// 关闭连接、释放资源
			reader.close();
			inputStreamReader.close();
			inputStream.close();
			inputStream = null;
			connection.disconnect();
			jsonObject = JSONObject.parseObject(buffer.toString());
		} catch (Exception e) {

			logger.error("[HTTP]", "http请求error:{}", new Object[] { e.getMessage() });
		} finally {

			// 使用finally块来关闭输出流、输入流
			try {
				if (reader != null) {
					reader.close();
				}
				if (inputStreamReader != null) {
					inputStreamReader.close();
				}
				if (inputStream != null) {
					inputStream.close();
				}

			} catch (Exception ex) {
				ex.printStackTrace();
				logger.error("[HTTP]", "http请求error:{}", new Object[] { ex.getMessage() });
			}
		}
		return jsonObject;
	}

	/**
	 * 发起https请求并获取结果
	 * @param requestUrl
	 * @param requestMethod
	 * @param outputStr
	 * @return
	 */
	public static JSONObject httpsRequest(String requestUrl, String requestMethod, String outputStr) {

		JSONObject jsonObject = null;
		StringBuffer buffer = null;
		InputStream inputStream = null;
		InputStreamReader inputStreamReader = null;
		BufferedReader reader = null;

		try {

			// 创建SSLContext
			SSLContext sslContext = SSLContext.getInstance("SSL");
			TrustManager[] tm = { new MyX509TrustManager() };
			// 初始化
			sslContext.init(null, tm, new java.security.SecureRandom());
			;
			// 获取SSLSocketFactory对象
			SSLSocketFactory ssf = sslContext.getSocketFactory();
			URL url = new URL(requestUrl);
			HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setUseCaches(false);
			connection.setRequestMethod(requestMethod);
			// 设置当前实例使用的SSLSoctetFactory
			connection.setSSLSocketFactory(ssf);
			connection.connect();

			// 往服务器端写内容
			if (null != outputStr) {
				OutputStream os = connection.getOutputStream();
				os.write(outputStr.getBytes("utf-8"));
				os.close();
			}

			// 读取服务器端返回的内容
			inputStream = connection.getInputStream();
			inputStreamReader = new InputStreamReader(inputStream, "utf-8");
			reader = new BufferedReader(inputStreamReader);
			buffer = new StringBuffer();
			String line = null;
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}

			// 关闭连接、释放资源
			reader.close();
			inputStreamReader.close();
			inputStream.close();
			inputStream = null;
			connection.disconnect();
			jsonObject = JSONObject.parseObject(buffer.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			// 使用finally块来关闭输出流、输入流
			try {
				if (reader != null) {
					reader.close();
				}
				if (inputStreamReader != null) {
					inputStreamReader.close();
				}
				if (inputStream != null) {
					inputStream.close();
				}

			} catch (Exception ex) {
				ex.printStackTrace();
				logger.error("[HTTPS]", "https请求error:{}", new Object[] { ex.getMessage() });
			}
		}
		
		return jsonObject;
	}
}
