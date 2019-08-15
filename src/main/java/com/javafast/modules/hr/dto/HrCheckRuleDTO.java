package com.javafast.modules.hr.dto;

import com.javafast.modules.hr.api.WxRuleInfo;
import com.javafast.modules.sys.entity.User;

import java.util.Date;
import java.util.List;

public class HrCheckRuleDTO {
    private List<User> userList;
    private boolean needPhoto;
    private Integer groupid;
    private boolean syncHolidays;
    private String  groupname;
    private Integer groupType;
    private boolean allowCheckinOffworkday;
    private String grouptype;
    private boolean allowApplyOffworkday;
    private boolean noteCanUseLocalPic;
    private Integer limitAheadtime;
    private Integer flexTime;
    private boolean noneedOffwork;
    private List<Integer> workdays;
    private List<CheckintimeBean> checkintime;
    private List<LocInfo> locInfos;
    private List<WifimacInfo> wifimacInfos;
    private List<SpecDay> specWorkDays;
    private List<SpecDay> specOffDays;

    public List<User> getUserList() {
        return userList;
    }

    public void setUserList(List<User> userList) {
        this.userList = userList;
    }

    public boolean isNeedPhoto() {
        return needPhoto;
    }

    public void setNeedPhoto(boolean needPhoto) {
        this.needPhoto = needPhoto;
    }

    public Integer getGroupid() {
        return groupid;
    }

    public void setGroupid(Integer groupid) {
        this.groupid = groupid;
    }

    public boolean isSyncHolidays() {
        return syncHolidays;
    }

    public void setSyncHolidays(boolean syncHolidays) {
        this.syncHolidays = syncHolidays;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
    }

    public Integer getGroupType() {
        return groupType;
    }

    public void setGroupType(Integer groupType) {
        this.groupType = groupType;
    }

    public boolean isAllowCheckinOffworkday() {
        return allowCheckinOffworkday;
    }

    public void setAllowCheckinOffworkday(boolean allowCheckinOffworkday) {
        this.allowCheckinOffworkday = allowCheckinOffworkday;
    }

    public String getGrouptype() {
        return grouptype;
    }

    public void setGrouptype(String grouptype) {
        this.grouptype = grouptype;
    }

    public boolean isAllowApplyOffworkday() {
        return allowApplyOffworkday;
    }

    public void setAllowApplyOffworkday(boolean allowApplyOffworkday) {
        this.allowApplyOffworkday = allowApplyOffworkday;
    }

    public boolean isNoteCanUseLocalPic() {
        return noteCanUseLocalPic;
    }

    public void setNoteCanUseLocalPic(boolean noteCanUseLocalPic) {
        this.noteCanUseLocalPic = noteCanUseLocalPic;
    }

    public Integer getLimitAheadtime() {
        return limitAheadtime;
    }

    public void setLimitAheadtime(Integer limitAheadtime) {
        this.limitAheadtime = limitAheadtime;
    }

    public Integer getFlexTime() {
        return flexTime;
    }

    public void setFlexTime(Integer flexTime) {
        this.flexTime = flexTime;
    }

    public boolean isNoneedOffwork() {
        return noneedOffwork;
    }

    public void setNoneedOffwork(boolean noneedOffwork) {
        this.noneedOffwork = noneedOffwork;
    }

    public List<Integer> getWorkdays() {
        return workdays;
    }

    public void setWorkdays(List<Integer> workdays) {
        this.workdays = workdays;
    }

    public List<CheckintimeBean> getCheckintime() {
        return checkintime;
    }

    public void setCheckintime(List<CheckintimeBean> checkintime) {
        this.checkintime = checkintime;
    }

    public List<LocInfo> getLocInfos() {
        return locInfos;
    }

    public void setLocInfos(List<LocInfo> locInfos) {
        this.locInfos = locInfos;
    }

    public List<WifimacInfo> getWifimacInfos() {
        return wifimacInfos;
    }

    public void setWifimacInfos(List<WifimacInfo> wifimacInfos) {
        this.wifimacInfos = wifimacInfos;
    }

    public List<SpecDay> getSpecWorkDays() {
        return specWorkDays;
    }

    public void setSpecWorkDays(List<SpecDay> specWorkDays) {
        this.specWorkDays = specWorkDays;
    }

