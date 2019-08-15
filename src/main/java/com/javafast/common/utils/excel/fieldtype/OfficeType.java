package com.javafast.common.utils.excel.fieldtype;

import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 部门字段类型转换
 * @author JavaFast
 */
public class OfficeType {

	/**
	 * 获取对象值（导入）
	 */
	public static Object getValue(String val) {
		for (Office e : UserUtils.getOfficeList()){
			if (StringUtils.trimToEmpty(val).equals(e.getName())){
				return e;
			}
		}
		return null;
	}

	/**
	 * 设置对象值（导出）
	 */
	public static String setValue(Object val) {
		if (val != null && ((Office)val).getName() != null){
			return ((Office)val).getName();
		}
		return "";
	}
}
