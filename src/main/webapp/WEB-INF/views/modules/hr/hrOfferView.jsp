<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>OFFER查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>OFFER查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrOffer" action="${ctx}/hr/hrOffer/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">姓名：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrOffer.hrResume.name} / ${hrOffer.hrResume.mobile} / ${hrOffer.hrResume.mail}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">抄送邮箱：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrOffer.readEmail}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">有效期(天)：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrOffer.validityPeriod}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">OFFER信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报到时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrOffer.reportDate}" pattern="yyyy-MM-dd HH:mm"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">试用期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrOffer.probationPeriod, 'probation_period', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">入职岗位：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrOffer.position}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">入职部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrOffer.department}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">公司地址：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrOffer.address}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">入职联系人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrOffer.linkMan}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系人电话：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrOffer.linkPhone}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">转正工资(元)：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrOffer.formalSalaryBase}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">试用期工资(元)：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrOffer.probationSalaryBase}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">薪酬备注：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrOffer.salaryRemarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">附件：</label>
						<div class="col-sm-10">
							<form:hidden id="offerFile" path="offerFile" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="offerFile" type="files" uploadPath="/file" selectMultiple="false" readonly="true"/>
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
							${fns:getDictLabel(hrOffer.status, 'invite_status', '')}
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
							${hrOffer.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrOffer.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrOffer:edit">
			    	<a href="${ctx}/hr/hrOffer/form?id=${hrOffer.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrOffer:del">
					<a href="${ctx}/hr/hrOffer/delete?id=${hrOffer.id}" onclick="return confirmx('确认要删除该OFFER吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>