package com.javafast.common.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class IdUtils {

	private static String date ; 
	private static long orderNum = 0l;
	
	/**
	 * 单据编号
	 * @return
	 */
	public static synchronized String getId(){
		
		String str = new SimpleDateFormat("yyMMddHHmmss").format(new Date());
        if(date==null||!date.equals(str)){
            date = str;
            orderNum  = 0l;
        }  
        orderNum ++;
        long orderNo = Long.parseLong((date)) * 100;
        orderNo += orderNum;
        return orderNo+"";
	}
}
