<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡明细查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>

	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrCheckReportDetail" action="${ctx}/hr/hrCheckReportDetail/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			
            <div class="row">
            	<div class="pull-left">
            		<img alt="" src="${hrCheckReportDetail.user.photo}" style="width: 40px;height: 40px">
            	</div>
            	<div class="media-body">
            		<strong>&nbsp;&nbsp;${hrCheckReportDetail.user.name}</strong>
            		<p class="form-control-static">&nbsp;&nbsp;${hrCheckReportDetail.office.name} | 所属规则：${hrCheckReportDetail.groupname}</p>
            	</div>
            	<h4 class="page-header"></h4>
            </div>
			
			
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">打卡类型：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrCheckReportDetail.checkinType}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">异常类型：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrCheckReportDetail.exceptionType}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">打卡时间：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							<fmt:formatDate value="${hrCheckReportDetail.checkinDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">地点：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrCheckReportDetail.locationTitle}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">详细地址：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${hrCheckReportDetail.locationDetail}
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
							${hrCheckReportDetail.notes}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">状态：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${fns:getDictLabel(hrCheckReportDetail.checkinStatus, 'checkin_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			
		</form:form>
	</div>
</body>
</html>