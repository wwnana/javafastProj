package com.javafast.modules.hr.api;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class WxCheckInApply {


    /**
     * checkin-status : {"id":"checkin-status","title":"异常状态","validate":true,"un_print":false,"placeholder":"","type":"text","disabled":true,"value":"迟到打卡(15:13)","locked":true,"setvalue":"迟到打卡(15:13)","warning":""}
     * checkin-time : {"id":"checkin-time","title":"补卡时间","validate":true,"un_print":false,"placeholder":"","type":"datehour","value":"1531182600000","locked":true,"setvalue":1531182600000,"dateHourValue":1531182600000,"setIndex":[555,8,30],"warning":""}
     * applyBK : {"id":"applyBK","title":"补卡","validate":true,"un_print":true,"placeholder":"","type":"group","extra_type":"applyBK","locked":true,"value":[{"id":"checkin-status","title":"异常状态","validate":true,"un_print":false,"placeholder":"","type":"text","disabled":true,"value":"迟到打卡(15:13)","locked":true,"setvalue":"迟到打卡(15:13)","warning":""},{"id":"checkin-time","title":"补卡时间","validate":true,"un_print":false,"placeholder":"","type":"datehour","value":"1531182600000","locked":true,"setvalue":1531182600000,"dateHourValue":1531182600000,"setIndex":[555,8,30],"warning":""}],"index":"0","warning":""}
     * item-1497417335175 : {"id":"item-1497417335175","title":"补卡事由","validate":true,"un_print":false,"placeholder":"","type":"textarea","value":"早上自动打卡没打上","index":"1","warning":""}
     * item-1497513542396 : {"id":"item-1497513542396","title":"说明附件","validate":false,"un_print":true,"placeholder":"","type":"file","value":"","index":"2","warning":""}
     */

    @SerializedName("checkin-status")
    private CheckinBean checkinstatus;
    @SerializedName("checkin-time")
    private CheckinBean checkintime;
    private ApplyBKBean applyBK;

    public static class CheckinBean {
        /**
         * id : checkin-time
         * title : 补卡时间
         * validate : true
         * un_print : false
         * placeholder :
         * type : datehour
         * value : 1531182600000
         * locked : true
         * setvalue : 1531182600000
         * dateHourValue : 1531182600000
         * setIndex : [555,8,30]
         * warning :
         */

        private String id;
        private String title;
        private boolean validate;
        private boolean un_print;
        private String placeholder;
        private String type;
        private String value;
        private boolean locked;
        private long setvalue;
        private long dateHourValue;
        private String warning;
        private List<Integer> setIndex;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public boolean isValidate() {
            return validate;
        }

        public void setValidate(boolean validate) {
            this.validate = validate;
        }

        public boolean isUn_print() {
            return un_print;
        }

        public void setUn_print(boolean un_print) {
            this.un_print = un_print;
        }

        public String getPlaceholder() {
            return placeholder;
        }

        public void setPlaceholder(String placeholder) {
            this.placeholder = placeholder;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public boolean isLocked() {
            return locked;
        }

        public void setLocked(boolean locked) {
            this.locked = locked;
        }

        public long getSetvalue() {
            return setvalue;
        }

        public void setSetvalue(long setvalue) {
            this.setvalue = setvalue;
        }

        public long getDateHourValue() {
            return dateHourValue;
        }

        public void setDateHourValue(long dateHourValue) {
            this.dateHourValue = dateHourValue;
        }

        public String getWarning() {
            return warning;
        }

        public void setWarning(String warning) {
            this.warning = warning;
        }

        public List<Integer> getSetIndex() {
            return setIndex;
        }

        public void setSetIndex(List<Integer> setIndex) {
            this.setIndex = setIndex;
        }
    }

    public static class ApplyBKBean {
        /**
         * id : applyBK
         * title : 补卡
         * validate : true
         * un_print : true
         * placeholder :
         * type : group
         * extra_type : applyBK
         * locked : true
         * value : [{"id":"checkin-status","title":"异常状态","validate":true,"un_print":false,"placeholder":"","type":"text","disabled":true,"value":"迟到打卡(15:13)","locked":true,"setvalue":"迟到打卡(15:13)","warning":""},{"id":"checkin-time","title":"补卡时间","validate":true,"un_print":false,"placeholder":"","type":"datehour","value":"1531182600000","locked":true,"setvalue":1531182600000,"dateHourValue":1531182600000,"setIndex":[555,8,30],"warning":""}]
         * index : 0
         * warning :
         */

        private String id;
        private String title;
        private boolean validate;
        private boolean un_print;
        private String placeholder;
        private String type;
        private String extra_type;
        private boolean locked;
        private String index;
        private String warning;
        private List<CheckinBean> value;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public boolean isValidate() {
            return validate;
        }

        public void setValidate(boolean validate) {
            this.validate = validate;
        }

        public boolean isUn_print() {
            return un_print;
        }

        public void setUn_print(boolean un_print) {
            this.un_print = un_print;
        }

        public String getPlaceholder() {
            return placeholder;
        }

        public void setPlaceholder(String placeholder) {
            this.placeholder = placeholder;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getExtra_type() {
            return extra_type;
        }

        public void setExtra_type(String extra_type) {
            this.extra_type = extra_type;
        }

        public boolean isLocked() {
            return locked;
        }

        public void setLocked(boolean locked) {
            this.locked = locked;
        }

        public String getIndex() {
            return index;
        }

        public void setIndex(String index) {
            this.index = index;
        }

        public String getWarning() {
            return warning;
        }

        public void setWarning(String warning) {
            this.warning = warning;
        }

        public List<CheckinBean> getValue() {
            return value;
        }

        public void setValue(List<CheckinBean> value) {
            this.value = value;
        }


    }
}
