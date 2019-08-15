package com.javafast.api.qywx.audit.entity;

import java.util.List;

import com.javafast.modules.hr.api.WxCheckBase;

public class WxApproval extends WxCheckBase{


    /**
     * count : 3
     * total : 5
     * next_spnum : 201704240001
     * data : [{"spname":"报销","apply_name":"报销测试","apply_org":"报销测试企业","approval_name":["审批人测试"],"notify_name":["抄送人测试"],"sp_status":1,"sp_num":201704200001,"mediaids":["WWCISP_G8PYgRaOVHjXWUWFqchpBqqqUpGj0OyR9z6WTwhnMZGCPHxyviVstiv_2fTG8YOJq8L8zJT2T2OvTebANV-2MQ"],"apply_time":1499153693,"apply_user_id":"testuser","expense":{"expense_type":1,"reason":"","item":[{"expenseitem_type":6,"time":1492617600,"sums":9900,"reason":""}]},"comm":{"apply_data":"{\"item-1492610773696\":{\"title\":\"abc\",\"type\":\"text\",\"value\":\"\"}}"}},{"spname":"请假","apply_name":"请假测试","apply_org":"请假测试企业","approval_name":["审批人测试"],"notify_name":["抄送人测试"],"sp_status":1,"sp_num":201704200004,"apply_time":1499153693,"apply_user_id":"testuser","leave":{"timeunit":0,"leave_type":4,"start_time":1492099200,"end_time":1492790400,"duration":144,"reason":""},"comm":{"apply_data":"{\"item-1492610773696\":{\"title\":\"abc\",\"type\":\"text\",\"value\":\"\"}}"}},{"spname":"自定义审批","apply_name":"自定义","apply_org":"自定义测试企业","approval_name":["自定义审批人"],"notify_name":["自定义抄送人"],"sp_status":1,"sp_num":201704240001,"apply_time":1499153693,"apply_user_id":"testuser","comm":{"apply_data":"{\"item-1492610773696\":{\"title\":\"abc\",\"type\":\"text\",\"value\":\"\"}}"}}]
     */

    private int count;//拉取的审批单个数，最大值为100，当total参数大于100时，可运用next_spnum参数进行多次拉取
    private int total;//时间段内的总审批单个数
    private long next_spnum;//拉取列表的最后一个审批单号
    private List<DataBean> data;

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public long getNext_spnum() {
        return next_spnum;
    }

    public void setNext_spnum(long next_spnum) {
        this.next_spnum = next_spnum;
    }

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * spname : 报销
         * apply_name : 报销测试
         * apply_org : 报销测试企业
         * approval_name : ["审批人测试"]
         * notify_name : ["抄送人测试"]
         * sp_status : 1
         * sp_num : 201704200001
         * mediaids : ["WWCISP_G8PYgRaOVHjXWUWFqchpBqqqUpGj0OyR9z6WTwhnMZGCPHxyviVstiv_2fTG8YOJq8L8zJT2T2OvTebANV-2MQ"]
         * apply_time : 1499153693
         * apply_user_id : testuser
         * expense : {"expense_type":1,"reason":"","item":[{"expenseitem_type":6,"time":1492617600,"sums":9900,"reason":""}]}
         * comm : {"apply_data":"{\"item-1492610773696\":{\"title\":\"abc\",\"type\":\"text\",\"value\":\"\"}}"}
         * leave : {"timeunit":0,"leave_type":4,"start_time":1492099200,"end_time":1492790400,"duration":144,"reason":""}
         */

        private String spname;//审批名称(请假，报销，自定义审批名称)
        private String apply_name;//申请人姓名
        private String apply_org;//申请人部门
        private int sp_status;//审批状态：1审批中；2 已通过；3已驳回；4已取消；6通过后撤销；10已支付
        private long sp_num;//审批单号
        private int apply_time;//审批单提交时间
        private String apply_user_id;//审批单提交者的userid
        private ExpenseBean expense;//报销信息
        private CommBean comm;//审批模板信息
        private LeaveBean leave;//请假信息
        private List<String> approval_name;//审批人姓名
        private List<String> notify_name;//抄送人姓名
        private List<String> mediaids;

        public String getSpname() {
            return spname;
        }

        public void setSpname(String spname) {
            this.spname = spname;
        }

        public String getApply_name() {
            return apply_name;
        }

        public void setApply_name(String apply_name) {
            this.apply_name = apply_name;
        }

        public String getApply_org() {
            return apply_org;
        }

        public void setApply_org(String apply_org) {
            this.apply_org = apply_org;
        }

        public int getSp_status() {
            return sp_status;
        }

        public void setSp_status(int sp_status) {
            this.sp_status = sp_status;
        }

        public long getSp_num() {
            return sp_num;
        }

