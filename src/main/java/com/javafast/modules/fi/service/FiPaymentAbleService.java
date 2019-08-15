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
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.dao.FiPaymentAbleDao;
import com.javafast.modules.fi.entity.FiPaymentBill;
import com.javafast.modules.fi.dao.FiPaymentBillDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 应付款Service
 * @author javafast
 * @version 2017-07-17
 */
@Service
@Transactional(readOnly = true)
public class FiPaymentAbleService extends CrudService<FiPaymentAbleDao, FiPaymentAble> {

	@Autowired
	private FiPaymentBillDao fiPaymentBillDao;
	
	public FiPaymentAble get(String id) {
		FiPaymentAble fiPaymentAble = super.get(id);
		fiPaymentAble.setFiPaymentBillList(fiPaymentBillDao.findList(new FiPaymentBill(fiPaymentAble)));
		return fiPaymentAble;
	}
	
	public List<FiPaymentAble> findList(FiPaymentAble fiPaymentAble) {
		dataScopeFilter(fiPaymentAble);//加入数据权限过滤
		return super.findList(fiPaymentAble);
	}
	
	public Page<FiPaymentAble> findPage(Page<FiPaymentAble> page, FiPaymentAble fiPaymentAble) {
		dataScopeFilter(fiPaymentAble);//加入数据权限过滤
		return super.findPage(page, fiPaymentAble);
	}
	
	@Transactional(readOnly = false)
	public void save(FiPaymentAble fiPaymentAble) {
		super.save(fiPaymentAble);
		for (FiPaymentBill fiPaymentBill : fiPaymentAble.getFiPaymentBillList()){
			if (fiPaymentBill.getId() == null){
				continue;
			}
			if (FiPaymentBill.DEL_FLAG_NORMAL.equals(fiPaymentBill.getDelFlag())){
				if (StringUtils.isBlank(fiPaymentBill.getId())){
					fiPaymentBill.setFiPaymentAble(fiPaymentAble);
					fiPaymentBill.preInsert();
					fiPaymentBillDao.insert(fiPaymentBill);
				}else{
					fiPaymentBill.preUpdate();
					fiPaymentBillDao.update(fiPaymentBill);
				}
			}else{
				fiPaymentBillDao.delete(fiPaymentBill);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(FiPaymentAble fiPaymentAble) {
		super.delete(fiPaymentAble);
		fiPaymentBillDao.delete(new FiPaymentBill(fiPaymentAble));
	}
	
}