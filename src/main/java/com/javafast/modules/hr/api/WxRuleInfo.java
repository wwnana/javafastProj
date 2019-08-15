package com.javafast.modules.hr.api;

import com.javafast.modules.sys.entity.User;

import java.util.List;

/***
 * 微信规则同步过的对象数据信息
 */
public class WxRuleInfo extends WxCheckBase {


    private List<InfoBean> info;

    public List<InfoBean> getInfo() {
        return info;
    }

    public void setInfo(List<InfoBean> info) {
        this.info = info;
    }

    public static class InfoBean {
        /**
         * userid : ShiYiHong
         * group : {"need_photo":false,"checkindate":[{"workdays":[1,2,3,4,5,6,0],"limit_aheadtime":0,"flex_time":0,"checkintime":[{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200}],"noneed_offwork":false}],"groupid":2,"loc_infos":[{"loc_title":"中山大道","lng":113376616,"distance":300,"loc_detail":"广东省广州市天河区中山大道","lat":23124560}],"spe_workdays":[{"notes":"好事","checkintime":[{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200},{"remind_work_sec":0,"off_work_sec":79200,"work_sec":64800,"remind_off_work_sec":0}],"timestamp":1531238400}],"sync_holidays":true,"groupname":"打卡","allow_checkin_offworkday":true,"grouptype":1,"spe_offdays":[{"notes":"好事过后","checkintime":[{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200}],"timestamp":1531324800}],"allow_apply_offworkday":true,"wifimac_infos":[{"wifiname":"VXIAO","wifimac":"d0:ee:07:62:d3:20"}],"note_can_use_local_pic":false}
         */

        private String userid;
        private GroupBean group;
        private List<User> userList;

        public String getUserid() {
            return userid;
        }

        public void setUserid(String userid) {
            this.userid = userid;
        }

        public GroupBean getGroup() {
            return group;
        }

        public void setGroup(GroupBean group) {
            this.group = group;
        }

        public List<User> getUserList() {
            return userList;
        }

        public void setUserList(List<User> userList) {
            this.userList = userList;
        }

        public static class GroupBean {
            /**
             * need_photo : false
             * checkindate : [{"workdays":[1,2,3,4,5,6,0],"limit_aheadtime":0,"flex_time":0,"checkintime":[{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200}],"noneed_offwork":false}]
             * groupid : 2
             * loc_infos : [{"loc_title":"中山大道","lng":113376616,"distance":300,"loc_detail":"广东省广州市天河区中山大道","lat":23124560}]
             * spe_workdays : [{"notes":"好事","checkintime":[{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200},{"remind_work_sec":0,"off_work_sec":79200,"work_sec":64800,"remind_off_work_sec":0}],"timestamp":1531238400}]
             * sync_holidays : true
             * groupname : 打卡
             * allow_checkin_offworkday : true
             * grouptype : 1
             * spe_offdays : [{"notes":"好事过后","checkintime":[{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200}],"timestamp":1531324800}]
             * allow_apply_offworkday : true
             * wifimac_infos : [{"wifiname":"VXIAO","wifimac":"d0:ee:07:62:d3:20"}]
             * note_can_use_local_pic : false
             */

            private boolean need_photo;
            private Integer groupid;
            private boolean sync_holidays;
            private String groupname;
            private boolean allow_checkin_offworkday;
            private Integer grouptype;
            private boolean allow_apply_offworkday;
            private boolean note_can_use_local_pic;
            private List<CheckindateBean> checkindate;
            private List<LocInfosBean> loc_infos;
            private List<SpeWorkdaysBean> spe_workdays;
            private List<SpeOffdaysBean> spe_offdays;
            private List<WifimacInfosBean> wifimac_infos;

            public boolean isNeed_photo() {
                return need_photo;
            }

            public void setNeed_photo(boolean need_photo) {
                this.need_photo = need_photo;
            }

            public Integer getGroupid() {
                return groupid;
            }

            public void setGroupid(Integer groupid) {
                this.groupid = groupid;
            }

            public boolean isSync_holidays() {
                return sync_holidays;
            }

            public void setSync_holidays(boolean sync_holidays) {
                this.sync_holidays = sync_holidays;
            }

            public String getGroupname() {
                return groupname;
            }

            public void setGroupname(String groupname) {
                this.groupname = groupname;
            }

            public boolean isAllow_checkin_offworkday() {
                return allow_checkin_offworkday;
            }