        public void setSp_num(long sp_num) {
            this.sp_num = sp_num;
        }

        public int getApply_time() {
            return apply_time;
        }

        public void setApply_time(int apply_time) {
            this.apply_time = apply_time;
        }

        public String getApply_user_id() {
            return apply_user_id;
        }

        public void setApply_user_id(String apply_user_id) {
            this.apply_user_id = apply_user_id;
        }

        public ExpenseBean getExpense() {
            return expense;
        }

        public void setExpense(ExpenseBean expense) {
            this.expense = expense;
        }

        public CommBean getComm() {
            return comm;
        }

        public void setComm(CommBean comm) {
            this.comm = comm;
        }

        public LeaveBean getLeave() {
            return leave;
        }

        public void setLeave(LeaveBean leave) {
            this.leave = leave;
        }

        public List<String> getApproval_name() {
            return approval_name;
        }

        public void setApproval_name(List<String> approval_name) {
            this.approval_name = approval_name;
        }

        public List<String> getNotify_name() {
            return notify_name;
        }

        public void setNotify_name(List<String> notify_name) {
            this.notify_name = notify_name;
        }

        public List<String> getMediaids() {
            return mediaids;
        }

        public void setMediaids(List<String> mediaids) {
            this.mediaids = mediaids;
        }

        public static class ExpenseBean {
            /**
             * expense_type : 1
             * reason :
             * item : [{"expenseitem_type":6,"time":1492617600,"sums":9900,"reason":""}]
             */

            private int expense_type;//报销类型：1差旅费；2交通费；3招待费；4其他报销
            private String reason;//报销事由
            private List<ItemBean> item;

            public int getExpense_type() {
                return expense_type;
            }

            public void setExpense_type(int expense_type) {
                this.expense_type = expense_type;
            }

            public String getReason() {
                return reason;
            }

            public void setReason(String reason) {
                this.reason = reason;
            }

            public List<ItemBean> getItem() {
                return item;
            }

            public void setItem(List<ItemBean> item) {
                this.item = item;
            }

            public static class ItemBean {
                /**
                 * expenseitem_type : 6
                 * time : 1492617600
                 * sums : 9900
                 * reason :
                 */

                private int expenseitem_type;//费用类型：1飞机票；2火车票；3的士费；4住宿费；5餐饮费；6礼品费；7活动费；8通讯费；9补助；10其他 (历史单据字段，新申请单据不再提供)
                private int time;//发生时间，unix时间 (历史单据字段，新申请单据不再提供)
                private int sums;//费用金额，单位元 (历史单据字段，新申请单据不再提供)
                private String reason;//报销事由

                public int getExpenseitem_type() {
                    return expenseitem_type;
                }

                public void setExpenseitem_type(int expenseitem_type) {
                    this.expenseitem_type = expenseitem_type;
                }

                public int getTime() {
                    return time;
                }

                public void setTime(int time) {
                    this.time = time;
                }

                public int getSums() {
                    return sums;
                }

                public void setSums(int sums) {
                    this.sums = sums;
                }

                public String getReason() {
                    return reason;
                }

                public void setReason(String reason) {
                    this.reason = reason;
                }
            }
        }

        public static class CommBean {
            /**
             * apply_data : {"item-1492610773696":{"title":"abc","type":"text","value":""}}
             */

            private String apply_data;

            public String getApply_data() {
                return apply_data;
            }

            public void setApply_data(String apply_data) {
                this.apply_data = apply_data;
            }
        }

        public static class LeaveBean {
            /**
             * timeunit : 0
             * leave_type : 4
             * start_time : 1492099200
             * end_time : 1492790400
             * duration : 144
             * reason :
             */

            private int timeunit;//请假时间单位：0半天；1小时
            private int leave_type;//请假类型：1年假；2事假；3病假；4调休假；5婚假；6产假；7陪产假；8其他
            private int start_time;//请假开始时间，unix时间
            private int end_time;//请假结束时间，unix时间
            private int duration;//请假时长，单位小时
            private String reason;//请假事由

            public int getTimeunit() {
                return timeunit;
            }

            public void setTimeunit(int timeunit) {
                this.timeunit = timeunit;
            }

            public int getLeave_type() {
                return leave_type;
            }

            public void setLeave_type(int leave_type) {
                this.leave_type = leave_type;
            }

            public int getStart_time() {
                return start_time;
            }

            public void setStart_time(int start_time) {
                this.start_time = start_time;
            }

            public int getEnd_time() {
                return end_time;
            }

            public void setEnd_time(int end_time) {
                this.end_time = end_time;
            }

            public int getDuration() {
                return duration;
            }

            public void setDuration(int duration) {
                this.duration = duration;
            }

            public String getReason() {
                return reason;
            }

            public void setReason(String reason) {
                this.reason = reason;
            }
        }
    }
}
