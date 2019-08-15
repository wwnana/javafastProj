package com.javafast.modules.sys.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.sys.entity.SysPanel;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.dao.SysPanelDao;

/**
 * 面板设置Service
 * @author javafast
 * @version 2018-07-09
 */
@Service
@Transactional(readOnly = true)
public class SysPanelService extends CrudService<SysPanelDao, SysPanel> {

	public SysPanel get(String id) {
		return super.get(id);
	}
	
	public List<SysPanel> findList(SysPanel sysPanel) {
		return super.findList(sysPanel);
	}
	
	public Page<SysPanel> findPage(Page<SysPanel> page, SysPanel sysPanel) {
		return super.findPage(page, sysPanel);
	}
	
	@Transactional(readOnly = false)
	public void save(SysPanel sysPanel) {
		super.save(sysPanel);
	}
	
	@Transactional(readOnly = false)
	public void delete(SysPanel sysPanel) {
		super.delete(sysPanel);
	}
	
	@Transactional(readOnly = false)
	public void saveUserPanels(String[] panelIds) {
		
		super.delete(new SysPanel());
		
		for(int i=0; i<panelIds.length; i++){
			String panelId = panelIds[i];
			SysPanel sysPanel = new SysPanel();
			sysPanel.setPanelId(panelId);
			sysPanel.setUserId(UserUtils.getUser().getId());
			super.save(sysPanel);
		}
	}
	
	public List<SysPanel> findCurrentList(SysPanel sysPanel){
		return dao.findCurrentList(sysPanel);
	}
}