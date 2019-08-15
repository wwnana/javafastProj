package com.javafast.modules.hr.utils;

import com.javafast.common.utils.SpringContextHolder;
import com.javafast.modules.hr.entity.HrResumeLog;
import com.javafast.modules.hr.service.HrResumeLogService;

/**
 * HR日志工具
 * @author syh
 *
 */
public class ResumeLogUtils {
	
	public static final String RESUME_ACTION_TYPE_UPLOAD = "1";//上传简历
	public static final String RESUME_ACTION_TYPE_INTERVIEW = "2";//邀约面试
	public static final String RESUME_ACTION_TYPE_OFFER = "3";//发送OFFER
	public static final String RESUME_ACTION_TYPE_ENTRY = "4";//入职
	public static final String RESUME_ACTION_TYPE_RESERVE = "5";//放弃
	public static final String RESUME_ACTION_TYPE_CHANGEPOSITION = "6";//调岗 
	public static final String RESUME_ACTION_TYPE_ADDSALARY = "7";//加薪
	public static final String RESUME_ACTION_TYPE_REWARD = "8";//激励
	public static final String RESUME_ACTION_TYPE_REGULAR = "9";//转正
	public static final String RESUME_ACTION_TYPE_QUIT = "30";//离职
	
	private static HrResumeLogService hrResumeLogService = SpringContextHolder.getBean(HrResumeLogService.class);
	
	/**
	 * 添加HR日志
	 * @param hrResumeId 简历编号
	 * @param type 事件类型：resume_action  1上传简历，2邀约面试，3：发送OFFER，4：入职    5：放弃   6：调岗   7：加薪  8：激励，9：转正，30：离职
	 * @param note
	 */
	public static void addResumeLog(String hrResumeId, String type, String note){
		
		HrResumeLog hrResumeLog = new HrResumeLog();
		hrResumeLog.setHrResumeId(hrResumeId);
		hrResumeLog.setType(type);
		hrResumeLog.setNote(note);
		hrResumeLogService.save(hrResumeLog);
	}
}
