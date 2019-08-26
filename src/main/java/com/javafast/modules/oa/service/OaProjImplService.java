package com.javafast.modules.oa.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Maps;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.act.entity.Act;
import com.javafast.modules.act.service.ActTaskService;
import com.javafast.modules.act.utils.ActUtils;
import com.javafast.modules.oa.dao.OaProjImplDao;
import com.javafast.modules.oa.entity.OaProjImpl;

/**
 * 项目实施流程表Service
 * @author javafast
 * @version 2019-08-20
 */
@Service
@Transactional(readOnly = true)
public class OaProjImplService extends CrudService<OaProjImplDao, OaProjImpl> {

	@Autowired
	private ActTaskService actTaskService;
	
	public OaProjImpl get(String id) {
		return super.get(id);
	}
	
	public List<OaProjImpl> findList(OaProjImpl oaProjImpl) {
		return super.findList(oaProjImpl);
	}
	
	public Page<OaProjImpl> findPage(Page<OaProjImpl> page, OaProjImpl oaProjImpl) {
		return super.findPage(page, oaProjImpl);
	}
	
	@Transactional(readOnly = false)
	public void save(OaProjImpl oaProjImpl) {
		// 流程开始表单申请
		if (StringUtils.isBlank(oaProjImpl.getId())){
			oaProjImpl.preInsert();
			dao.insert(oaProjImpl);
			
			// 启动流程
			actTaskService.startProcess(ActUtils.PD_PROJ_IMPL[0], ActUtils.PD_PROJ_IMPL[1], oaProjImpl.getId());
		}
		// 表单申请		
		else{
			oaProjImpl.preInsert();
			dao.insert(oaProjImpl);
			if(oaProjImpl.getStatus().contains("form")) {
				oaProjImpl.getAct().setComment(("yes".equals(oaProjImpl.getAct().getFlag())?"[提交] ":" ")+oaProjImpl.getAct().getComment());
			}
			else {
				oaProjImpl.getAct().setComment(("yes".equals(oaProjImpl.getAct().getFlag())?"[提交] ":"[驳回] ")+oaProjImpl.getAct().getComment());
				
			}
			
			
			// 完成流程任务
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("pass", "yes".equals(oaProjImpl.getAct().getFlag())? "1" : "0");
			actTaskService.complete(oaProjImpl.getAct().getTaskId(), oaProjImpl.getAct().getProcInsId(), oaProjImpl.getAct().getComment(), vars);
		
			System.out.println("***************完成流程任务********");
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaProjImpl oaProjImpl) {
		super.delete(oaProjImpl);
	}

	public OaProjImpl getProName(String insId) {
		List<OaProjImpl> list = dao.getProName(insId);
		if(list!=null && list.size()>0)
			return dao.getProName(insId).get(0);
		return null;
	}

	public OaProjImpl findLastTask(String procInsId, String status) {
		return dao.findLastTask(procInsId,status);
	}

	@Transactional(readOnly = false)
	public void auditSave(OaProjImpl oaProjImpl) {
		
		
		// 设置意见
		oaProjImpl.getAct().setComment(("yes".equals(oaProjImpl.getAct().getFlag())?"[同意] ":"[驳回] ")+oaProjImpl.getAct().getComment());
		
		oaProjImpl.preUpdate();
				
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = oaProjImpl.getAct().getTaskDefKey();

		// 审核环节
		if (taskDefKey.contains("audit")){
			oaProjImpl.setAuditText(oaProjImpl.getAct().getComment());
			dao.updateAuditText(oaProjImpl);
		}
		else if ("apply_end".equals(taskDefKey)){
			
		}
		
		// 未知环节，直接返回
		else{
			return;
		}
		
		// 提交流程任务
		Map<String, Object> vars = Maps.newHashMap();
		vars.put("pass", "yes".equals(oaProjImpl.getAct().getFlag())? "1" : "0");
		actTaskService.complete(oaProjImpl.getAct().getTaskId(), oaProjImpl.getAct().getProcInsId(), oaProjImpl.getAct().getComment(), vars);

	}
	
}