package com.javafast.modules.oa.service;

import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Maps;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaProjCons;
import com.javafast.modules.act.service.ActTaskService;
import com.javafast.modules.act.utils.ActUtils;
import com.javafast.modules.oa.dao.OaProjConsDao;

/**
 * 项目咨询流程表Service
 * @author javafast
 * @version 2019-08-16
 */
@Service
@Transactional(readOnly = true)
public class OaProjConsService extends CrudService<OaProjConsDao, OaProjCons> {
	
	@Autowired
	@Lazy
	private ActTaskService actTaskService;

	public OaProjCons get(String id) {
		return super.get(id);
	}
	
	public List<OaProjCons> findList(OaProjCons oaProjCons) {
		return super.findList(oaProjCons);
	}
	
	public Page<OaProjCons> findPage(Page<OaProjCons> page, OaProjCons oaProjCons) {
		return super.findPage(page, oaProjCons);
	}
	
	@Transactional(readOnly = false)
	public void save(OaProjCons oaProjCons) {
		// 流程开始表单申请
		if (StringUtils.isBlank(oaProjCons.getId())){
			oaProjCons.preInsert();
			dao.insert(oaProjCons);
			
			// 启动流程
			actTaskService.startProcess(ActUtils.PD_PROJ_CONS[0], ActUtils.PD_PROJ_CONS[1], oaProjCons.getId());
		}
		// 表单申请		
		else{
			oaProjCons.preInsert();
			dao.insert(oaProjCons);
			if(oaProjCons.getStatus().contains("form")) {
				oaProjCons.getAct().setComment(("yes".equals(oaProjCons.getAct().getFlag())?"[提交] ":" "));
			}
			else {
				oaProjCons.getAct().setComment(("yes".equals(oaProjCons.getAct().getFlag())?"[提交] ":"[驳回] ")+oaProjCons.getAct().getComment());
				
			}
			
			
			// 完成流程任务
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("pass", "yes".equals(oaProjCons.getAct().getFlag())? "1" : "0");
			actTaskService.complete(oaProjCons.getAct().getTaskId(), oaProjCons.getAct().getProcInsId(), oaProjCons.getAct().getComment(), vars);
		
			System.out.println("***************完成流程任务********");
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaProjCons oaProjCons) {
		super.delete(oaProjCons);
	}

	public OaProjCons findLastTask(String procInsId,String status) {
		return dao.findLastTask(procInsId,status);
	}

	@Transactional(readOnly = false)
	public void auditSave(OaProjCons oaProjCons) {
		// 设置意见
		oaProjCons.getAct().setComment(("yes".equals(oaProjCons.getAct().getFlag())?"[同意] ":"[驳回] ")+oaProjCons.getAct().getComment());
		
		
		oaProjCons.preUpdate();
				
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = oaProjCons.getAct().getTaskDefKey();

		// 审核环节
		if (taskDefKey.contains("audit")){
			oaProjCons.setAuditText(oaProjCons.getAct().getComment());
			dao.updateAuditText(oaProjCons);
		}
		else if ("apply_end".equals(taskDefKey)){
			
		}
		
		// 未知环节，直接返回
		else{
			return;
		}
		
		// 提交流程任务
		Map<String, Object> vars = Maps.newHashMap();
		vars.put("pass", "yes".equals(oaProjCons.getAct().getFlag())? "1" : "0");
		actTaskService.complete(oaProjCons.getAct().getTaskId(), oaProjCons.getAct().getProcInsId(), oaProjCons.getAct().getComment(), vars);

	}

	public OaProjCons getProName(String insId) {
		List<OaProjCons> list = dao.getProName(insId);
		if(list!=null && list.size()>0)
			return dao.getProName(insId).get(0);
		return null;
	}
	
}