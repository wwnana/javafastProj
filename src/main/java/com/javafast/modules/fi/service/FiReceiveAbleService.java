/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.dao.FiReceiveAbleDao;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.fi.dao.FiReceiveBillDao;

/**
 * 应收款Service
 * @author javafast
 * @version 2017-07-14
 */
@Service
@Transactional(readOnly = true)
public class FiReceiveAbleService extends CrudService<FiReceiveAbleDao, FiReceiveAble> {

	@Autowired
	private FiReceiveBillDao fiReceiveBillDao;
	
	public FiReceiveAble get(String id) {
		FiReceiveAble fiReceiveAble = super.get(id);
		fiReceiveAble.setFiReceiveBillList(fiReceiveBillDao.findList(new FiReceiveBill(fiReceiveAble)));
		return fiReceiveAble;
	}
	
	public List<FiReceiveAble> findList(FiReceiveAble fiReceiveAble) {
		dataScopeFilter(fiReceiveAble);//加入数据权限过滤
		return super.findList(fiReceiveAble);
	}
	
	public Page<FiReceiveAble> findPage(Page<FiReceiveAble> page, FiReceiveAble fiReceiveAble) {
		dataScopeFilter(fiReceiveAble);//加入数据权限过滤
		return super.findPage(page, fiReceiveAble);
	}
	
	@Transactional(readOnly = false)
	public void save(FiReceiveAble fiReceiveAble) {
		super.save(fiReceiveAble);
		for (FiReceiveBill fiReceiveBill : fiReceiveAble.getFiReceiveBillList()){
			if (fiReceiveBill.getId() == null){
				continue;
			}
			if (FiReceiveBill.DEL_FLAG_NORMAL.equals(fiReceiveBill.getDelFlag())){
				if (StringUtils.isBlank(fiReceiveBill.getId())){
					fiReceiveBill.setFiReceiveAble(fiReceiveAble);
					fiReceiveBill.preInsert();
					fiReceiveBillDao.insert(fiReceiveBill);
				}else{
					fiReceiveBill.preUpdate();
					fiReceiveBillDao.update(fiReceiveBill);
				}
			}else{
				fiReceiveBillDao.delete(fiReceiveBill);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(FiReceiveAble fiReceiveAble) {
		super.delete(fiReceiveAble);
		fiReceiveBillDao.delete(new FiReceiveBill(fiReceiveAble));
	}
	
	/**
	 * 查询记录数
	 * @param fiReceiveAble
	 * @return
	 */
	public Long findCount(FiReceiveAble fiReceiveAble){
		return dao.findCount(fiReceiveAble);
	}
	
	public List<FiReceiveAble> findListByCustomer(FiReceiveAble fiReceiveAble) {
		return super.findList(fiReceiveAble);
	}
	
	public List<FiReceiveAble> findFiReceiveAbleList(FiReceiveAble fiReceiveAble) {
		return super.findList(fiReceiveAble);
	}
}