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
import com.javafast.modules.act.service.ActTaskService;
import com.javafast.modules.act.utils.ActUtils;
import com.javafast.modules.oa.dao.OaProjectImpleDao;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaProjectCon;
import com.javafast.modules.oa.entity.OaProjectImple;

/**
 * 项目实施流程表Service
 * @author javafast
 * @version 2019-07-15
 */
@Service
@Transactional(readOnly = true)
public class OaProjectImpleService extends CrudService<OaProjectImpleDao, OaProjectImple> {

	@Autowired
	private ActTaskService actTaskService;
	
	public OaProjectImple getByProcInsId(String procInsId) {
		return dao.getByProcInsId(procInsId);
	}
	
	public OaProjectImple get(String id) {
		return super.get(id);
	}
	
	public OaProjectImple getProName(String id) {
		return dao.getProName(id);
	}
	
	public List<OaProjectImple> findList(OaProjectImple oaProjectImple) {
		return super.findList(oaProjectImple);
	}
	
	public Page<OaProjectImple> findPage(Page<OaProjectImple> page, OaProjectImple oaProjectImple) {
		return super.findPage(page, oaProjectImple);
	}
	
	@Transactional(readOnly = false)
	public void save(OaProjectImple oaProjectImple) {
		// 申请发起
		if (StringUtils.isBlank(oaProjectImple.getId())){
			oaProjectImple.preInsert();
			dao.insert(oaProjectImple);
			
			// 启动流程
			actTaskService.startProcess(ActUtils.PD_PROJECT_IMPL[0], ActUtils.PD_PROJECT_IMPL[1], oaProjectImple.getId(), oaProjectImple.getContent());
			
		}
		
		// 提交表单		
		else{
			oaProjectImple.preUpdate();
			dao.update(oaProjectImple);

			oaProjectImple.getAct().setComment(("yes".equals(oaProjectImple.getAct().getFlag())?"[提交] ":"[驳回] ")+oaProjectImple.getAct().getComment());
			
			// 完成流程任务
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("pass", "yes".equals(oaProjectImple.getAct().getFlag())? "1" : "0");
			actTaskService.complete(oaProjectImple.getAct().getTaskId(), oaProjectImple.getAct().getProcInsId(), oaProjectImple.getAct().getComment(), oaProjectImple.getContent(), vars);
		
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaProjectImple oaProjectImple) {
		super.delete(oaProjectImple);
	}
	
	/**
	 * 审核审批保存
	 * @param oaProjectImple
	 */
	@Transactional(readOnly = false)
	public void auditSave(OaProjectImple oaProjectImple) {
		
		// 设置意见
		oaProjectImple.getAct().setComment(("yes".equals(oaProjectImple.getAct().getFlag())?"[同意] ":"[驳回] ")+oaProjectImple.getAct().getComment());
		
		oaProjectImple.preUpdate();
		
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = oaProjectImple.getAct().getTaskDefKey();

		// 审核环节
		if ("audit1".equals(taskDefKey)||"audit3".equals(taskDefKey)){
			oaProjectImple.setLeadText(oaProjectImple.getAct().getComment());
			dao.updateLeadText(oaProjectImple);
		}
		else if ("audit2".equals(taskDefKey)||"audit4".equals(taskDefKey)){
			oaProjectImple.setMainLeadText(oaProjectImple.getAct().getComment());
			dao.updateMainLeadText(oaProjectImple);
		}
		
		// 未知环节，直接返回
		else{
			return;
		}
		
		// 提交流程任务
		Map<String, Object> vars = Maps.newHashMap();
		vars.put("pass", "yes".equals(oaProjectImple.getAct().getFlag())? "1" : "0");
		actTaskService.complete(oaProjectImple.getAct().getTaskId(), oaProjectImple.getAct().getProcInsId(), oaProjectImple.getAct().getComment(), vars);

//		vars.put("var_test", "yes_no_test2");
//		actTaskService.getProcessEngine().getTaskService().addComment(oaProjectImple.getAct().getTaskId(), oaProjectImple.getAct().getProcInsId(), oaProjectImple.getAct().getComment());
//		actTaskService.jumpTask(oaProjectImple.getAct().getProcInsId(), oaProjectImple.getAct().getTaskId(), "audit2", vars);
	}
	

}