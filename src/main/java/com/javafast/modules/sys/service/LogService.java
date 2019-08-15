package com.javafast.modules.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.modules.sys.dao.LogDao;
import com.javafast.modules.sys.entity.Log;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 日志Service
 */
@Service
@Transactional(readOnly = true)
public class LogService extends CrudService<LogDao, Log> {

	@Autowired
	private LogDao logDao;
		
	public Page<Log> findPage(Page<Log> page, Log log) {
		
		if(!UserUtils.getUser().isAdmin()){
			dataScopeFilter(log);//加入权限过滤
		}
		
		// 设置默认时间范围，默认当前月
		if (log.getBeginDate() == null){
			log.setBeginDate(DateUtils.setDays(DateUtils.parseDate(DateUtils.getDate()), 1));
		}
		if (log.getEndDate() == null){
			log.setEndDate(DateUtils.addMonths(log.getBeginDate(), 1));
		}
		
		return super.findPage(page, log);
		
	}
	
	/**
	 * 删除全部数据
	 * @param entity
	 */
	@Transactional(readOnly = false)
	public void empty(){
		Log log = new Log();
		log.setAccountId(UserUtils.getUser().getAccountId());
		logDao.empty(log);
	}
	
}
