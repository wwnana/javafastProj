package com.javafast.modules.hr.api;

import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.HttpRequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Calendar;
import java.util.List;

public class WxCheckInAPI {

    private static final Logger logger = LoggerFactory.getLogger(WxCheckInAPI.class);
    private static String check_in_rule_url = "https://qyapi.weixin.qq.com/cgi-bin/checkin/getcheckinoption?access_token=ACCESS_TOKEN";
    private static String check_in_data_rul = "https://qyapi.weixin.qq.com/cgi-bin/checkin/getcheckindata?access_token=ACCESS_TOKEN";

    /**
     * @param accessToken 调用接口凭证。必须使用打卡应用的Secret获取access_token
     * @param datetime    需要获取规则的日期当天0点的Unix时间戳
     * @param users       需要获取打卡规则的用户列表
     *                    {
     *                    "datetime": 1511971200,
     *                    "useridlist": ["james","paul"]
     *                    }
     * @return https://work.weixin.qq.com/api/doc#12423
     */
    public static String getCheckInOption(String accessToken, Long datetime, List<String> users) {
        // 1.拼装发送信息的url
        String requestUrl = check_in_rule_url.replace("ACCESS_TOKEN", accessToken);
        JSONObject jsonParam = new JSONObject();
        jsonParam.put("datetime", datetime);
        jsonParam.put("useridlist", users);
        // 2.将信息对象转换成json字符串
        String jsonText = jsonParam.toJSONString();
        logger.info("请求内容{}", jsonText);

        //3.调用接口发送消息
        JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonText);
        return jsonObject.toJSONString();
    }

    /***
     * 获取打卡数据
     * @param accessToken 调用接口凭证。必须使用打卡应用的Secret获取access_token
     * @param opencheckindatatype 打卡类型。1：上下班打卡；2：外出打卡；3：全部打卡
     * @param starttime 获取打卡记录的开始时间。Unix时间戳
     * @param endtime 获取打卡记录的结束时间。Unix时间戳
     * @param users 需要获取打卡记录的用户列表
     * {
     *    "opencheckindatatype": 3,
     *    "starttime": 1492617600,
     *    "endtime": 1492790400,
     *    "useridlist": ["james","paul"]
     * }
     * @return https://work.weixin.qq.com/api/doc#11196
     */
    public static String getCheckInData(String accessToken, Integer opencheckindatatype,
                                        Long starttime, Long endtime, List<String> users) {
        // 1.拼装发送信息的url
        String requestUrl = check_in_data_rul.replace("ACCESS_TOKEN", accessToken);
        JSONObject jsonParam = new JSONObject();

        jsonParam.put("opencheckindatatype", opencheckindatatype);
        jsonParam.put("starttime", starttime);
        jsonParam.put("endtime", endtime);
        jsonParam.put("useridlist", users);
        // 2.将信息对象转换成json字符串
        String jsonText = jsonParam.toJSONString();
        logger.info("请求内容{}", jsonText);

        //3.调用接口发送消息
        JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonText);
        return jsonObject.toJSONString();
    }

    public static Long getTodayZeroUnixTime(){
        // TODO 自动生成的方法存根
        Calendar c = Calendar.getInstance();
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MINUTE, 0);
        c.set(Calendar.SECOND, 0);
        c.set(Calendar.MILLISECOND, 0);
        Long today=c.getTimeInMillis()/1000;
        return today;
    }

}