    public List<SpecDay> getSpecOffDays() {
        return specOffDays;
    }

    public void setSpecOffDays(List<SpecDay> specOffDays) {
        this.specOffDays = specOffDays;
    }

    public static class CheckintimeBean {
        /**
         * remind_work_sec : 31800
         * off_work_sec : 61200
         * work_sec : 32400
         * remind_off_work_sec : 61200
         */

        private Integer remind_work_sec;
        private Integer off_work_sec;
        private Integer work_sec;
        private Integer remind_off_work_sec;

        public Integer getRemind_work_sec() {
            return remind_work_sec;
        }

        public void setRemind_work_sec(Integer remind_work_sec) {
            this.remind_work_sec = remind_work_sec;
        }

        public Integer getOff_work_sec() {
            return off_work_sec;
        }

        public void setOff_work_sec(Integer off_work_sec) {
            this.off_work_sec = off_work_sec;
        }

        public Integer getWork_sec() {
            return work_sec;
        }

        public void setWork_sec(Integer work_sec) {
            this.work_sec = work_sec;
        }

        public Integer getRemind_off_work_sec() {
            return remind_off_work_sec;
        }

        public void setRemind_off_work_sec(Integer remind_off_work_sec) {
            this.remind_off_work_sec = remind_off_work_sec;
        }



    }

    public static class LocInfo {
        private String loc_title;
        private Integer lng;
        private Integer distance;
        private String loc_detail;
        private Integer lat;

        public String getLoc_title() {
            return loc_title;
        }

        public void setLoc_title(String loc_title) {
            this.loc_title = loc_title;
        }

        public Integer getLng() {
            return lng;
        }

        public void setLng(Integer lng) {
            this.lng = lng;
        }

        public Integer getDistance() {
            return distance;
        }

        public void setDistance(Integer distance) {
            this.distance = distance;
        }

        public String getLoc_detail() {
            return loc_detail;
        }

        public void setLoc_detail(String loc_detail) {
            this.loc_detail = loc_detail;
        }

        public Integer getLat() {
            return lat;
        }

        public void setLat(Integer lat) {
            this.lat = lat;
        }
    }

    public static class WifimacInfo {
        /**
         * wifiname : VXIAO
         * wifimac : d0:ee:07:62:d3:20
         */

        private String wifiname;
        private String wifimac;

        public String getWifiname() {
            return wifiname;
        }

        public void setWifiname(String wifiname) {
            this.wifiname = wifiname;
        }

        public String getWifimac() {
            return wifimac;
        }

        public void setWifimac(String wifimac) {
            this.wifimac = wifimac;
        }
    }

    public static class SpecDay {
         private String notes;
         private Integer timestamp;
         private Date timestampDate;
         private List<CheckintimeSpec> checkintime;

         public String getNotes() {
             return notes;
         }

         public void setNotes(String notes) {
             this.notes = notes;
         }

         public Integer getTimestamp() {
             return timestamp;
         }

         public void setTimestamp(Integer timestamp) {
             this.timestamp = timestamp;
         }

         public List<CheckintimeSpec> getCheckintime() {
             return checkintime;
         }

         public void setCheckintime(List<CheckintimeSpec> checkintime) {
             this.checkintime = checkintime;
         }


     }

    public static class CheckintimeSpec {
         private Integer remind_work_sec;
         private Integer off_work_sec;
         private Integer work_sec;
         private Integer remind_off_work_sec;

         public Integer getRemind_work_sec() {
             return remind_work_sec;
         }

         public void setRemind_work_sec(Integer remind_work_sec) {
             this.remind_work_sec = remind_work_sec;
         }

         public Integer getOff_work_sec() {
             return off_work_sec;
         }

         public void setOff_work_sec(Integer off_work_sec) {
             this.off_work_sec = off_work_sec;
         }

         public Integer getWork_sec() {
             return work_sec;
         }

         public void setWork_sec(Integer work_sec) {
             this.work_sec = work_sec;
         }

         public Integer getRemind_off_work_sec() {
             return remind_off_work_sec;
         }

         public void setRemind_off_work_sec(Integer remind_off_work_sec) {
             this.remind_off_work_sec = remind_off_work_sec;
         }
    }
}


