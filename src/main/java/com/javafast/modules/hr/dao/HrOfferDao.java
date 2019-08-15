package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrResume;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrOffer;

/**
 * OFFERDAO接口
 * @author javafast
 * @version 2018-06-30
 */
@MyBatisDao
public interface HrOfferDao extends CrudDao<HrOffer> {
	
}