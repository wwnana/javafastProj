<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡汇总查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrCheckReportDay" action="${ctx}/hr/hrCheckReportDay/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			
			<div class="row">
            	<div class="pull-left">
            		<img alt="" src="${hrCheckReportDay.user.photo}" style="width: 50px;height: 50px">
            	</div>
            	<div class="media-body">
            		<h4>&nbsp;&nbsp;${hrCheckReportDay.user.name}</h4>
            		<p style="font-size: 13px;">&nbsp;&nbsp;部门：${hrCheckReportDay.office.name} | 所属规则：${hrCheckReportDay.groupname}</p>
            	</div>
           
            
            <!-- 表格 -->
				<div class="" style="padding-top: 10px">
				<table id="contentTable" class="table table-bordered">
					<thead>
						<tr>
							<%--<th><input type="checkbox" class="i-checks"></th>--%>

							<th width="100px">类型</th>
							<th width="100px">状态</th>
							<th width="80px">时间</th>
							<th width="300px">地点</th>
							<th width="100px">备注</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${hrCheckReportDetailList}" var="hrCheckReportDetail">
						<tr>
							<%--<td><input type="checkbox" id="${hrCheckReportDetail.id}" class="i-checks"></td>--%>
							<td>${hrCheckReportDetail.checkinType}</td>
							<td>
								<c:if test='${hrCheckReportDetail.checkinStatus==0}'>${fns:getDictLabel(hrCheckReportDetail.checkinStatus, 'checkin_status', '')}</c:if>
								<c:if test='${hrCheckReportDetail.checkinStatus==1}'>
									<span class="text-danger">${hrCheckReportDetail.exceptionType}</span>
								</c:if>
							</td>
							<td>
								<fmt:formatDate value="${hrCheckReportDetail.checkinDate}" pattern="HH:mm"/><c:if test="${empty hrCheckReportDetail.checkinDate}">--</c:if>
							</td>
							<td>
								<c:if test="${empty hrCheckReportDetail.locationTitle}">--</c:if>
								
								${hrCheckReportDetail.locationTitle}<br>${hrCheckReportDetail.locationDetail}
							</td>
							<td>
								${hrCheckReportDetail.notes}<c:if test="${empty hrCheckReportDetail.notes}">--</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
			</div>
            <%-- 
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrCheckReportDay.checkinDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.user.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.office.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">所属规则：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.groupname}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">最早：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrCheckReportDay.firstCheckinTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">最晚：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrCheckReportDay.lastCheckinTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">次数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.checkinNum}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">工作时长：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.workHours}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批单：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.hrApproval.id}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(hrCheckReportDay.checkinStatus, 'checkin_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">校准状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrCheckReportDay.auditStatus}
							</p>
						</div>
					</div>
				</div>
			</div>
			--%>
		</form:form>
	</div>
</body>
</html>