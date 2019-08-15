<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>离职查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox float-e-margins">				
                <div class="panel-body">
                    <div class="row">
						<div class="col-sm-2 text-center">
							<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
								${fn:substring(hrQuit.hrEmployee.name, 0, 1)}
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
												${hrQuit.hrEmployee.name}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">性别：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.hrEmployee.sex, 'sex', '')}
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
												${hrQuit.hrEmployee.mobile}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">邮箱：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.hrEmployee.email}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">当前职位：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.hrEmployee.position}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">员工状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.hrEmployee.status, 'employ_status', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-1 pull-right">
						</div>	
                    </div>
                </div>
			</div>
			
<div class="ibox">
	<div class="ibox-title">
		<h5>离职查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrQuit" action="${ctx}/hr/hrQuit/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">离职类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrQuit.quitType, 'quit_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">离职时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrQuit.quitDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">离职原因：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.quitCause}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请离职原因：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.applyQuitCause}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">补偿金：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.compensation}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">社保减员月：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrQuit.socialOverMonth, 'over_month_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">公积金减员月：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrQuit.fundOverMonth, 'over_month_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">剩余年假：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.annualLeave}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">剩余调休：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.restLeave}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">工作交接</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">工作交接内容：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.workContent}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">工作交接给：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.workBy.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">工作交接完成情况：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrQuit.workStatus, 'finish_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrQuit.status, 'audit_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">提交人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.createBy.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">提交时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrQuit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">备注信息：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrQuit.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<c:if test="${hrQuit.status == 0}">
				<shiro:hasPermission name="hr:hrEmployee:edit">
			    	<a href="${ctx}/hr/hrQuit/form?id=${hrQuit.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
			    	<a href="${ctx}/hr/hrQuit/audit?id=${hrQuit.id}" onclick="return confirmx('确认要核准该离职吗？', this.href)" class="btn btn-success" title="核准"><i class="fa fa-check"></i> 核准</a> 
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrEmployee:del">
					<a href="${ctx}/hr/hrQuit/delete?id=${hrQuit.id}" onclick="return confirmx('确认要撤销该离职吗？', this.href)" class="btn btn-danger" title="撤销"><i class="fa fa-trash"></i> 撤销</a> 
				</shiro:hasPermission>
				</c:if>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>