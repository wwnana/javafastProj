package com.javafast.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.modules.sys.dao.OfficeDao;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 机构Service
 */
@Service
@Transactional(readOnly = true)
public class OfficeService extends TreeService<OfficeDao, Office> {

	public List<Office> findAll(){
		return UserUtils.getOfficeList();
	}

	public List<Office> findList(Boolean isAll){
		if (isAll != null && isAll){
			return UserUtils.getOfficeAllList();
		}else{
			return UserUtils.getOfficeList();
		}
	}
	
	public List<Office> findOfficeList(Office office){
		office.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return dao.findOfficeList(office);
	}
	
	@Transactional(readOnly = true)
	public List<Office> findList(Office office){
		
		//机构、角色、用户，隔离企业账号数据，加入权限过滤
		if(office.isApi()){
			office.getSqlMap().put("dsf", " AND a.account_id='"+office.getAccountId()+"' ");
		}else{
			office.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		}
				
		office.setParentIds(office.getParentIds()+"%");
		return dao.findByParentIdsLike(office);
	}
	
	@Transactional(readOnly = true)
	public Office getByCode(String code){
		return dao.getByCode(code);
	}
	
	@Transactional(readOnly = false)
	public void save(Office office) {
		super.save(office);
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}
	
	@Transactional(readOnly = false)
	public void add(Office office) {
		dao.insert(office);
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}
	
	@Transactional(readOnly = false)
	public void delete(Office office) {
		super.delete(office);
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}
	
	/**
	 * 是否是顶级机构
	 * @param office
	 * @return
	 */
	public boolean isRootOffice(Office office){
	
		if("0".equals(office.getParentId())){
			return true;
		}
		return false;
	}
	
	public List<Office> findListByName(Office office){		
		return dao.findOfficeList(office);
	}
}
