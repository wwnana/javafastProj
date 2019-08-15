<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调岗查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">

<div class="ibox float-e-margins">
				
                <div class="panel-body">
                    <div class="row">
						<div class="col-sm-2 text-center">
							<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
								${fn:substring(hrPositionChange.hrEmployee.name, 0, 1)}
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
												${hrPositionChange.hrEmployee.name}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">性别：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrPositionChange.hrEmployee.sex, 'sex', '')}
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
												${hrPositionChange.hrEmployee.mobile}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">邮箱：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrPositionChange.hrEmployee.email}
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
												${hrPositionChange.hrEmployee.position}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">员工状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrPositionChange.hrEmployee.status, 'employ_status', '')}
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
		<h5>调岗查看</h5>
	</div>
	
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrPositionChange" action="${ctx}/hr/hrPositionChange/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整前部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrPositionChange.oldOffice.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整后部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrPositionChange.office.name}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整前岗位：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrPositionChange.oldPosition}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整后岗位：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrPositionChange.position}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整前职级：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrPositionChange.oldPositionLevel}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整后职级：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrPositionChange.positionLevel}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">调岗时间：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							<fmt:formatDate value="${hrPositionChange.changeDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">调岗原因：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrPositionChange.changeCause}
							</p>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrPositionChange:edit">
			    	<a href="${ctx}/hr/hrPositionChange/form?id=${hrPositionChange.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrPositionChange:del">
					<a href="${ctx}/hr/hrPositionChange/delete?id=${hrPositionChange.id}" onclick="return confirmx('确认要删除该调岗吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>