            public void setAllow_checkin_offworkday(boolean allow_checkin_offworkday) {
                this.allow_checkin_offworkday = allow_checkin_offworkday;
            }

            public Integer getGrouptype() {
                return grouptype;
            }

            public void setGrouptype(Integer grouptype) {
                this.grouptype = grouptype;
            }

            public boolean isAllow_apply_offworkday() {
                return allow_apply_offworkday;
            }

            public void setAllow_apply_offworkday(boolean allow_apply_offworkday) {
                this.allow_apply_offworkday = allow_apply_offworkday;
            }

            public boolean isNote_can_use_local_pic() {
                return note_can_use_local_pic;
            }

            public void setNote_can_use_local_pic(boolean note_can_use_local_pic) {
                this.note_can_use_local_pic = note_can_use_local_pic;
            }

            public List<CheckindateBean> getCheckindate() {
                return checkindate;
            }

            public void setCheckindate(List<CheckindateBean> checkindate) {
                this.checkindate = checkindate;
            }

            public List<LocInfosBean> getLoc_infos() {
                return loc_infos;
            }

            public void setLoc_infos(List<LocInfosBean> loc_infos) {
                this.loc_infos = loc_infos;
            }

            public List<SpeWorkdaysBean> getSpe_workdays() {
                return spe_workdays;
            }

            public void setSpe_workdays(List<SpeWorkdaysBean> spe_workdays) {
                this.spe_workdays = spe_workdays;
            }

            public List<SpeOffdaysBean> getSpe_offdays() {
                return spe_offdays;
            }

            public void setSpe_offdays(List<SpeOffdaysBean> spe_offdays) {
                this.spe_offdays = spe_offdays;
            }

            public List<WifimacInfosBean> getWifimac_infos() {
                return wifimac_infos;
            }

            public void setWifimac_infos(List<WifimacInfosBean> wifimac_infos) {
                this.wifimac_infos = wifimac_infos;
            }

            public static class CheckindateBean {
                /**
                 * workdays : [1,2,3,4,5,6,0]
                 * limit_aheadtime : 0
                 * flex_time : 0
                 * checkintime : [{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200}]
                 * noneed_offwork : false
                 */

                private Integer limit_aheadtime;
                private Integer flex_time;
                private boolean noneed_offwork;
                private List<Integer> workdays;
                private List<CheckintimeBean> checkintime;

                public Integer getLimit_aheadtime() {
                    return limit_aheadtime;
                }

                public void setLimit_aheadtime(Integer limit_aheadtime) {
                    this.limit_aheadtime = limit_aheadtime;
                }

                public Integer getFlex_time() {
                    return flex_time;
                }

                public void setFlex_time(Integer flex_time) {
                    this.flex_time = flex_time;
                }

                public boolean isNoneed_offwork() {
                    return noneed_offwork;
                }

                public void setNoneed_offwork(boolean noneed_offwork) {
                    this.noneed_offwork = noneed_offwork;
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
            }

            public static class LocInfosBean {
                /**
                 * loc_title : 中山大道
                 * lng : 113376616
                 * distance : 300
                 * loc_detail : 广东省广州市天河区中山大道
                 * lat : 23124560
                 */

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

            public static class SpeWorkdaysBean {
                /**
                 * notes : 好事
                 * checkintime : [{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200},{"remind_work_sec":0,"off_work_sec":79200,"work_sec":64800,"remind_off_work_sec":0}]
                 * timestamp : 1531238400
                 */

                private String notes;
                private Integer timestamp;
                private List<CheckintimeBeanX> checkintime;

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

                public List<CheckintimeBeanX> getCheckintime() {
                    return checkintime;
                }

                public void setCheckintime(List<CheckintimeBeanX> checkintime) {
                    this.checkintime = checkintime;
                }

                public static class CheckintimeBeanX {
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
            }

            public static class SpeOffdaysBean {
                /**
                 * notes : 好事过后
                 * checkintime : [{"remind_work_sec":31800,"off_work_sec":61200,"work_sec":32400,"remind_off_work_sec":61200}]
                 * timestamp : 1531324800
                 */

                private String notes;
                private Integer timestamp;
                private List<CheckintimeBeanXX> checkintime;

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

                public List<CheckintimeBeanXX> getCheckintime() {
                    return checkintime;
                }

                public void setCheckintime(List<CheckintimeBeanXX> checkintime) {
                    this.checkintime = checkintime;
                }

                public static class CheckintimeBeanXX {
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
            }

            public static class WifimacInfosBean {
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
        }
    }
}
