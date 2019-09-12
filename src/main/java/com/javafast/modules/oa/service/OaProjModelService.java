package com.javafast.modules.oa.service;

import java.util.List;

import org.activiti.bpmn.BpmnAutoLayout;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.bpmn.model.EndEvent;
import org.activiti.bpmn.model.ExclusiveGateway;
import org.activiti.bpmn.model.ParallelGateway;
import org.activiti.bpmn.model.Process;
import org.activiti.bpmn.model.SequenceFlow;
import org.activiti.bpmn.model.StartEvent;
import org.activiti.bpmn.model.UserTask;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngines;
import org.activiti.engine.repository.Deployment;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdGen;
import com.javafast.modules.oa.dao.OaProjConsDao;
import com.javafast.modules.oa.dao.OaTaskDao;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.sys.utils.UserUtils;

@Service
@Transactional(readOnly = true)
public class OaProjModelService extends CrudService<OaTaskDao,OaTask> {

	@Autowired
	OaProjectService oaProjectService;

	@Transactional(readOnly = false)
	public String createProjConsFlowChart(List<OaTask> taskList,String id) {
		ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
		
		//建立模型
		BpmnModel model =  new BpmnModel();
		Process process = new Process();
		model.addProcess(process);
		process.setId("testProjCons");
		process.setName("项目咨询流程");
		process.setDocumentation("");
		//添加流程
		//开始节点
		process.addFlowElement(createStartEvent("/oa/oaProjCons/form"));
		//并行网关
		process.addFlowElement(createParallelGateway("parallelGateway-fork","并行网关-分支" ));
		int i=0;//用于统一设置节点名称
		for(OaTask task : taskList) {
			String iddd = task.getOwnBy().getId();
			process.addFlowElement(createUserTask("form0"+i,task.getName(),UserUtils.get(iddd).getLoginName()));
			process.addFlowElement(createUserTask("audit0"+i,"项目负责人审核"+task.getName(),"aa"));
			process.addFlowElement(createExclusiveGateway("exclu"+i,"exclu"+i));
			i++;
		}
		
		process.addFlowElement(createParallelGateway("parallelGateway-join","并行网关-汇聚"));
		process.addFlowElement(createUserTask("form10","方案和报价提交","aa"));
		process.addFlowElement(createUserTask("audit10","领导审核","hh"));
		process.addFlowElement(createExclusiveGateway("exclu10","exclu10"));
		process.addFlowElement(createUserTask("apply_end","竞标结果","aa"));
		
		//结束节点
		process.addFlowElement(createEndEvent());
		
		//连线
		process.addFlowElement(createSequenceFlow("startEvent","parallelGateway-fork","sid-"+IdGen.randomLong(),"",""));
		for(int j=0;j<taskList.size();j++) {
			process.addFlowElement(createSequenceFlow("parallelGateway-fork","form0"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("form0"+j,"audit0"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("audit0"+j,"exclu"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("exclu"+j,"parallelGateway-join","sid-"+IdGen.randomLong(),"通过","${pass==1}"));
			process.addFlowElement(createSequenceFlow("exclu"+j,"form0"+j,"sid-"+IdGen.randomLong(),"反馈","${pass==0}"));
			
		}
		process.addFlowElement(createSequenceFlow("parallelGateway-join","form10","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("form10","audit10","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("audit10","exclu10","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("exclu10","apply_end","sid-"+IdGen.randomLong(),"通过","${pass==1}"));
		process.addFlowElement(createSequenceFlow("exclu10","form10","sid-"+IdGen.randomLong(),"反馈","${pass==0}"));
		
		process.addFlowElement(createSequenceFlow("apply_end","endEvent","sid-"+IdGen.randomLong(),"",""));
		
		// 2. 生成的图形信息
		new BpmnAutoLayout(model).execute();
		
		//部署流程
		Deployment deployment = processEngine.getRepositoryService().createDeployment()
				.addBpmnModel(process.getId()+".bpmn", model)
				.name(process.getId()+"_deployment").deploy();
		
//		//启动一个流程实例
//		ProcessInstance processInstance = processEngine.getRuntimeService()
//				.startProcessInstanceByKey(process.getId());

//		try {
//			//将流程图保存到本地文件
//			InputStream processDiagram = processEngine.getRepositoryService()
//					.getProcessDiagram(processInstance.getProcessDefinitionId());
//			FileUtils.copyInputStreamToFile(processDiagram, new File("C:/Users/a/Desktop/deployment/"+process.getId()+".png"));
//			
//			//将流程BPMN.xml到本地文件
//			InputStream processBpmn = processEngine.getRepositoryService()
//					.getResourceAsStream(deployment.getId(), process.getId()+".bpmn");
//			FileUtils.copyInputStreamToFile(processBpmn,new File("C:/Users/a/Desktop/deployments/"+process.getId()+".bpmn"));
//		}catch(Exception e) {
//			e.printStackTrace();
//		}
		return process.getName();
	}

	@Transactional(readOnly = false)
	public String createProjImplFlowChartFst(List<OaTask> taskList, String id) {
		ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
		
		//建立模型
		BpmnModel model =  new BpmnModel();
		Process process = new Process();
		model.addProcess(process);
		process.setId("testProjImplFst");
		process.setName("项目实施流程-可执行方案");
		process.setDocumentation("");
		//添加流程
		//开始节点
		process.addFlowElement(createStartEvent("/oa/oaProjImpl/form"));
		//并行网关
		process.addFlowElement(createParallelGateway("parallelGateway-fork","并行网关-分支" ));
		int i=0;//用于统一设置节点名称
		for(OaTask task : taskList) {
			String iddd = task.getOwnBy().getId();
			process.addFlowElement(createUserTask("form0"+i,task.getName(),UserUtils.get(iddd).getLoginName()));
			process.addFlowElement(createUserTask("audit0"+i,"项目负责人审核"+task.getName(),"aa"));
			process.addFlowElement(createExclusiveGateway("exclu"+i,"exclu"+i));
			i++;
		}
		
		process.addFlowElement(createParallelGateway("parallelGateway-join","并行网关-汇聚"));
		process.addFlowElement(createEndEvent());
		
		//连线
		process.addFlowElement(createSequenceFlow("startEvent","parallelGateway-fork","sid-"+IdGen.randomLong(),"",""));
		for(int j=0;j<taskList.size();j++) {
			process.addFlowElement(createSequenceFlow("parallelGateway-fork","form0"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("form0"+j,"audit0"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("audit0"+j,"exclu"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("exclu"+j,"parallelGateway-join","sid-"+IdGen.randomLong(),"通过","${pass==1}"));
			process.addFlowElement(createSequenceFlow("exclu"+j,"form0"+j,"sid-"+IdGen.randomLong(),"反馈","${pass==0}"));
			
		}
		process.addFlowElement(createSequenceFlow("parallelGateway-join","endEvent","sid-"+IdGen.randomLong(),"",""));
		// 2. 生成的图形信息
		new BpmnAutoLayout(model).execute();
		
		//部署流程
		Deployment deployment = processEngine.getRepositoryService().createDeployment()
				.addBpmnModel(process.getId()+".bpmn", model)
				.name(process.getId()+"_deployment").deploy();
		return process.getName();
	}

	@Transactional(readOnly = false)
	public String createProjImplFlowChartSec(List<OaTask> taskList, String id) {
		ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
		
		//建立模型
		BpmnModel model =  new BpmnModel();
		Process process = new Process();
		model.addProcess(process);
		process.setId("testProjImplSec");
		process.setName("项目实施流程-详细方案");
		process.setDocumentation("");
		//添加流程
		//开始节点
		process.addFlowElement(createStartEvent("/oa/oaProjImpl/form"));
		//用户节点：上传总体系统方案
		process.addFlowElement(createUserTask("form30","上传总体系统方案","aa"));
		//并行网关
		process.addFlowElement(createParallelGateway("parallelGateway-fork","并行网关-分支" ));
		int i=0;//用于统一设置节点名称
		for(OaTask task : taskList) {
			String iddd = task.getOwnBy().getId();
			process.addFlowElement(createUserTask("form2"+i,task.getName(),UserUtils.get(iddd).getLoginName()));
			process.addFlowElement(createUserTask("audit2"+i,"项目负责人审核"+task.getName(),"aa"));
			process.addFlowElement(createExclusiveGateway("exclu"+i,"exclu"+i));
			i++;
		}
		process.addFlowElement(createParallelGateway("parallelGateway-join","并行网关-汇聚"));
		process.addFlowElement(createUserTask("judge30","决策","aa"));
		process.addFlowElement(createExclusiveGateway("exclu30","exclu30"));
		
		process.addFlowElement(createUserTask("form40","上传招标文件","aa"));
		process.addFlowElement(createUserTask("audit40","招标结果","aa"));
		process.addFlowElement(createUserTask("comm81","项目实施","aa"));
		process.addFlowElement(createUserTask("comm82","情况评审","aa"));
		
		process.addFlowElement(createEndEvent());
		
		//连线
		process.addFlowElement(createSequenceFlow("startEvent","form30","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("form30","parallelGateway-fork","sid-"+IdGen.randomLong(),"",""));
		for(int j=0;j<taskList.size();j++) {
			process.addFlowElement(createSequenceFlow("parallelGateway-fork","form2"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("form2"+j,"audit2"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("audit2"+j,"exclu"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("exclu"+j,"parallelGateway-join","sid-"+IdGen.randomLong(),"通过","${pass==1}"));
			process.addFlowElement(createSequenceFlow("exclu"+j,"form2"+j,"sid-"+IdGen.randomLong(),"反馈","${pass==0}"));
			
		}
		process.addFlowElement(createSequenceFlow("parallelGateway-join","judge30","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("judge30","exclu30","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("exclu30","form40","sid-"+IdGen.randomLong(),"招标","${pass==1}"));
		process.addFlowElement(createSequenceFlow("form40","audit40","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("audit40","comm81","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("comm81","comm82","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("comm82","endEvent","sid-"+IdGen.randomLong(),"",""));
		
		process.addFlowElement(createSequenceFlow("exclu30","endEvent","sid-"+IdGen.randomLong(),"非招标","${pass==0}"));
		
		// 2. 生成的图形信息
		new BpmnAutoLayout(model).execute();
		
		//部署流程
		Deployment deployment = processEngine.getRepositoryService().createDeployment()
				.addBpmnModel(process.getId()+".bpmn", model)
				.name(process.getId()+"_deployment").deploy();
		
		
		return process.getName();
	}

	@Transactional(readOnly = false)
	public String createProjImplFlowChartThd(List<OaTask> taskList, String id) {
		ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
		
		//建立模型
		BpmnModel model =  new BpmnModel();
		Process process = new Process();
		model.addProcess(process);
		process.setId("testProjImplThd");
		process.setName("项目实施流程-任务计划书反馈");
		process.setDocumentation("");
		//添加流程
		//开始节点
		process.addFlowElement(createStartEvent("/oa/oaProjImpl/form"));
		//用户节点：上传任务计划书
		process.addFlowElement(createUserTask("form70","上传任务计划书","aa"));
		//并行网关
		process.addFlowElement(createParallelGateway("parallelGateway-fork","并行网关-分支" ));
		int i=0;//用于统一设置节点名称
		for(OaTask task : taskList) {
			String iddd = task.getOwnBy().getId();
			process.addFlowElement(createUserTask("form5"+i,task.getName(),UserUtils.get(iddd).getLoginName()));
			process.addFlowElement(createUserTask("audit5"+i,"项目负责人审核"+task.getName(),"aa"));
			process.addFlowElement(createExclusiveGateway("exclu"+i,"exclu"+i));
			i++;
		}
		process.addFlowElement(createParallelGateway("parallelGateway-join","并行网关-汇聚"));
		process.addFlowElement(createUserTask("audit70","项目实施","aa"));
		
		process.addFlowElement(createEndEvent());
		
		//连线
		process.addFlowElement(createSequenceFlow("startEvent","form70","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("form70","parallelGateway-fork","sid-"+IdGen.randomLong(),"",""));
		for(int j=0;j<taskList.size();j++) {
			process.addFlowElement(createSequenceFlow("parallelGateway-fork","form5"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("form5"+j,"audit5"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("audit5"+j,"exclu"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("exclu"+j,"parallelGateway-join","sid-"+IdGen.randomLong(),"不修改","${pass==0}"));
			process.addFlowElement(createSequenceFlow("exclu"+j,"form70","sid-"+IdGen.randomLong(),"修改","${pass==1}"));
			
		}
		process.addFlowElement(createSequenceFlow("parallelGateway-join","audit70","sid-"+IdGen.randomLong(),"",""));
		
		process.addFlowElement(createSequenceFlow("audit70","endEvent","sid-"+IdGen.randomLong(),"",""));
		
		// 2. 生成的图形信息
		new BpmnAutoLayout(model).execute();
		
		//部署流程
		Deployment deployment = processEngine.getRepositoryService().createDeployment()
				.addBpmnModel(process.getId()+".bpmn", model)
				.name(process.getId()+"_deployment").deploy();
		return process.getName();
	}
	
	@Transactional(readOnly = false)
	public String createProjImplFlowChartFour(List<OaTask> taskList, String id) {
		ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
		
		//建立模型
		BpmnModel model =  new BpmnModel();
		Process process = new Process();
		model.addProcess(process);
		process.setId("testProjImplFour");
		process.setName("项目实施流程-子系统验收");
		process.setDocumentation("");
		//添加流程
		//开始节点
		process.addFlowElement(createStartEvent("/oa/oaProjImpl/form"));
		//并行网关
		process.addFlowElement(createParallelGateway("parallelGateway-fork1","并行网关-分支" ));
		int i=0;//用于统一设置节点名称
		for(OaTask task : taskList) {
			String iddd = task.getOwnBy().getId();
			process.addFlowElement(createUserTask("form1"+i,task.getName(),UserUtils.get(iddd).getLoginName()));
			process.addFlowElement(createUserTask("audit1"+i,"项目负责人审核"+task.getName(),"aa"));
			process.addFlowElement(createExclusiveGateway("exclu"+i,"exclu"+i));
			i++;
		}
		process.addFlowElement(createParallelGateway("parallelGateway-join1","并行网关-汇聚"));
		process.addFlowElement(createUserTask("form90","信息汇总","aa"));
		//并行网关
		//process.addFlowElement(createParallelGateway("parallelGateway-fork2","并行网关-分支" ));
//		int x=0;//用于统一设置节点名称
//		for(OaTask task : taskList) {
//			String iddd = task.getOwnBy().getId();
//			process.addFlowElement(createUserTask("form6"+x,task.getName(),UserUtils.get(iddd).getLoginName()));
//			process.addFlowElement(createUserTask("audit6"+x,"项目负责人审核"+task.getName(),"aa"));
//			process.addFlowElement(createExclusiveGateway("exclu"+x,"exclu"+x));
//			x++;
//		}
		//process.addFlowElement(createParallelGateway("parallelGateway-join2","并行网关-汇聚"));
		process.addFlowElement(createUserTask("apply_end","产品验收","aa"));
		process.addFlowElement(createEndEvent());
		
		//连线
		process.addFlowElement(createSequenceFlow("startEvent","parallelGateway-fork1","sid-"+IdGen.randomLong(),"",""));
		for(int j=0;j<taskList.size();j++) {
			process.addFlowElement(createSequenceFlow("parallelGateway-fork1","form1"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("form1"+j,"audit1"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("audit1"+j,"exclu"+j,"sid-"+IdGen.randomLong(),"",""));
			process.addFlowElement(createSequenceFlow("exclu"+j,"parallelGateway-join1","sid-"+IdGen.randomLong(),"通过","${pass==1}"));
			process.addFlowElement(createSequenceFlow("exclu"+j,"form1"+j,"sid-"+IdGen.randomLong(),"反馈","${pass==0}"));
			
		}
		process.addFlowElement(createSequenceFlow("parallelGateway-join1","form90","sid-"+IdGen.randomLong(),"",""));
//		process.addFlowElement(createSequenceFlow("form90","parallelGateway-fork2","sid-"+IdGen.randomLong(),"",""));
//		for(int j=0;j<taskList.size();j++) {
//			process.addFlowElement(createSequenceFlow("parallelGateway-fork2","form6"+j,"sid-"+IdGen.randomLong(),"",""));
//			process.addFlowElement(createSequenceFlow("form6"+j,"audit6"+j,"sid-"+IdGen.randomLong(),"",""));
//			process.addFlowElement(createSequenceFlow("audit6"+j,"exclu"+j,"sid-"+IdGen.randomLong(),"",""));
//			process.addFlowElement(createSequenceFlow("exclu"+j,"parallelGateway-join2","sid-"+IdGen.randomLong(),"通过","${pass==1}"));
//			process.addFlowElement(createSequenceFlow("exclu"+j,"form6"+j,"sid-"+IdGen.randomLong(),"反馈","${pass==0}"));
//			
//		}
		
		//process.addFlowElement(createSequenceFlow("parallelGateway-join2","apply_end","sid-"+IdGen.randomLong(),"",""));
		process.addFlowElement(createSequenceFlow("form90","apply_end","sid-"+IdGen.randomLong(),"",""));

		process.addFlowElement(createSequenceFlow("apply_end","endEvent","sid-"+IdGen.randomLong(),"",""));
		
		// 2. 生成的图形信息
		new BpmnAutoLayout(model).execute();
		
		//部署流程
		Deployment deployment = processEngine.getRepositoryService().createDeployment()
				.addBpmnModel(process.getId()+".bpmn", model)
				.name(process.getId()+"_deployment").deploy();
		return process.getName();
	}
	
	
	@Transactional(readOnly = false)
	protected SequenceFlow createSequenceFlow(String from, String to, String id, String name, String condExpr) {
		SequenceFlow flow = new SequenceFlow();
		flow.setSourceRef(from);
		flow.setTargetRef(to);
		flow.setId(id);
		flow.setName(name);
		if(StringUtils.isNotEmpty(condExpr)) {
			flow.setConditionExpression(condExpr);
			
		}
		return flow;
	}

	@Transactional(readOnly = false)
	protected ExclusiveGateway createExclusiveGateway(String id, String name) {
		ExclusiveGateway exclusiveGateway = new ExclusiveGateway();
		exclusiveGateway.setId(id);
		exclusiveGateway.setName(name);
		return exclusiveGateway;
	}

	@Transactional(readOnly = false)
	protected UserTask createUserTask(String id, String name, String userName) {
		UserTask userTask = new UserTask();
		userTask.setId(id);
		userTask.setName(name);
		userTask.setAssignee(userName);
		return userTask;
	}

	@Transactional(readOnly = false)
	protected ParallelGateway createParallelGateway(String id, String name) {
		ParallelGateway gateway = new ParallelGateway();
		gateway.setId(id);
		gateway.setName(name);
		return gateway;
	}

	//结束节点
	@Transactional(readOnly = false)
	protected EndEvent createEndEvent() {
		EndEvent endEvent = new EndEvent();
		endEvent.setId("endEvent");
		endEvent.setName("结束");
		return endEvent;
	}

	//开始节点
	@Transactional(readOnly = false)
	protected StartEvent createStartEvent(String formName) {
		StartEvent startEvent = new StartEvent();
		startEvent.setId("startEvent");
		startEvent.setName("开始");
		startEvent.setFormKey(formName);//开始进入分配任务页面
		return startEvent;
	}


}