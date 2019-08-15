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
import com.javafast.modules.act.service.ActTaskService;
import com.javafast.modules.act.utils.ActUtils;
import com.javafast.modules.oa.dao.OaProjectConDao;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaProjectCon;

/**
 * 项目咨询流程表Service
 * @author javafast
 * @version 2019-08-06
 */
@Service
@Transactional(readOnly = true)
public class OaProjectConService extends CrudService<OaProjectConDao, OaProjectCon> {

	@Autowired
	@Lazy
	private ActTaskService actTaskService;
	
	public OaProjectCon getByProcInsId(String procInsId) {
		return dao.getByProcInsId(procInsId);
	}
	
	public OaProjectCon get(String id) {
		return super.get(id);
	}
	
	public OaProjectCon getProName(String id) {
		return dao.getProName(id);
	}
	
	public List<OaProjectCon> findList(OaProjectCon oaProjectCon) {
		return super.findList(oaProjectCon);
	}
	
	public Page<OaProjectCon> findPage(Page<OaProjectCon> page, OaProjectCon oaProjectCon) {
		return super.findPage(page, oaProjectCon);
	}
	
	@Transactional(readOnly = false)
	public void save(OaProjectCon oaProjectCon) {
		// 申请发起
		if (StringUtils.isBlank(oaProjectCon.getId())){
			oaProjectCon.preInsert();
			dao.insert(oaProjectCon);
			
			// 启动流程
			actTaskService.startProcess(ActUtils.PD_PROJECT_CONS[0], ActUtils.PD_PROJECT_CONS[1], oaProjectCon.getId());
			
		}
		
		// 修改		
		else{
			oaProjectCon.preUpdate();
			dao.update(oaProjectCon);
//			if("audit00".equals(taskDefKey)) {
//				dao.updateUserId1(oaProjectCon);
//			}else if("audit01".equals(taskDefKey)) {
//				dao.updateUserId2(oaProjectCon);
//			}else if("audit02".equals(taskDefKey)) {
//				dao.updateUserId3(oaProjectCon);
//			}

			oaProjectCon.getAct().setComment(("yes".equals(oaProjectCon.getAct().getFlag())?"[提交] ":"[驳回] ")+oaProjectCon.getAct().getComment());
			
			
			// 完成流程任务
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("pass", "yes".equals(oaProjectCon.getAct().getFlag())? "1" : "0");
			actTaskService.complete(oaProjectCon.getAct().getTaskId(), oaProjectCon.getAct().getProcInsId(), oaProjectCon.getAct().getComment(), vars);
		
			System.out.println("***************完成流程任务********");
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaProjectCon oaProjectCon) {
		super.delete(oaProjectCon);
	}

	@Transactional(readOnly = false)
	public void auditSave(OaProjectCon oaProjectCon) {
		// 设置意见
		oaProjectCon.getAct().setComment(("yes".equals(oaProjectCon.getAct().getFlag())?"[同意] ":"[驳回] ")+oaProjectCon.getAct().getComment());
		
		oaProjectCon.preUpdate();
				
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = oaProjectCon.getAct().getTaskDefKey();

		// 审核环节
		if ("audit".equals(taskDefKey)){
			
		}
		else if ("audit10".equals(taskDefKey)||"audit11".equals(taskDefKey)||"audit12".equals(taskDefKey)){
			oaProjectCon.setHrText(oaProjectCon.getAct().getComment());
			dao.updateHrText(oaProjectCon);
		}
		else if ("audit3".equals(taskDefKey)){
			oaProjectCon.setLeadFstText(oaProjectCon.getAct().getComment());
			dao.updateLeadFstText(oaProjectCon);
		}
		else if ("apply_end".equals(taskDefKey)){
			
		}
		
		// 未知环节，直接返回
		else{
			return;
		}
		
		// 提交流程任务
		Map<String, Object> vars = Maps.newHashMap();
		vars.put("pass", "yes".equals(oaProjectCon.getAct().getFlag())? "1" : "0");
		actTaskService.complete(oaProjectCon.getAct().getTaskId(), oaProjectCon.getAct().getProcInsId(), oaProjectCon.getAct().getComment(), vars);

	}
	
}