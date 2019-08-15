<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调薪查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox float-e-margins">				
                <div class="panel-body">
                    <div class="row">
						<div class="col-sm-2 text-center">
							<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
								${fn:substring(hrSalaryChange.hrEmployee.name, 0, 1)}
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
												${hrSalaryChange.hrEmployee.name}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">性别：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrSalaryChange.hrEmployee.sex, 'sex', '')}
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
												${hrSalaryChange.hrEmployee.mobile}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">邮箱：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrSalaryChange.hrEmployee.email}
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
												${hrSalaryChange.hrEmployee.position}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">员工状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrSalaryChange.hrEmployee.status, 'employ_status', '')}
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
		<h5>调薪查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrSalaryChange" action="${ctx}/hr/hrSalaryChange/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调薪前基本工资：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryChange.oldBaseSalary}
							</p>
						</div>
					</div>
				</div>
			
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调薪后基本工资：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryChange.baseSalary}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调整幅度：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryChange.changeRange}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">调薪生效时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrSalaryChange.effectDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">调薪原因：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrSalaryChange.changeCause}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrSalaryChange.status, 'audit_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryChange.auditBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrSalaryChange.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">制单人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryChange.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">制单时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrSalaryChange.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<c:if test="${hrSalaryChange.status==0}">
				<shiro:hasPermission name="hr:hrSalaryChange:edit">
			    	<a href="${ctx}/hr/hrSalaryChange/form?id=${hrSalaryChange.id}" class="btn btn-success" title="修改">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrSalaryChange:del">
					<a href="${ctx}/hr/hrSalaryChange/audit?id=${hrSalaryChange.id}" onclick="return confirmx('确认要核准该调薪吗？', this.href)" class="btn btn-success" title="核准">核准</a> 
				</shiro:hasPermission>
								
				<shiro:hasPermission name="hr:hrSalaryChange:del">
					<a href="${ctx}/hr/hrSalaryChange/delete?id=${hrSalaryChange.id}" onclick="return confirmx('确认要删除该调薪吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
				</shiro:hasPermission>
				</c:if>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>