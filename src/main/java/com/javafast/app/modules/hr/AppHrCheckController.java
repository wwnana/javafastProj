package com.javafast.app.modules.hr;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.DateUtils;
import com.javafast.modules.hr.entity.HrCheckReportDetail;
import com.javafast.modules.hr.service.HrCheckReportDetailService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;

/**
 * 考勤，签到签退
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/hr/hrCheck")
public class AppHrCheckController {

	@Autowired
	private UserService userService;
	
	 @Autowired
	 private HrCheckReportDetailService hrCheckReportDetailService;
	 
	/**
	 * 签到签退初始数据
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getCheckByUserId", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getCheckByUserId(String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			String checkType = "0";
			
			//查询用户当天是否已经签到签退
			HrCheckReportDetail conHrCheckReportDetail = new HrCheckReportDetail();
			conHrCheckReportDetail.setIsApi(true);
			conHrCheckReportDetail.setAccountId(accountId);
			conHrCheckReportDetail.setUser(new User(userId));
			conHrCheckReportDetail.setCheckinStatus("0");
			conHrCheckReportDetail.setStartDate(DateUtils.getDayBegin());
			conHrCheckReportDetail.setEndDate(DateUtils.getDayEnd());
			List<HrCheckReportDetail> list = hrCheckReportDetailService.findList(conHrCheckReportDetail);
			
			//如果未签到
			if(list == null || list.size() == 0){
				checkType = "0";
			}
			
			//如果已经签到但未签退
			if(list != null && list.size() == 1){
				checkType = "1";
			}
			
			//如果已经签到签退
			if(list != null && list.size() > 1){
				checkType = "2";
			}
			
			//0：签到，1：签退，2：已签到签退
			json.put("checkType", checkType);
			System.out.println(checkType);
			json.put("code", "1");
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 提交
	 * @param checkType 考勤类型：0签到、1签退
	 * @param checkDate 时间
	 * @param locationTitle 地点
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String checkType, String checkDate, String locationTitle, String locationDetail, String notes, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			User user = userService.get(userId);
			
			//
			HrCheckReportDetail hrCheckReportDetail = new HrCheckReportDetail();
			hrCheckReportDetail.setCheckinDate(new Date());
			hrCheckReportDetail.setCheckinType(checkType);
			//hrCheckReportDetail.setCheckinTime(new Date().getTime());
			hrCheckReportDetail.setLocationTitle(locationTitle);
			hrCheckReportDetail.setLocationDetail(locationDetail);
			hrCheckReportDetail.setCheckinStatus("0");
			hrCheckReportDetail.setGroupname("默认");
			hrCheckReportDetail.setSdate(new Date());
			
			hrCheckReportDetail.setUser(user);
			hrCheckReportDetail.setOffice(user.getOffice());
			hrCheckReportDetail.setAccountId(accountId);
			hrCheckReportDetail.setCreateBy(new User(userId));
			hrCheckReportDetail.setUpdateBy(new User(userId));
			hrCheckReportDetailService.save(hrCheckReportDetail);
			
			json.put("checkType", Integer.parseInt(checkType)+1);
			json.put("code", "1");
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
