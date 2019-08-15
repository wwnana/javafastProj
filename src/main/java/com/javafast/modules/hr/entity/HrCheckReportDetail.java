package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;

/**
 * 每日打卡明细Entity
 *
 * @author javafast
 * @version 2018-07-09
 */
public class HrCheckReportDetail extends DataEntity<HrCheckReportDetail> {

    private static final long serialVersionUID = 1L;
    private String groupname;        // 所属规则
    private String userid;            // 微信用户id
    private String checkinType;        // 打卡类型(0上班、1下班)
    private String exceptionType;        // 异常类型
    private Integer checkinTime;        // 打卡时间（毫秒）
    private Date checkinDate;        // 打卡时间
    private String locationTitle;        // 地点
    private String locationDetail;        // 详细地址
    private String wifiname;        // 打卡的WIFI
    private String notes;        // 备注
    private String wifimac;        // 打卡的MAC地址/bssid
    private String mediaids;        // 打卡附件微信媒体编号
    private Date sdate;        // 打卡时间-日期 20180101
    //查询条件
    private String checkinStatus;        // 状态 0正常，1异常 (下载数据的时候需要本地判断后插入)
    private User user;                  //本地用户
    private Office office;                ////本地用户部门
   
    private Date startDate;
	private Date endDate;

    public static final  String EXCEPTIONTYPE_NOCHECK="未打卡";

    public HrCheckReportDetail() {
        super();
    }

    public HrCheckReportDetail(String id) {
        super(id);
    }

    public HrCheckReportDetail(User user, Date sdate) {
        this.user = user;
        this.sdate = sdate;
    }

    @Length(min = 1, max = 50, message = "所属规则长度必须介于 1 和 50 之间")
    @ExcelField(title = "所属规则", align = 2, sort = 1)
    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
    }

    @Length(min = 1, max = 50, message = "用户id长度必须介于 1 和 50 之间")
    @ExcelField(title = "用户id", align = 2, sort = 2)
    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    /**
     * 打卡类型。字符串，目前有：上班打卡，下班打卡，外出打卡
     * @return
     */
    @Length(min = 0, max = 50, message = "打卡类型长度必须介于 0 和 50 之间")
    @ExcelField(title = "打卡类型", align = 2, sort = 3)
    public String getCheckinType() {
        return checkinType;
    }

    public void setCheckinType(String checkinType) {
        this.checkinType = checkinType;
    }

    /**
     * 异常类型，字符串，包括：时间异常，地点异常，未打卡，wifi异常，非常用设备
     * @return
     */
    @Length(min = 0, max = 50, message = "异常类型长度必须介于 0 和 50 之间")
    @ExcelField(title = "异常类型", align = 2, sort = 4)
    public String getExceptionType() {
        return exceptionType;
    }

    public void setExceptionType(String exceptionType) {
        this.exceptionType = exceptionType;
    }

    @ExcelField(title = "打卡时间（毫秒）", align = 2, sort = 5)
    public Integer getCheckinTime() {
        return checkinTime;
    }

    public void setCheckinTime(Integer checkinTime) {
        this.checkinTime = checkinTime;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @ExcelField(title = "打卡日期", align = 2, sort = 6)
    public Date getCheckinDate() {
        return checkinDate;
    }

    public void setCheckinDate(Date checkinDate) {
        this.checkinDate = checkinDate;
    }

    @Length(min = 0, max = 50, message = "地点长度必须介于 0 和 50 之间")
    @ExcelField(title = "地点", align = 2, sort = 7)
    public String getLocationTitle() {
        return locationTitle;
    }

    public void setLocationTitle(String locationTitle) {
        this.locationTitle = locationTitle;
    }

    @Length(min = 0, max = 64, message = "详细地址长度必须介于 0 和 64 之间")
    @ExcelField(title = "详细地址", align = 2, sort = 8)
    public String getLocationDetail() {
        return locationDetail;
    }

    public void setLocationDetail(String locationDetail) {
        this.locationDetail = locationDetail;
    }

    @Length(min = 0, max = 20, message = "打卡的WIFI长度必须介于 0 和 20 之间")
    @ExcelField(title = "打卡的WIFI", align = 2, sort = 9)
    public String getWifiname() {
        return wifiname;
    }

    public void setWifiname(String wifiname) {
        this.wifiname = wifiname;
    }

    @Length(min = 0, max = 50, message = "备注长度必须介于 0 和 50 之间")
    @ExcelField(title = "备注", align = 2, sort = 10)
    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Length(min = 0, max = 50, message = "打卡的MAC地址/bssid长度必须介于 0 和 50 之间")
    @ExcelField(title = "打卡的MAC地址/bssid", align = 2, sort = 11)
    public String getWifimac() {
        return wifimac;
    }

    public void setWifimac(String wifimac) {
        this.wifimac = wifimac;
    }

    @Length(min = 0, max = 200, message = "打卡附件微信媒体编号长度必须介于 0 和 200 之间")
    @ExcelField(title = "打卡附件微信媒体编号", align = 2, sort = 12)
    public String getMediaids() {
        return mediaids;
    }

    public void setMediaids(String mediaids) {
        this.mediaids = mediaids;
    }

    @Length(min = 0, max = 1, message = "状态长度必须介于 0 和 1 之间")
    @ExcelField(title = "状态", dictType = "checkin_status", align = 2, sort = 14)
    public String getCheckinStatus() {
        return checkinStatus;
    }

    public void setCheckinStatus(String checkinStatus) {
        this.checkinStatus = checkinStatus;
    }


    public Date getSdate() {
        return sdate;
    }

    public void setSdate(Date sdate) {
        this.sdate = sdate;
    }


    @ExcelField(title = "姓名", fieldType = User.class, value = "user.name", align = 2, sort = 0)
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}


}