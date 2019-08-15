package com.javafast.modules.iim.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.iim.dao.MailBoxDao;
import com.javafast.modules.iim.entity.MailBox;
import com.javafast.modules.iim.entity.MailPage;

/**
 * 收件箱Service
 */
@Service
@Transactional(readOnly = true)
public class MailBoxService extends CrudService<MailBoxDao, MailBox> {

	@Autowired
	private MailBoxDao mailBoxDao;
	public MailBox get(String id) {
		return super.get(id);
	}
	
	public List<MailBox> findList(MailBox mailBox) {
		return super.findList(mailBox);
	}
	
	public Page<MailBox> findPage(Page<MailBox> page, MailBox mailBox) {
		return super.findPage(page, mailBox);
	}
	
	@Transactional(readOnly = false)
	public void save(MailBox mailBox) {
		super.save(mailBox);
	}
	
	@Transactional(readOnly = false)
	public void delete(MailBox mailBox) {
		super.delete(mailBox);
	}
	
	public int getCount(MailBox mailBox) {
		return mailBoxDao.getCount(mailBox);
	}
	
}