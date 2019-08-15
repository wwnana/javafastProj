package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 打卡规则表Entity
 * @author javafast
 * @version 2018-07-08
 */
public class HrCheckRule extends DataEntity<HrCheckRule> {
	
	private static final long serialVersionUID = 1L;
	private String groupType;		// 打卡规则类型。1：固定时间上下班；2：按班次上下班；3：自由上下班
	private String groupId;		// 打卡规则id
	private String groupname;		// 打卡名称
	private String workdays;		// 打卡日期
	private Integer flexTime;		// 弹性时间
	private Boolean noneedOffwork;		// 下班不需要打卡
	private Integer limitAheadtime;		// 打卡时间限制
	private String checkintime;		// 打卡时间
	private String speOffdays;		// 不需要打卡的时间Json
	private String speWorkdays;//需要打卡的JSON
	private Boolean syncHolidays;		// 同步节假日
	private Boolean needPhoto;		// 拍照打卡
	private String wifimacInfos;		// wifi信息
	private Boolean noteCanUseLocalPic;		// 是否备注时允许上传本地图片
	private Boolean allowCheckinOffworkday;		// 是否非工作日允许打卡
	private Boolean allowApplyOffworkday;		// 补卡申请
	private String locInfos;		// 位置打卡地点信息json
	
	public HrCheckRule() {
		super();
	}

	public HrCheckRule(String id){
		super(id);
	}

	@Length(min=0, max=2, message="打卡规则类型。1：固定时间上下班；2：按班次上下班；3：自由上下班长度必须介于 0 和 2 之间")
	@ExcelField(title="打卡规则类型。1：固定时间上下班；2：按班次上下班；3：自由上下班", dictType="", align=2, sort=1)
	public String getGroupType() {
		return groupType;
	}

	public void setGroupType(String groupType) {
		this.groupType = groupType;
	}
	
	@Length(min=1, max=64, message="打卡规则id长度必须介于 1 和 64 之间")
	@ExcelField(title="打卡规则id", align=2, sort=2)
	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	
	@Length(min=1, max=64, message="打卡名称长度必须介于 1 和 64 之间")
	@ExcelField(title="打卡名称", align=2, sort=3)
	public String getGroupname() {
		return groupname;
	}

	public void setGroupname(String groupname) {
		this.groupname = groupname;
	}
	
	@Length(min=0, max=64, message="打卡日期长度必须介于 0 和 64 之间")
	@ExcelField(title="打卡日期", dictType="", align=2, sort=4)
	public String getWorkdays() {
		return workdays;
	}

	public void setWorkdays(String workdays) {
		this.workdays = workdays;
	}
	
	@ExcelField(title="弹性时间", align=2, sort=5)
	public Integer getFlexTime() {
		return flexTime;
	}

	public void setFlexTime(Integer flexTime) {
		this.flexTime = flexTime;
	}
	
	@ExcelField(title="下班不需要打卡", align=2, sort=6)
	public Boolean getNoneedOffwork() {
		return noneedOffwork;
	}

	public void setNoneedOffwork(Boolean noneedOffwork) {
		this.noneedOffwork = noneedOffwork;
	}
	
	@ExcelField(title="打卡时间限制", align=2, sort=7)
	public Integer getLimitAheadtime() {
		return limitAheadtime;
	}

	public void setLimitAheadtime(Integer limitAheadtime) {
		this.limitAheadtime = limitAheadtime;
	}
	
	@Length(min=0, max=400, message="打卡时间长度必须介于 0 和 400 之间")
	@ExcelField(title="打卡时间", align=2, sort=8)
	public String getCheckintime() {
		return checkintime;
	}

	public void setCheckintime(String checkintime) {
		this.checkintime = checkintime;
	}

	public String getSpeWorkdays() {
		return speWorkdays;
	}

	public void setSpeWorkdays(String speWorkdays) {
		this.speWorkdays = speWorkdays;
	}

	@Length(min=0, max=400, message="不需要打卡的时间Json长度必须介于 0 和 400 之间")
	@ExcelField(title="不需要打卡的时间Json", align=2, sort=9)
	public String getSpeOffdays() {
		return speOffdays;
	}

	public void setSpeOffdays(String speOffdays) {
		this.speOffdays = speOffdays;
	}
	
	@Length(min=0, max=2, message="同步节假日长度必须介于 0 和 2 之间")
	@ExcelField(title="同步节假日", align=2, sort=10)
	public Boolean getSyncHolidays() {
		return syncHolidays;
	}

	public void setSyncHolidays(Boolean syncHolidays) {
		this.syncHolidays = syncHolidays;
	}
	
	@Length(min=0, max=2, message="拍照打卡长度必须介于 0 和 2 之间")
	@ExcelField(title="拍照打卡", align=2, sort=11)
	public Boolean getNeedPhoto() {
		return needPhoto;
	}

	public void setNeedPhoto(Boolean needPhoto) {
		this.needPhoto = needPhoto;
	}
	
	@Length(min=0, max=400, message="wifi信息长度必须介于 0 和 400 之间")
	@ExcelField(title="wifi信息", align=2, sort=12)
	public String getWifimacInfos() {
		return wifimacInfos;
	}

	public void setWifimacInfos(String wifimacInfos) {
		this.wifimacInfos = wifimacInfos;
	}
	
	@Length(min=0, max=2, message="是否备注时允许上传本地图片长度必须介于 0 和 2 之间")
	@ExcelField(title="是否备注时允许上传本地图片", align=2, sort=13)
	public Boolean getNoteCanUseLocalPic() {
		return noteCanUseLocalPic;
	}

	public void setNoteCanUseLocalPic(Boolean noteCanUseLocalPic) {
		this.noteCanUseLocalPic = noteCanUseLocalPic;
	}
	
	@Length(min=0, max=2, message="是否非工作日允许打卡长度必须介于 0 和 2 之间")
	@ExcelField(title="是否非工作日允许打卡", align=2, sort=14)
	public Boolean getAllowCheckinOffworkday() {
		return allowCheckinOffworkday;
	}

	public void setAllowCheckinOffworkday(Boolean allowCheckinOffworkday) {
		this.allowCheckinOffworkday = allowCheckinOffworkday;
	}
	
	@Length(min=0, max=2, message="补卡申请长度必须介于 0 和 2 之间")
	@ExcelField(title="补卡申请", align=2, sort=15)
	public Boolean getAllowApplyOffworkday() {
		return allowApplyOffworkday;
	}

	public void setAllowApplyOffworkday(Boolean allowApplyOffworkday) {
		this.allowApplyOffworkday = allowApplyOffworkday;
	}
	
	@Length(min=0, max=400, message="位置打卡地点信息json长度必须介于 0 和 400 之间")
	@ExcelField(title="位置打卡地点信息json", align=2, sort=16)
	public String getLocInfos() {
		return locInfos;
	}

	public void setLocInfos(String locInfos) {
		this.locInfos = locInfos;
	}
	
}