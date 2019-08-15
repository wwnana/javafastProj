<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
	<div class="row border-bottom white-bg dashboard-header">
        <div class="col-sm-11">
        	<div class="text-center">
        		<span class="index-title">${hrResume.name} - ${fns:getDictLabel(hrResume.currentNode, 'resume_current_node', '')}</span>
        	</div>
        </div>
        <div class="col-sm-1">
        	<div class="pull-right">
        		<a href="${ctx}/hr/hrResume/index?id=${hrResume.id}" class="btn btn-white btn-sm">刷新</a>
        		<button id="btnCancel" class="btn btn-white btn-sm" type="button" onclick="history.go(-1)">返回</button>
        	</div>
        </div>
        <br><br>
       <div class="col-sm-12 hide">
        	<div class="text-center">
        		<a href="${ctx}/hr/hrInterview/form?hrResume.id=${hrResume.id}" class="btn btn-success btn-sm">安排面试</a>
        		<a href="${ctx}/hr/hrOffer/form?hrResume.id=${hrResume.id}" class="btn btn-success btn-sm">发送OFFER</a>
        		<a href="${ctx}/hr/hrResume/shareForm?id=${hrResume.id}" class="btn btn-success btn-sm">推荐共享</a>
        		<a href="#" onclick="openDialog('放弃简历', '${ctx}/hr/hrResume/revokeForm?id=${hrResume.id}','800px', '500px')" class="btn btn-success btn-sm">放弃简历</a>
        		<a href="${hrResume.resumeFile}" class="btn btn-success btn-sm">下载简历</a>
        		<a href="${ctx}/hr/hrResume/index?id=${hrResume.id}" class="btn btn-success btn-sm">刷新</a>
        	</div>
        </div>
    </div>
    <sys:message content="${message}"/>	
