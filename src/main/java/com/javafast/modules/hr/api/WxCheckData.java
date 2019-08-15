package com.javafast.modules.hr.api;

import java.io.Serializable;
import java.util.List;

/***
 * 微信考勤打卡对象
 */
public class WxCheckData extends WxCheckBase implements Serializable {


    private List<CheckindataBean> checkindata;

    public List<CheckindataBean> getCheckindata() {
        return checkindata;
    }

    public void setCheckindata(List<CheckindataBean> checkindata) {
        this.checkindata = checkindata;
    }

    public static class CheckindataBean {
        /**
         * checkin_time : 1531011600
         * checkin_type : 上班打卡
         * wifiname :
         * notes :
         * location_detail :
         * exception_type : 未打卡
         * location_title :
         * wifimac :
         * mediaids : []
         * userid : ShiYiHong
         * groupname : 打卡
         */

        private int checkin_time;
        private String checkin_type;
        private String wifiname;
        private String notes;
        private String location_detail;
        private String exception_type;
        private String location_title;
        private String wifimac;
        private String userid;
        private String groupname;
        private List<String> mediaids;

        public int getCheckin_time() {
            return checkin_time;
        }

        public void setCheckin_time(int checkin_time) {
            this.checkin_time = checkin_time;
        }

        public String getCheckin_type() {
            return checkin_type;
        }

        public void setCheckin_type(String checkin_type) {
            this.checkin_type = checkin_type;
        }

        public String getWifiname() {
            return wifiname;
        }

        public void setWifiname(String wifiname) {
            this.wifiname = wifiname;
        }

        public String getNotes() {
            return notes;
        }

        public void setNotes(String notes) {
            this.notes = notes;
        }

        public String getLocation_detail() {
            return location_detail;
        }

        public void setLocation_detail(String location_detail) {
            this.location_detail = location_detail;
        }

        public String getException_type() {
            return exception_type;
        }

        public void setException_type(String exception_type) {
            this.exception_type = exception_type;
        }

        public String getLocation_title() {
            return location_title;
        }

        public void setLocation_title(String location_title) {
            this.location_title = location_title;
        }

        public String getWifimac() {
            return wifimac;
        }

        public void setWifimac(String wifimac) {
            this.wifimac = wifimac;
        }

        public String getUserid() {
            return userid;
        }

        public void setUserid(String userid) {
            this.userid = userid;
        }

        public String getGroupname() {
            return groupname;
        }

        public void setGroupname(String groupname) {
            this.groupname = groupname;
        }

        public List<String> getMediaids() {
            return mediaids;
        }

        public void setMediaids(List<String> mediaids) {
            this.mediaids = mediaids;
        }
    }
}
