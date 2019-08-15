package com.javafast.modules.qws.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.qws.entity.QwsSuiteNotice;

/**
 * 指令回调消息DAO接口
 * @author javafast
 * @version 2018-06-12
 */
@MyBatisDao
public interface QwsSuiteNoticeDao extends CrudDao<QwsSuiteNotice> {
	
	public List<QwsSuiteNotice> findListForSuiteTicket();
}