<div class="wrapper-content pb80">
	
	<div class="row">
		<div class="col-sm-9">
			<div class="ibox float-e-margins">
				
                <div class="panel-body">
                    <div class="row">
						<div class="col-sm-2 text-center" style="padding-top: 30px;">
							<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
								${fn:substring(hrResume.name, 0, 1)}
                            </button>
                    	</div>
						<div class="col-sm-9">
							<div class="form-horizontal">
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">姓名：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.name}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">性别：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrResume.sex, 'sex', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">手机号：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.mobile}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">邮箱：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.mail}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">工作经验：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrResume.experience, 'experience_type', '')}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">学历：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrResume.education, 'education_type', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">上家公司：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.lastCompany}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">上家职位：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.lastJob}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">毕业院校：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.university}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">专业：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrResume.specialty}
												</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-1 pull-right">
								<a href="${ctx}/hr/hrResume/form?id=${hrResume.id}" title="修改" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-edit"></i></a>
						</div>	
                    </div>
                </div>
			</div>
			
			<div class="tabs-container">
			 	<ul class="nav nav-tabs">
			 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">简历预览</a></li>
			 		<li><a data-toggle="tab" href="#tab-2" aria-expanded="false">面试安排</a></li>
			 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">OFFER</a></li>
			 	</ul>
			 	<div class="tab-content">
			 		<div id="tab-1" class="tab-pane active">
			 			<div class="panel-body" style="height: 800px">
			 				<iframe id="officeContent" name="officeContent" src="https://view.officeapps.live.com/op/view.aspx?src=${fns:getConfig('webSite')}${hrResume.resumeFile}" width="100%" height="800px" frameborder="0"></iframe>
			 			</div>
			 		</div>
			 		<div id="tab-2" class="tab-pane">
			 			<div class="panel-body">
			 				<table id="contentTable" class="table table-bordered table-striped table-hover">
								<thead>
									<tr>
										<th>面试日期</th>
										<th>应聘岗位</th>										
										<th>邀约状态</th>
										<%-- <th>签到状态</th>
										<th>签到时间</th>--%>
										<th>面试人</th>
										<th>反馈状态</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${hrInterviewList}" var="hrInterview">
									<tr>
										<td>
											<a href="${ctx}/hr/hrInterview/view?id=${hrInterview.id}" title="查看">
											<fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm"/>
											</a>
										</td>
										<td>
											${hrInterview.position}
										</td>
										<td>
											${fns:getDictLabel(hrInterview.inviteStatus, 'invite_status', '')}
										</td>
										<%-- <td>
											${fns:getDictLabel(hrInterview.signStatus, 'sign_status', '')}
										</td>
										<td>
											<fmt:formatDate value="${hrInterview.signTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
										</td>
										--%>
										<td>
											${hrInterview.interviewBy.name}
										</td>
										<td>
											<c:if test="${hrInterview.status == 0}">未反馈</c:if>
											<c:if test="${hrInterview.status == 1}">已反馈</c:if>
										</td>
										<td>
											<c:if test="${hrInterview.status == 0 && hrInterview.inviteStatus != 2}">
											<a href="${ctx}/hr/hrInterview/delete?id=${hrInterview.id}" onclick="return confirmx('确认要撤销该面试吗？', this.href)" class="btn  btn-danger btn-xs" title="撤销"><i class="fa fa-trash"></i> 撤销</a> 
											</c:if>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
			 			</div>
			 		</div>
			 		<div id="tab-3" class="tab-pane">
			 			<div class="panel-body">
			 				<table id="contentTable" class="table table-bordered table-striped table-hover">
								<thead>
									<tr>
										
										<th>报到时间</th>
										<th>试用期</th>
										<th>入职岗位</th>
										<th>入职部门</th>
										<th>转正工资(元)</th>
										<th>试用期工资(元)</th>
										<th>状态</th>
										<th>有效期(天)</th>
										<th>发送时间</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${hrOfferList}" var="hrOffer">
									<tr>
										
										<td>
											<a href="${ctx}/hr/hrOffer/view?id=${hrOffer.id}" title="查看">
												<fmt:formatDate value="${hrOffer.reportDate}" pattern="yyyy-MM-dd HH:mm"/>
											</a>
										</td>
										<td>
											${fns:getDictLabel(hrOffer.probationPeriod, 'probation_period', '')}
										</td>
										<td>
											${hrOffer.position}
										</td>
										<td>
											${hrOffer.department}
										</td>
										<td>
											${hrOffer.formalSalaryBase}
										</td>
										<td>
											${hrOffer.probationSalaryBase}
										</td>
										<td>
											${fns:getDictLabel(hrOffer.status, 'invite_status', '')}
										</td>
										<td>
											${hrOffer.validityPeriod}
										</td>
										<td>
											<fmt:formatDate value="${hrOffer.updateDate}" pattern="yyyy-MM-dd"/>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
			 			</div>
			 		</div>
			 	</div>
			</div>
		
		</div>
		<div class="col-sm-3">
			<div class="ibox float-e-margins">
				<div class="ibox-title">                        
                    <h5>招聘记录</h5>
                </div>
                <div class="ibox-content timeline">

               		<c:forEach items="${hrResumeLogList}" var="hrResumeLog">
                       	<div class="timeline-item">
                            <div class="row">
                                <div class="col-xs-3 date">
                                    <i class="fa fa-circle-thin text-navy"></i> ${hrResumeLog.createBy.name}<br>
                                    <small><fmt:formatDate value="${hrResumeLog.createDate}" pattern="yyyy-MM-dd"/> <br><fmt:formatDate value="${hrResumeLog.createDate}" pattern="HH:mm"/></small>
                                </div>
                                <div class="col-xs-7 content">
                                    <p class="m-b-xs">${fns:getDictLabel(hrResumeLog.type, 'resume_action', '')}</p>
                                    <p class="small">${hrResumeLog.note}</p>
                                </div>
                            </div>
                        </div>	
                    </c:forEach>

                    </div>
			</div>
		</div>
	</div>	
</div>

	<div class="row dashboard-footer white-bg">
         <div class="col-sm-12">
        	<div class="text-center">
        		<a href="${ctx}/hr/hrInterview/form?hrResume.id=${hrResume.id}" class="btn btn-success btn-sm">安排面试</a>
        		<a href="${ctx}/hr/hrOffer/form?hrResume.id=${hrResume.id}" class="btn btn-success btn-sm">
        			<c:if test="${hrOfferList== null || fn:length(hrOfferList) == 0}">发送OFFER</c:if>
        			<c:if test="${hrOfferList!= null && fn:length(hrOfferList) > 0}">重发OFFER</c:if>
        		</a>
        		<a href="${ctx}/hr/hrEmployee/entryForm?hrResume.id=${hrResume.id}" class="btn btn-success btn-sm">入职</a>
        		<a href="#" onclick="openDialog('推荐共享', '${ctx}/hr/hrResume/shareForm?hrResume.id=${hrResume.id}','500px', '300px')" class="btn btn-success btn-sm">推荐共享</a>
        		<a href="#" onclick="openDialog('放弃简历', '${ctx}/hr/hrResume/revokeForm?id=${hrResume.id}','800px', '500px')" class="btn btn-success btn-sm">放弃简历</a>
        		<a href="${hrResume.resumeFile}" class="btn btn-success btn-sm">下载简历</a>
        		
        	</div>
        </div>
    </div>
</body>
</html>