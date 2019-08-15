<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面试查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>面试查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrInterview" action="${ctx}/hr/hrInterview/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">姓名：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrInterview.hrResume.name} / ${hrInterview.hrResume.mobile} / ${hrInterview.hrResume.mail}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">应聘岗位：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrInterview.position}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">面试日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrInterview.linkMan}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系电话：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrInterview.linkPhone}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">面试地点：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrInterview.address}
							</p>
						</div>
					</div>
				</div>
			</div>
			<%-- 
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">签到状态 0： 未签到，1：已签到：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrInterview.signStatus, 'sign_status', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">签到时间1520：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrInterview.signTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			--%>
			<h4 class="page-header">面试反馈</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">面试官：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrInterview.interviewBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">反馈状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<c:if test="${hrInterview.status == 0}">未反馈</c:if>
								<c:if test="${hrInterview.status == 1}">已反馈</c:if>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">面试反馈：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrInterview.interviewNote}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">状态：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${fns:getDictLabel(hrInterview.inviteStatus, 'invite_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrInterview.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrInterview.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrInterview:edit">
			    	<a href="${ctx}/hr/hrInterview/form?id=${hrInterview.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrInterview:del">
					<a href="${ctx}/hr/hrInterview/delete?id=${hrInterview.id}" onclick="return confirmx('确认要删除该面试吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>