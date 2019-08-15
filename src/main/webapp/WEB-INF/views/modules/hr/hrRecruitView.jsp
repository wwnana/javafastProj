<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>招聘任务查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>招聘任务查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrRecruit" action="${ctx}/hr/hrRecruit/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">岗位名称：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrRecruit.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">需求部门：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrRecruit.depart}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">招聘人数：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrRecruit.recruitNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">岗位要求</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">工作经验：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrRecruit.experience, 'experience_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">学历要求：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrRecruit.education, 'education_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">备注：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrRecruit.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">招聘进度</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">进度：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrRecruit.schedule}%
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(hrRecruit.status, 'recruit_status', '')}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">接收简历：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrRecruit.resumeNum}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">已面试：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrRecruit.interviewNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">已发送offer：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrRecruit.offerNum}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">已入职：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrRecruit.entryNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrRecruit.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrRecruit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrRecruit:edit">
			    	<a href="${ctx}/hr/hrRecruit/form?id=${hrRecruit.id}" class="btn btn-success" title="修改">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrRecruit:del">
				<c:if test="${hrRecruit.status == 0}">
					<a href="${ctx}/hr/hrRecruit/delete?id=${hrRecruit.id}" onclick="return confirmx('确认要删除该招聘任务吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
				</c:if>
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>