<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>简历查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrResume" action="${ctx}/hr/hrResume/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">招聘任务：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrResume.hrRecruit.id}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">简历来源 1:智联，2:51job, 3:拉钩，10：其他：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrResume.resumeSource, 'resume_source', '')}
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
							${hrResume.position}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">简历文件：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrResume.resumeFile}
							</p>
						</div>
					</div>
				</div>
			</div>
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
							${hrResume.sex}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">年龄：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrResume.age}
							</p>
						</div>
					</div>
				</div>
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
			</div>
			<div class="row">
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
			</div>
			<div class="row">
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
			</div>
			<div class="row">
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
			</div>
			<div class="row">
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
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrResume.currentNode, '', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrResume.resumeStatus, 'resume_status', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">面试状态：已邀约0，1已签到, 2已面试 3: 已取消：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrResume.interviewStatus, 'interview_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">录用状态：0待确认,1已接受, 2已入职,3已拒绝：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrResume.employStatus, 'employ_status', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">面试次数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrResume.interviewNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrResume.updateBy.id}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrResume.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
							${hrResume.remarks}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">基础用户表：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrResume.hrEmployeeId}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrResume:edit">
			    	<a href="${ctx}/hr/hrResume/form?id=${hrResume.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrResume:del">
					<a href="${ctx}/hr/hrResume/delete?id=${hrResume.id}" onclick="return confirmx('确认要删除该简历吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>