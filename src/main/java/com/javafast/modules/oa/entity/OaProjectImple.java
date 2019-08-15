package com.javafast.modules.oa.entity;

import java.util.Map;

import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import com.javafast.common.persistence.ActEntity;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 项目实施流程表Entity
 * @author javafast
 * @version 2019-07-15
 */
public class OaProjectImple extends ActEntity<OaProjectImple> {
	
	private static final long serialVersionUID = 1L;
	private String procInsId;		// 流程实例ID
	private User user;		// 变动用户
	private Office office;		// 归属部门
	private String post;		// 岗位
	private String content;		// 调整原因
	private String exeDate;		// 执行时间
	private String leadText;		// 项目负责人意见
	private String mainLeadText;		// 领导意见
	private String files;		// 附件
	private OaProject project;		// 所属项目
//	
//	//-- 临时属性 --//
//	// 流程任务
//	private Task task;
//	private Map<String, Object> variables;
//	// 运行中的流程实例
//	private ProcessInstance processInstance;
//	// 历史的流程实例
//	private HistoricProcessInstance historicProcessInstance;
//	// 流程定义
//	private ProcessDefinition processDefinition;
	
	public OaProjectImple() {
		super();
	}

	public OaProjectImple(String id){
		super(id);
	}

	@Length(min=0, max=64, message="流程实例ID长度必须介于 0 和 64 之间")
	@ExcelField(title="流程实例ID", align=2, sort=1)
	public String getProcInsId() {
		return procInsId;
	}

	public void setProcInsId(String procInsId) {
		this.procInsId = procInsId;
	}
	
	@ExcelField(title="变动用户", fieldType=User.class, value="user.name", align=2, sort=2)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@ExcelField(title="归属部门", fieldType=Office.class, value="office.name", align=2, sort=3)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Length(min=0, max=255, message="岗位长度必须介于 0 和 255 之间")
	@ExcelField(title="岗位", align=2, sort=4)
	public String getPost() {
		return post;
	}

	public void setPost(String post) {
		this.post = post;
	}
	
	@Length(min=0, max=255, message="调整原因长度必须介于 0 和 255 之间")
	@ExcelField(title="调整原因", align=2, sort=5)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=255, message="执行时间长度必须介于 0 和 255 之间")
	@ExcelField(title="执行时间", align=2, sort=6)
	public String getExeDate() {
		return exeDate;
	}

	public void setExeDate(String exeDate) {
		this.exeDate = exeDate;
	}
	
	@Length(min=0, max=255, message="项目负责人意见长度必须介于 0 和 255 之间")
	@ExcelField(title="项目负责人意见", align=2, sort=7)
	public String getLeadText() {
		return leadText;
	}

	public void setLeadText(String leadText) {
		this.leadText = leadText;
	}
	
	@Length(min=0, max=255, message="领导意见长度必须介于 0 和 255 之间")
	@ExcelField(title="领导意见", align=2, sort=8)
	public String getMainLeadText() {
		return mainLeadText;
	}

	public void setMainLeadText(String mainLeadText) {
		this.mainLeadText = mainLeadText;
	}
	
	@Length(min=0, max=2000, message="附件长度必须介于 0 和 2000 之间")
	@ExcelField(title="附件", align=2, sort=15)
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}

	public OaProject getProject() {
		return project;
	}

	public void setProject(OaProject project) {
		this.project = project;
	}
	

//	public Map<String, Object> getVariables() {
//		return variables;
//	}
//
//	public void setVariables(Map<String, Object> variables) {
//		this.variables = variables;
//	}
//
//	public ProcessInstance getProcessInstance() {
//		return processInstance;
//	}
//
//	public void setProcessInstance(ProcessInstance processInstance) {
//		this.processInstance = processInstance;
//	}
//
//	public HistoricProcessInstance getHistoricProcessInstance() {
//		return historicProcessInstance;
//	}
//
//	public void setHistoricProcessInstance(HistoricProcessInstance historicProcessInstance) {
//		this.historicProcessInstance = historicProcessInstance;
//	}
//
//	public ProcessDefinition getProcessDefinition() {
//		return processDefinition;
//	}
//
//	public void setProcessDefinition(ProcessDefinition processDefinition) {
//		this.processDefinition = processDefinition;
//	}
//
//	public Task getTask() {
//		return task;
//	}
//
//	public void setTask(Task task) {
//		this.task = task;
//	}
	
	
	
}