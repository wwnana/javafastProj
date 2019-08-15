package com.javafast.modules.qws.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.qws.entity.QwsSuiteNotice;
import com.javafast.modules.qws.dao.QwsSuiteNoticeDao;

/**
 * 指令回调消息Service
 * @author javafast
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class QwsSuiteNoticeService extends CrudService<QwsSuiteNoticeDao, QwsSuiteNotice> {

	public QwsSuiteNotice get(String id) {
		return super.get(id);
	}
	
	public List<QwsSuiteNotice> findList(QwsSuiteNotice qwsSuiteNotice) {
		return super.findList(qwsSuiteNotice);
	}
	
	public Page<QwsSuiteNotice> findPage(Page<QwsSuiteNotice> page, QwsSuiteNotice qwsSuiteNotice) {
		return super.findPage(page, qwsSuiteNotice);
	}
	
	@Transactional(readOnly = false)
	public void save(QwsSuiteNotice qwsSuiteNotice) {
		super.save(qwsSuiteNotice);
	}
	
	@Transactional(readOnly = false)
	public void delete(QwsSuiteNotice qwsSuiteNotice) {
		super.delete(qwsSuiteNotice);
	}
	
}