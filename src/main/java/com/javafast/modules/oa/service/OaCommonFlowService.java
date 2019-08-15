/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.oa.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaCommonFlow;
import com.javafast.modules.oa.dao.OaCommonFlowDao;
import com.javafast.modules.oa.entity.OaCommonFlowDetail;
import com.javafast.modules.oa.dao.OaCommonFlowDetailDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 流程配置Service
 * @author javafast
 * @version 2017-08-25
 */
@Service
@Transactional(readOnly = true)
public class OaCommonFlowService extends CrudService<OaCommonFlowDao, OaCommonFlow> {

	@Autowired
	private OaCommonFlowDetailDao oaCommonFlowDetailDao;
	
	public OaCommonFlow get(String id) {
		OaCommonFlow oaCommonFlow = super.get(id);
		oaCommonFlow.setOaCommonFlowDetailList(oaCommonFlowDetailDao.findList(new OaCommonFlowDetail(oaCommonFlow)));
		return oaCommonFlow;
	}
	
	public List<OaCommonFlow> findList(OaCommonFlow oaCommonFlow) {
		dataScopeFilter(oaCommonFlow);//加入数据权限过滤
		return super.findList(oaCommonFlow);
	}
	
	public Page<OaCommonFlow> findPage(Page<OaCommonFlow> page, OaCommonFlow oaCommonFlow) {
		dataScopeFilter(oaCommonFlow);//加入数据权限过滤
		return super.findPage(page, oaCommonFlow);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommonFlow oaCommonFlow) {
		super.save(oaCommonFlow);
		for (OaCommonFlowDetail oaCommonFlowDetail : oaCommonFlow.getOaCommonFlowDetailList()){
			if (oaCommonFlowDetail.getId() == null){
				continue;
			}
			if (OaCommonFlowDetail.DEL_FLAG_NORMAL.equals(oaCommonFlowDetail.getDelFlag())){
				if (StringUtils.isBlank(oaCommonFlowDetail.getId())){
					oaCommonFlowDetail.setCommonFlow(oaCommonFlow);
					oaCommonFlowDetail.preInsert();
					oaCommonFlowDetailDao.insert(oaCommonFlowDetail);
				}else{
					oaCommonFlowDetail.preUpdate();
					oaCommonFlowDetailDao.update(oaCommonFlowDetail);
				}
			}else{
				oaCommonFlowDetailDao.delete(oaCommonFlowDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommonFlow oaCommonFlow) {
		super.delete(oaCommonFlow);
		oaCommonFlowDetailDao.delete(new OaCommonFlowDetail(oaCommonFlow));
	}
	
}