package com.javafast.common.utils;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.lang3.time.DateFormatUtils;

/**
 * 日期工具类, 继承org.apache.commons.lang.time.DateUtils类
 */
public class DateUtils extends org.apache.commons.lang3.time.DateUtils {

	private static String[] parsePatterns = { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM",
			"yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm", "yyyy/MM", "yyyy.MM.dd", "yyyy.MM.dd HH:mm:ss",
			"yyyy.MM.dd HH:mm", "yyyy.MM" };

	/**
	 * 得到当前日期字符串 格式（yyyy-MM-dd）
	 */
	public static String getDate() {
		return getDate("yyyy-MM-dd");
	}

	/**
	 * 得到当前日期字符串 格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
	 */
	public static String getDate(String pattern) {
		return DateFormatUtils.format(new Date(), pattern);
	}

	/**
	 * 得到日期字符串 默认格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
	 */
	public static String formatDate(Date date, Object... pattern) {
		String formatDate = null;
		if (pattern != null && pattern.length > 0) {
			formatDate = DateFormatUtils.format(date, pattern[0].toString());
		} else {
			formatDate = DateFormatUtils.format(date, "yyyy-MM-dd");
		}
		return formatDate;
	}

	/**
	 * 得到日期时间字符串，转换格式（yyyy-MM-dd HH:mm:ss）
	 */
	public static String formatDateTime(Date date) {
		return formatDate(date, "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 得到当前时间字符串 格式（HH:mm:ss）
	 */
	public static String getTime() {
		return formatDate(new Date(), "HH:mm:ss");
	}

	/**
	 * 得到当前日期和时间字符串 格式（yyyy-MM-dd HH:mm:ss）
	 */
	public static String getDateTime() {
		return formatDate(new Date(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 得到当前年份字符串 格式（yyyy）
	 */
	public static String getYear() {
		return formatDate(new Date(), "yyyy");
	}

	/**
	 * 得到当前月份字符串 格式（MM）
	 */
	public static String getMonth() {
		return formatDate(new Date(), "MM");
	}

	/**
	 * 得到当天字符串 格式（dd）
	 */
	public static String getDay() {
		return formatDate(new Date(), "dd");
	}

	/**
	 * 得到当前星期字符串 格式（E）星期几
	 */
	public static String getWeek() {
		return formatDate(new Date(), "E");
	}
	
	/**
	 * 得到当前日期是星期几，星期一时weekday=1,weekday=0是星期天
	 * @return
	 */
	public static Integer getWeekDay() {
		Date today = new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(today);
        int weekday = c.get(Calendar.DAY_OF_WEEK) - 1;
        return weekday;
	}

	/**
	 * 日期型字符串转化为日期 格式 { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm",
	 * "yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm", "yyyy.MM.dd",
	 * "yyyy.MM.dd HH:mm:ss", "yyyy.MM.dd HH:mm" }
	 */
	public static Date parseDate(Object str) {
		if (str == null) {
			return null;
		}
		try {
			return parseDate(str.toString(), parsePatterns);
		} catch (ParseException e) {
			return null;
		}
	}

	/**
	 * 获取过去的天数
	 * 
	 * @param date
	 * @return
	 */
	public static long pastDays(Date date) {
		long t = new Date().getTime() - date.getTime();
		return t / (24 * 60 * 60 * 1000);
	}

	/**
	 * 获取过去的小时
	 * 
	 * @param date
	 * @return
	 */
	public static long pastHour(Date date) {
		long t = new Date().getTime() - date.getTime();
		return t / (60 * 60 * 1000);
	}

	/**
	 * 获取过去的分钟
	 * 
	 * @param date
	 * @return
	 */
	public static long pastMinutes(Date date) {
		long t = new Date().getTime() - date.getTime();
		return t / (60 * 1000);
	}

	/**
	 * 转换为时间（天,时:分:秒.毫秒）
	 * 
	 * @param timeMillis
	 * @return
	 */
	public static String formatDateTime(long timeMillis) {
		long day = timeMillis / (24 * 60 * 60 * 1000);
		long hour = (timeMillis / (60 * 60 * 1000) - day * 24);
		long min = ((timeMillis / (60 * 1000)) - day * 24 * 60 - hour * 60);
		long s = (timeMillis / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
		long sss = (timeMillis - day * 24 * 60 * 60 * 1000 - hour * 60 * 60 * 1000 - min * 60 * 1000 - s * 1000);
		return (day > 0 ? day + "," : "") + hour + ":" + min + ":" + s + "." + sss;
	}

	/**
	 * 获取两个日期之间的天数
	 * 
	 * @param before
	 * @param after
	 * @return
	 */
	public static double getDistanceOfTwoDate(Date before, Date after) {
		long beforeTime = before.getTime();
		long afterTime = after.getTime();
		return (afterTime - beforeTime) / (1000 * 60 * 60 * 24);
	}

	/**
	 * 获取N天后的时间 返回日期格式
	 * 
	 * @param day
	 *            天
	 * @return
	 */
	public static Date getDayAfterN(Integer day) {
		Date date = new Date();
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		if (day == 0) {
			return calendar.getTime();
		}
		calendar.add(Calendar.DATE, day);
		return calendar.getTime();
	}

	/**
	 * 获取N天后的时间 得到当前日期字符串 格式（yyyy-MM-dd）
	 * 
	 * @param day
	 * @return
	 */
	public static String getDayAfter(int day) {
		Date date = new Date();
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, day);
		return DateFormatUtils.format(calendar.getTime(), "yyyy-MM-dd");
	}

	/**
	 * 某个时间往后推N个月
	 * 
	 * @param date
	 * @param month
	 * @return
	 */
	public static Date getDayAfterMonth(Date date, Integer month) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		if (month == 0) {
			return calendar.getTime();
		}
		calendar.add(Calendar.MONTH, month); // 将当前日期加一个月
		return calendar.getTime();
	}

	/**
	 * 获取本周的开始时间 格式：yyyy-MM-dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getBeginDayOfWeekStr() {
		return formatDate(getBeginDayOfWeek(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 获取本周的结束时间 格式：yyyy-MM-dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getEndDayOfWeekStr() {
		return formatDate(getEndDayOfWeek(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 获取本月的开始时间 格式：yyyy-MM-dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getBeginDayOfMonthStr() {
		return formatDate(getBeginDayOfMonth(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 获取本月的结束时间 格式：yyyy-MM-dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getEndDayOfMonthStr() {
		return formatDate(getEndDayOfMonth(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 判断日期是否是工作日
	 * 
	 * @param date
	 * @return
	 */
	public static boolean isWorkDay(Date date) {
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		// 判断日期是否是周六周日
		if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY
				|| calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
			return false;
		}
		return true;
	}

	/**
	 * 获得当前日期是星期几
	 * 
	 * @param date
	 * @return
	 */
	public static String getWeekOfDate(Date date) {
		String[] weekDays = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
		if (w < 0)
			w = 0;
		return weekDays[w];
	}

	// 获取当天的开始时间
	public static Date getDayBegin() {
		Calendar cal = new GregorianCalendar();
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}

	// 获取当天的结束时间
	public static Date getDayEnd() {
		Calendar cal = new GregorianCalendar();
		cal.set(Calendar.HOUR_OF_DAY, 23);
		cal.set(Calendar.MINUTE, 59);
		cal.set(Calendar.SECOND, 59);
		return cal.getTime();
	}

	// 获取昨天的开始时间
	public static Date getBeginDayOfYesterday() {
		Calendar cal = new GregorianCalendar();
		cal.setTime(getDayBegin());
		cal.add(Calendar.DAY_OF_MONTH, -1);
		return getDayStartTime(cal.getTime());
	}

	// 获取昨天的结束时间
	public static Date getEndDayOfYesterDay() {
		Calendar cal = new GregorianCalendar();
		cal.setTime(getDayEnd());
		cal.add(Calendar.DAY_OF_MONTH, -1);
		return getDayEndTime(cal.getTime());
	}

	// 获取明天的开始时间
	public static Date getBeginDayOfTomorrow() {
		Calendar cal = new GregorianCalendar();
		cal.setTime(getDayBegin());
		cal.add(Calendar.DAY_OF_MONTH, 1);

		return cal.getTime();
	}

	// 获取明天的结束时间
	public static Date getEndDayOfTomorrow() {
		Calendar cal = new GregorianCalendar();
		cal.setTime(getDayEnd());
		cal.add(Calendar.DAY_OF_MONTH, 1);
		return cal.getTime();
	}

	// 获取本周的开始时间
	@SuppressWarnings("unused")
	public static Date getBeginDayOfWeek() {
		Date date = new Date();
		if (date == null) {
			return null;
		}
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int dayofweek = cal.get(Calendar.DAY_OF_WEEK);
		if (dayofweek == 1) {
			dayofweek += 7;
		}
		cal.add(Calendar.DATE, 2 - dayofweek);
		return getDayStartTime(cal.getTime());
	}

	// 获取本周的结束时间
	public static Date getEndDayOfWeek() {
		Calendar cal = Calendar.getInstance();
		cal.setTime(getBeginDayOfWeek());
		cal.add(Calendar.DAY_OF_WEEK, 6);
		Date weekEndSta = cal.getTime();
		return getDayEndTime(weekEndSta);
	}

	// 获取上周的开始时间
	@SuppressWarnings("unused")
	public static Date getBeginDayOfLastWeek() {
		Date date = new Date();
		if (date == null) {
			return null;
		}
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int dayofweek = cal.get(Calendar.DAY_OF_WEEK);
		if (dayofweek == 1) {
			dayofweek += 7;
		}
		cal.add(Calendar.DATE, 2 - dayofweek - 7);
		return getDayStartTime(cal.getTime());
	}

	// 获取上周的结束时间
	public static Date getEndDayOfLastWeek() {
		Calendar cal = Calendar.getInstance();
		cal.setTime(getBeginDayOfLastWeek());
		cal.add(Calendar.DAY_OF_WEEK, 6);
		Date weekEndSta = cal.getTime();
		return getDayEndTime(weekEndSta);
	}

	// 获取本月的开始时间
	public static Date getBeginDayOfMonth() {
		Calendar calendar = Calendar.getInstance();
		calendar.set(getNowYear(), getNowMonth() - 1, 1);
		return getDayStartTime(calendar.getTime());
	}
	
	// 获取本月的开始时间
	public static Date getBeginDayOfMonth(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(getNowYear(), getNowMonth() - 1, 1);
		return getDayStartTime(calendar.getTime());
	}

	// 获取本月的结束时间
	public static Date getEndDayOfMonth() {
		Calendar calendar = Calendar.getInstance();
		calendar.set(getNowYear(), getNowMonth() - 1, 1);
		int day = calendar.getActualMaximum(5);
		calendar.set(getNowYear(), getNowMonth() - 1, day);
		return getDayEndTime(calendar.getTime());
	}
	// 获取本月的结束时间
	public static Date getEndDayOfMonth(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(getNowYear(), getNowMonth() - 1, 1);
		int day = calendar.getActualMaximum(5);
		calendar.set(getNowYear(), getNowMonth() - 1, day);
		return getDayEndTime(calendar.getTime());
	}

	//获取上月的开始时间
    public static Date getBeginDayOfLastMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(getNowYear(), getNowMonth() - 2, 1);
        return getDayStartTime(calendar.getTime());
    }
    
    //获取上月的结束时间
    public static Date getEndDayOfLastMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(getNowYear(), getNowMonth() - 2, 1);
        int day = calendar.getActualMaximum(5);
        calendar.set(getNowYear(), getNowMonth() - 2, day);
        return getDayEndTime(calendar.getTime());
    }
    
    //获取本年的开始时间
    public static java.util.Date getBeginDayOfYear() { 
    	Calendar cal = Calendar.getInstance(); 
    	cal.set(Calendar.YEAR, getNowYear()); 
    	// cal.set 
    	cal.set(Calendar.MONTH, Calendar.JANUARY); 
    	cal.set(Calendar.DATE, 1); 
    	return getDayStartTime(cal.getTime()); 
    }
    
    //获取本年的结束时间
    public static java.util.Date getEndDayOfYear() { 
    	Calendar cal = Calendar.getInstance(); 
    	cal.set(Calendar.YEAR, getNowYear()); 
    	cal.set(Calendar.MONTH, Calendar.DECEMBER); 
    	cal.set(Calendar.DATE, 31); 
    	return getDayEndTime(cal.getTime()); 
    }
   
    //获取本季度的开始时间
    public static Date getCurrentQuarterStartTime() {  
        Calendar c = Calendar.getInstance();  
        int currentMonth = c.get(Calendar.MONTH) + 1;  
        SimpleDateFormat longSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
        SimpleDateFormat shortSdf = new SimpleDateFormat("yyyy-MM-dd");  
        Date now = null;  
        try {  
            if (currentMonth >= 1 && currentMonth <= 3)  
                c.set(Calendar.MONTH, 0);  
            else if (currentMonth >= 4 && currentMonth <= 6)  
                c.set(Calendar.MONTH, 3);  
            else if (currentMonth >= 7 && currentMonth <= 9)  
                c.set(Calendar.MONTH, 4);  
            else if (currentMonth >= 10 && currentMonth <= 12)  
                c.set(Calendar.MONTH, 9);  
            c.set(Calendar.DATE, 1);  
            now = longSdf.parse(shortSdf.format(c.getTime()) + " 00:00:00");  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return now;  
    } 
  
    //获取本季度的结束时间
    public static Date getCurrentQuarterEndTime() {  
        Calendar cal = Calendar.getInstance();  
        cal.setTime(getCurrentQuarterStartTime());  
        cal.add(Calendar.MONTH, 3);  
        return cal.getTime();  
    } 

	// 获取某个日期的开始时间
	public static Timestamp getDayStartTime(Date d) {
		Calendar calendar = Calendar.getInstance();
		if (null != d)
			calendar.setTime(d);
		calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), 0,
				0, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		return new Timestamp(calendar.getTimeInMillis());
	}

	// 获取某个日期的结束时间
	public static Timestamp getDayEndTime(Date d) {
		Calendar calendar = Calendar.getInstance();
		if (null != d)
			calendar.setTime(d);
		calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), 23,
				59, 59);
		calendar.set(Calendar.MILLISECOND, 999);
		return new Timestamp(calendar.getTimeInMillis());
	}

	// 获取今年是哪一年
	public static Integer getNowYear() {
		Date date = new Date();
		GregorianCalendar gc = (GregorianCalendar) Calendar.getInstance();
		gc.setTime(date);
		return Integer.valueOf(gc.get(1));
	}

	// 获取本月是哪一月
	public static int getNowMonth() {
		Date date = new Date();
		GregorianCalendar gc = (GregorianCalendar) Calendar.getInstance();
		gc.setTime(date);
		return gc.get(2) + 1;
	}

	// 两个日期相减得到的天数
	public static int getDiffDays(Date beginDate, Date endDate) {

		if (beginDate == null || endDate == null) {
			throw new IllegalArgumentException("getDiffDays param is null!");
		}

		long diff = (endDate.getTime() - beginDate.getTime()) / (1000 * 60 * 60 * 24);

		int days = new Long(diff).intValue();

		return days;
	}

	/**
	 * 获取当前时间戳
	 * 
	 * @return
	 */
	public static long getCurrentTimestamp() {
		return System.currentTimeMillis();
	}

	/**
	 * 获取过去的时间差，如XX分钟前
	 * 
	 * @param date
	 * @return
	 */
	public static String getTimeDiffer(Date date) {
		StringBuffer time = new StringBuffer();
		Date date2 = new Date();
		long temp = date2.getTime() - date.getTime();
		long days = temp / 1000 / 3600 / 24; // 相差天数
		if (days > 0) {
			time.append(days + "天前");
			return time.toString();
		}

		long temp1 = temp % (1000 * 3600 * 24);
		long hours = temp1 / 1000 / 3600; // 相差小时数
		if (days > 0 || hours > 0) {
			time.append(hours + "小时前");
			return time.toString();
		}
		long temp2 = temp1 % (1000 * 3600);
		long mins = temp2 / 1000 / 60; // 相差分钟数
		time.append(mins + "分钟前");
		if (mins == 0) {
			return "刚刚";
		}
		return time.toString();
	}
	
	/**
	 * 获取指定时间与当前时间的差值，如N天后
	 * @param date
	 * @return
	 */
	public static String getTimeAfterDiffer(Date date){
		StringBuffer time = new StringBuffer();
		Date date2 = new Date();
		long temp = date.getTime() - date2.getTime();
		long days = temp / 1000 / 3600 / 24; // 相差天数
		if (days > 0) {
			time.append(days + "天后");
			return time.toString();
		}
		if (days == 0) {
			time.append("近期");
			return time.toString();
		}
		return "";
	}
	
	/**
	 * 两个日期相差的天数
	 * @param date1
	 * @param date2
	 * @return
	 */
	public static int differentDaysByMillisecond(Date date1, Date date2){
        int days = (int) ((date2.getTime() - date1.getTime()) / (1000*3600*24));
        return days;
    }

	/**
	 * 时间戳转换成日期格式
	 * @param seconds 时间戳
	 * @return
	 */
	public static Date timeStamp2Date(long seconds) {
		return new Date(Long.valueOf(seconds + "000"));
	}

	/**
	 * 时间戳转换成字符串格式yyyy-MM-dd
	 * @param seconds
	 * @return
	 */
	public static String timeStamp2DateStr(String seconds) {
		return formatDate(new Date(Long.valueOf(seconds + "000")));
	}
	
	/**
	 * 时间戳转换成字符串格式yyyy-MM-dd HH:mm:ss
	 * @param seconds
	 * @return
	 */
	public static String timeStamp2DateTimeStr(String seconds) {
		return formatDate(new Date(Long.valueOf(seconds + "000")), "yyyy-MM-dd HH:mm:ss");
	}
	
	/**
	 * 日期转换成时间戳
	 * @param date_str
	 * @return
	 */
	public static Long date2TimeStamp(Date date) {
		return date.getTime() / 1000;
	}
	
	/**
	 * 获取两个日期之间的日期
	 * @param start 开始日期
	 * @param end 结束日期
	 * @return 日期集合
	 */
	public static List<Date> getBetweenDates(Date start, Date end) {
	    List<Date> result = new ArrayList<Date>();
	    Calendar tempStart = Calendar.getInstance();
	    tempStart.setTime(start);
	    tempStart.add(Calendar.DAY_OF_YEAR, 1);
	    
	    Calendar tempEnd = Calendar.getInstance();
	    tempEnd.setTime(end);
	    while (tempStart.before(tempEnd)) {
	        result.add(tempStart.getTime());
	        tempStart.add(Calendar.DAY_OF_YEAR, 1);
	    }
	    return result;
	}

	// 测试
	public static void main(String[] args) throws ParseException {
		
//		long seconds = 1532046600L;
//		System.out.println(timeStamp2Date(seconds));
//		
//		System.out.println(DateFormatUtils.format(timeStamp2Date(seconds), "yyyy-MM-dd HH:mm:ss"));
//		
		// System.out.println(formatDate(parseDate("2010/3/6")));
		// System.out.println(getDate("yyyy年MM月dd日 E"));
		// long time = new Date().getTime()-parseDate("2012-11-19").getTime();
		// System.out.println(time/(24*60*60*1000));

//		System.out.println("当天开始时间：" + formatDateTime(getDayBegin()));
//		System.out.println("当天结束时间：" + formatDateTime(getDayEnd()));
//		System.out.println("昨天开始时间：" + formatDateTime(getBeginDayOfYesterday()));
//		System.out.println("昨天结束时间：" + formatDateTime(getEndDayOfYesterDay()));
//		System.out.println("明天开始时间：" + formatDateTime(getBeginDayOfTomorrow()));
//		System.out.println("明天结束时间：" + formatDateTime(getEndDayOfTomorrow()));
//		System.out.println("本周开始时间：" + formatDateTime(getBeginDayOfWeek()));
//		System.out.println("本周结束时间：" + formatDateTime(getEndDayOfWeek()));
//		System.out.println("上周开始时间：" + formatDateTime(getBeginDayOfLastWeek()));
//		System.out.println("上周结束时间：" + formatDateTime(getEndDayOfLastWeek()));
//		System.out.println("本月开始时间：" + formatDateTime(getBeginDayOfMonth()));
//		System.out.println("本月结束时间：" + formatDateTime(getEndDayOfMonth()));
//
		System.out.println("本季度开始时间：" + formatDateTime(getCurrentQuarterStartTime()));
		System.out.println("本季度结束时间：" + formatDateTime(getCurrentQuarterEndTime()));
		
//		System.out.println("获取10天前的时间：" + getDayAfter(-10));
//		System.out.println("判断当前日期是否是工作日：" + isWorkDay(new Date()));
//
//		System.out.println("当前日期是星期几：" + getWeekOfDate(new Date()));
//		System.out.println("今天是星期几：" + getWeek());
//		System.out.println("昨天是星期几：" + getWeekOfDate(getBeginDayOfYesterday()));
//		System.out.println("明天是星期几：" + getWeekOfDate(getBeginDayOfTomorrow()));
//
//		getCurrentTimestamp();
		
		
//		System.out.println(DateFormatUtils.format(timeStamp2Date(1531040400), "yyyy-MM-dd HH:mm:ss"));
//		
//		String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(1531040400 * 1000));
//		System.out.println(date);
		//System.out.println(getDayBegin());
		//System.out.println(getDayEnd());
		System.out.println(getWeekDay());
		
		 
	}

}
