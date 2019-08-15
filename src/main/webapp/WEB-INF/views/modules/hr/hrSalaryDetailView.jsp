<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资明细查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>工资明细查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrSalaryDetail" action="" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">归属工资表：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.hrSalaryId}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">员工：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.hrEmployee.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">月份：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">应出勤天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.mustWorkDays}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">实际出勤天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.realWorkDays}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">加班天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.extraWorkDays}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.leaveDays}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">旷工天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.absentDays}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">基本工资：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.baseSalary}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">岗位工资：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.postSalary}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">奖金：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.bonusSalary}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">加班费：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.overtimeSalary}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">应发合计：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.shouldAmt}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">社保：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.socialAmt}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">公积金：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.fundAmt}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">个税：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.taxAmt}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">应扣工资：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.seductSalary}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">实发工资：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.realAmt}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.status}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">备注：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalaryDetail.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrSalaryDetail:edit">
			    	<a href="${ctx}/hr/hrSalaryDetail/form?id=${hrSalaryDetail.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrSalaryDetail:del">
					<a href="${ctx}/hr/hrSalaryDetail/delete?id=${hrSalaryDetail.id}" onclick="return confirmx('确认要删除该工资明细吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>