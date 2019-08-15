package com.javafast.modules.iim.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.iim.dao.LayGroupDao;
import com.javafast.modules.iim.dao.LayGroupUserDao;
import com.javafast.modules.iim.entity.LayGroup;
import com.javafast.modules.iim.entity.LayGroupUser;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 群组Service
 */
@Service
@Transactional(readOnly = true)
public class LayGroupService extends CrudService<LayGroupDao, LayGroup> {

	@Autowired
	private LayGroupUserDao layGroupUserDao;
	
	public LayGroup get(String id) {
		LayGroup layGroup = super.get(id);
		layGroup.setLayGroupUserList(layGroupUserDao.findList(new LayGroupUser(layGroup)));
		return layGroup;
	}
	
	public List<LayGroup> findList(LayGroup layGroup) {
		List<LayGroup> layGroupList= new ArrayList<LayGroup>();
		List<LayGroup> list = super.findList(layGroup);
		for(LayGroup u:list){
			layGroupList.add(this.get(u.getId()));
		}
		return layGroupList;
	}
	
	public List<LayGroup> findGroupList(User user) {
		List<LayGroup> layGroupList= new ArrayList<LayGroup>();
		LayGroupUser layGroupUser = new LayGroupUser();
		layGroupUser.setUser(user);
		List<LayGroupUser> list = layGroupUserDao.findList(layGroupUser);
		for(LayGroupUser u:list){
			layGroupList.add(this.get(u.getGroup().getId()));
		}
		return layGroupList;
	}
	
	public Page<LayGroup> findPage(Page<LayGroup> page, LayGroup layGroup) {
		return super.findPage(page, layGroup);
	}
	
	@Transactional(readOnly = false)
	public void save(LayGroup layGroup) {
		super.save(layGroup);
		for (LayGroupUser layGroupUser : layGroup.getLayGroupUserList()){
			if (layGroupUser.getId() == null){
				continue;
			}
			if (LayGroupUser.DEL_FLAG_NORMAL.equals(layGroupUser.getDelFlag())){
				if (StringUtils.isBlank(layGroupUser.getId())){
					layGroupUser.setGroup(layGroup);
					layGroupUser.preInsert();
					layGroupUserDao.insert(layGroupUser);
				}else{
					layGroupUser.preUpdate();
					layGroupUserDao.update(layGroupUser);
				}
			}else{
				layGroupUserDao.delete(layGroupUser);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(LayGroup layGroup) {
		super.delete(layGroup);
		layGroupUserDao.delete(new LayGroupUser(layGroup));
	}
	
}