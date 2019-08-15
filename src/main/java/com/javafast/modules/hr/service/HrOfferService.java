package com.javafast.modules.hr.service;

import java.util.List;

import com.javafast.modules.hr.entity.HrResume;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrOffer;
import com.javafast.modules.hr.dao.HrOfferDao;

/**
 * OFFERService
 * @author javafast
 * @version 2018-06-30
 */
@Service
@Transactional(readOnly = true)
public class HrOfferService extends CrudService<HrOfferDao, HrOffer> {

	public HrOffer get(String id) {
		return super.get(id);
	}
	
	public List<HrOffer> findList(HrOffer hrOffer) {
		dataScopeFilter(hrOffer);//加入数据权限过滤
		return super.findList(hrOffer);
	}
	
	public Page<HrOffer> findPage(Page<HrOffer> page, HrOffer hrOffer) {
		dataScopeFilter(hrOffer);//加入数据权限过滤
		return super.findPage(page, hrOffer);
	}
	
	@Transactional(readOnly = false)
	public void save(HrOffer hrOffer) {
		super.save(hrOffer);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrOffer hrOffer) {
		super.delete(hrOffer);
	}
	
}