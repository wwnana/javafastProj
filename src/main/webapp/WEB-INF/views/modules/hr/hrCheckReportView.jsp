<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>月度打卡汇总查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>月度打卡汇总查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrCheckReport" action="${ctx}/hr/hrCheckReport/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">规则名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.groupname}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">用户id：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.userid}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">部门id：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.office.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">应打卡天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.attendanceDay}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">正常天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.normalDay}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">异常天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.abnormalDay}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">补卡：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.attendanceCard}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">年假：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.annualLeave}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">事假：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.unpaidLeave}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">病假：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.sickLeave}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">统计月份：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReport.checkMonth}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrCheckReport:edit">
			    	<a href="${ctx}/hr/hrCheckReport/form?id=${hrCheckReport.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrCheckReport:del">
					<a href="${ctx}/hr/hrCheckReport/delete?id=${hrCheckReport.id}" onclick="return confirmx('确认要删除该月度打卡汇总吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>