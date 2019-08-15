<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资表查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>工资表查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="searchForm" modelAttribute="hrSalary" action="${ctx}/hr/hrSalary/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							
		</form:form>
		
		<div class="form-horizontal">
			
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">计薪月：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalary.year}-${hrSalary.month}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">应出勤天数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalary.workDays}
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
							${fns:getDictLabel(hrSalary.status, 'audit_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrSalary.auditBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrSalary.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
							${hrSalary.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrSalary.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
		<h4 class="page-header"></h4>	
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">工资明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>序号</th>
								<th>姓名</th>
								<th>应出勤天数</th>
								<th>实际出勤天数</th>
								<th>加班天数</th>
								<th>请假天数</th>
								<th>旷工天数</th>
								<th>基本工资</th>
								<th>岗位工资</th>
								<th>奖金</th>
								<th>加班费</th>
								<th>应发合计</th>
								<th>社保</th>
								<th>公积金</th>
								<th>个税</th>
								<th>应扣工资</th>
								<th>实发工资</th>
								<th>状态</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${hrSalary.hrSalaryDetailList}" var="hrSalaryDetail" varStatus="status">
								<tr>
											<td>
												${status.index + 1}
											</td>
											<td>
												${hrSalaryDetail.name}
											</td>
											<td>
												${hrSalaryDetail.mustWorkDays}
											</td>
											<td>
												${hrSalaryDetail.realWorkDays}
											</td>
											<td>
												${hrSalaryDetail.extraWorkDays}
											</td>
											<td>
												${hrSalaryDetail.leaveDays}
											</td>
											<td>
												${hrSalaryDetail.absentDays}
											</td>
											<td>
												${hrSalaryDetail.baseSalary}
											</td>
											<td>
												${hrSalaryDetail.postSalary}
											</td>
											<td>
												${hrSalaryDetail.bonusSalary}
											</td>
											<td>
												${hrSalaryDetail.overtimeSalary}
											</td>
											<td>
												${hrSalaryDetail.shouldAmt}
											</td>
											<td>
												${hrSalaryDetail.socialAmt}
											</td>
											<td>
												${hrSalaryDetail.fundAmt}
											</td>
											<td>
												${hrSalaryDetail.taxAmt}
											</td>
											<td>
												${hrSalaryDetail.seductSalary}
											</td>
											<td>
												${hrSalaryDetail.realAmt}
											</td>
											<td>
												${hrSalaryDetail.status}
											</td>
											<td>
												${hrSalaryDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>					
					</div>
				</div>
			</div>
		</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<c:if test="${hrSalary.status == 0}">
				<shiro:hasPermission name="hr:hrSalary:edit">
			    	<a href="${ctx}/hr/hrSalary/form?id=${hrSalary.id}" class="btn btn-success" title="修改">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="hr:hrSalary:del">
					<a href="${ctx}/hr/hrSalary/delete?id=${hrSalary.id}" onclick="return confirmx('确认要删除该工资表吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
				</shiro:hasPermission>
				</c:if>
				
				<shiro:hasPermission name="hr:hrSalary:edit">
					<table:exportExcel url="${ctx}/hr/hrSalaryDetail/export?hrSalary.id=${hrSalary.id}"></table:exportExcel><!-- 导出按钮 -->
				</shiro:hasPermission>
				
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
			</div>
		</div>
	</div>
</div>
</div>


</body>
</html>